#!/bin/bash

# Run this script from within jstack-awesomekb root folder

install_prerequisites() {
  # Assumed: git clone https://darkquasar@github.com/darkquasar/jstack-awesomekb
  
  sudo apt-get update \
  && sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
  && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  && sudo apt-get update \
  && sudo apt-get install -y docker-ce apache2-utils keychain \
  && sudo service docker start \
  && sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
  && sudo chmod +x /usr/local/bin/docker-compose \
  && sudo usermod -aG docker ${USER} \
  && echo "Let's create a simple user so that we can access MailCatcher later in the demo environment" \
  && sudo htpasswd -bcB docker/compose/nginx/portal/.htpasswd jaguarlord MyAwesomePassword
  
}

generate_documentation() {

  if [ ! $# = 1 ]; then
    
    echo "[J-Stack-AwesomeKB] Please provide a name for the virtual server you are trying to generate the output to (ex. awesomekb.jstack.com)"
    
    exit 1
    
  fi
  
  # 1. Generate the documentation
  #    This docker command will pull darkquasar/inca-sphinx:1.0.0 from DockerHub and build your documentation 
  #    Any errors or warnings will be written to ./docker/compose/nginx/backend/html/awesomekb/warnings.log
  docker run -v $(pwd)/docs:/docs/source -v $(pwd)/docker/compose/nginx/backend/html/$1:/docs/build darkquasar/inca-sphinx:1.0.0 sphinx-build -b html source build -w build/warnings.log

  # 2. Check whether documentation was properly generated
  if [ ! -f docker/compose/nginx/backend/html/$1/index.html ]; then
    echo "Documentation not generated! Check $(pwd)/docker/compose/nginx/backend/html/awesomekb/warnings.log Alternatively, run inca-sphinx in interactive mode and build your documentation that way. Be sure to map a volume to \"$(pwd)/docker/compose/nginx/backend/html/awesomekb\" which is where jstack-nginx-backend will search for the documents to be served by nginx. Exiting..."
    exit 1
  fi

}

run_kb() {

  generate_documentation awesomekb.jstack.com

  # 3. Run the KB stack
  cd docker && docker-compose up --build
}

replace_domain() {

  # This function will look into the nginx folder and replace any files 
  # containing the default "jstack.com" domain with the domain of your choosing.
  # Useful when you want to test jstack-awesomekb with your own domain or an 
  # AWS default one for example. 

  # Determining whether the script is being sourced or run in new shell
  # in order to assign $SCRIPTPATH
  if [ ! $0 = $BASH_SOURCE ]; then
    SCRIPTPATH="$( cd "$(dirname "$BASH_SOURCE")" ; pwd -P )"
  else
    SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
  fi
  
  find $SCRIPTPATH/docker/compose/nginx -type f -print0 | xargs -0 sed -i "s/jstack.com/$1/g"
  find $SCRIPTPATH/docker/compose/authelia -type f -print0 | xargs -0 sed -i "s/jstack.com/$1/g"
  sed -i "s/awesomekb.jstack.com/awesomekb.$1/g" $SCRIPTPATH/docker/docker-compose.yml
  
}

generate_certs() {

  # Determining whether the script is being sourced or run in new shell
  # in order to assign $SCRIPTPATH
  if [ ! $0 = $BASH_SOURCE ]; then
    SCRIPTPATH="$( cd "$(dirname "$BASH_SOURCE")" ; pwd -P )"
  else
    SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
  fi
  
  portal_serv_certpath=$SCRIPTPATH/docker/compose/nginx/portal/ssl

  # generate the private key
  openssl genrsa -out $portal_serv_certpath/server.key 4096
  # generate the certificate signing request
  openssl req -new -key $portal_serv_certpath/server.key -out $portal_serv_certpath/server.csr -subj "/C=AR/ST=Salta/L=Salta/O=J-Stack/CN=JS"
  # finally generate the certificate itself
  openssl x509 -req -sha256 -days 999 -in $portal_serv_certpath/server.csr -signkey $portal_serv_certpath/server.key -out $portal_serv_certpath/server.crt

}

deploy_all() {

  # Let's grab the public DNS name of the EC2 instance
  printf "\n[J-Stack-AwesomeKB] Grabbing your public DNS\n"
  publicdns=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
  publicipv4=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
  
  printf "\n[J-Stack-AwesomeKB] Installing pre-requisites\n"
  install_prerequisites
  
  printf "\n[J-Stack-AwesomeKB] Fixing environment so that $publicdns becomes your domain name\n"
  replace_domain $publicdns
  
  printf '\n[J-Stack-AwesomeKB] Done!, Now please reboot this instance so that we can apply some changes. Then in the host you are using to access the site from (were you launch your browser from) add these to your hosts file:\n\n%b login.%b \n%b ldapadmin.%b \n%b mailcatcher.%b \n%b awesomekb.%b\n\n' $publicipv4 $publicdns $publicipv4 $publicdns $publicipv4 $publicdns $publicipv4 $publicdns

}

git_pull_cron() {

  # This func requires that you have an SSH key already setup 
  # for secure GitHub connection. It looks for documentation
  # source .rst or .md files inside the repos "docs" folder.
  # If you call this function from within a cron job, make sure
  # you do it as the right user.
  
  # Dependencies: keychain needs to be installed to automate this process
  # Add "eval `keychain --eval id_rsa`" to your .bashrc
  
  # Run in background with: nohup ./deploy.sh git-pull &>/dev/null &
  # Add to Cron with "crontab -e" and run every minute with "* * * * * /home/[user]/[repo_folder]/deploy.sh git-pull-cron darkquasar/jstack-awesomekb awesomekb.jstack.com"
  
  # Changing directory to script one so that we can
  # run "git pull" inside it.
  # This should be the root dir of the repo containing
  # the ./docker and ./docs folders

  if [ ! $# = 2 ]; then
    
    printf "\n[J-Stack-AwesomeKB] Not enough arguments, please provide [name of repo to clone] and [name of html backend virtual server]\n"
    
    exit 1
    
  fi
  
  # Determining whether the script is being sourced or run in new shell
  # in order to assign $SCRIPTPATH
  if [ ! $0 = $BASH_SOURCE ]; then
    SCRIPTPATH="$( cd "$(dirname "$BASH_SOURCE")" ; pwd -P )"
  else
    SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
  fi
  
  cd $SCRIPTPATH
  
  eval `keychain --noask --eval id_rsa`
  
  repo=git@github.com:$1
  repo_name=$(echo $repo | grep -Pio "(?<=\/).*")
  target_folder=docsbuild-tmp
    
  if [ ! -d "$target_folder" ]; then
  
    # $2 name of the html virtual server in backend
    rm -rf docker/compose/nginx/backend/html/$2
    rm -rf docs/*

    git clone $repo $target_folder
    cp -r $target_folder/docs/* docs
  
  else
  
    # Update tmp repo
    printf "\n[J-Stack-AwesomeKB] Updating Docs Repo with Git Pull\n"
    cd $target_folder
    git stash save --keep-index
    gp=$(git pull | grep -io "up to date")
    
    if [ ! "$gp" = "up to date" ]; then
      printf "\n[J-Stack-AwesomeKB] Documentation Not Up to Date\n"
      printf "\n[J-Stack-AwesomeKB] Generating Documentation\n"
      cd $SCRIPTPATH # need to go up one level since we are inside docsbuild-tmp
      generate_documentation $2
    fi  
  
  fi
  
}

generate_sshkeys() {

  ssh-keygen -t rsa -b 4096 -C "admin@jstack.com"
  
}

removecontainers() {
  # Simple function to stop all containers
  docker stop $(docker ps -aq)
  docker rm $(docker ps -aq)
}
    
if [ $1 = "install-prerequisites" ]; then

  install_prerequisites
  
elif [ $1 = "run" ]; then

  run_kb
  
elif [ $1 = "replace-domain" ]; then
  
  if [ -z $2 ]; then
    echo "Please provide a domain to replace the default \"jstack.com\" with"
    exit 1
  fi
  
  replace_domain $2

elif [ $1 = "deploy-all" ]; then

  deploy_all
  
elif [ $1 = "generate-sshkeys" ]; then

  generate_sshkeys
  
elif [ $1 = "git-pull-cron" ]; then
  
  git_pull_cron $2 $3

elif [ $1 = "removecontainers" ]; then

  removecontainers

elif [ $1 = "gen-certs" ]; then

  generate_certs
  
fi