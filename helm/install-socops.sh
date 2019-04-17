#!/bin/bash

## ** Script to deploy SocOps KB in Kubernetes Cluster ** ##
## ****************************************************** ##
 
install-prerequisites() {
  # Checking whether we have the required packages and installing those absent
  
  # Installing YQ to edit yaml files
  sudo add-apt-repository ppa:rmescandon/yq
  sudo apt update
  sudo apt install yq -y
}

install-certman() {
  ## Function to install Cert Manager
  ## ref: https://docs.cert-manager.io/en/latest/getting-started/install.html
  
  # Install the CustomResourceDefinition resources first
  kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/00-crds.yaml

  # Create the namespace for cert-manager
  kubectl create namespace cert-manager

  # Label the cert-manager namespace to disable resource validation
  kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true

  # Add the Jetstack Helm repository
  helm repo add jetstack https://charts.jetstack.io

  # Update your local Helm chart repository cache
  helm repo update

  # Install Cert-Manager using Helm repo
  helm install --name certman \
    --namespace cert-manager \
    --set ingressShim.defaultIssuerName=letsencrypt-prod \
    --set ingressShim.defaultIssuerKind=ClusterIssuer \
    jetstack/cert-manager \
    --version v0.7.0

  # Finally, the ClusterIssuer is installed automatically if .Values.global.certman.deployacmeclusterissuer = true

}

gen-passwords (
  ## This function will generate random 32 bytes hex strings
  # Called to generate the passwords for some components
  # when their Helm Chart randomly generated ones are too weak
  
  authelia=$(yq r socops/values.yaml authelia.enabled)
  
  if [ $authelia = "true" ]; then

    for i in "redis.password" "openldap.env.adminPassword" "mongodb.mongodbRootPassword"; do

      # Updating default passwords in values.yaml
      yq w -i socops/values.yaml $i $(uuidgen | sed -e 's/-//g')
      authconfpass=$(yq r socops/values.yaml $i)
      
      # Now let's update Authelia's Config based on the updated password in Values.yaml
      if [[ $i == *"ldap"* ]]; then
        yq w -i socops/charts/authelia/files/authelia-config.yml ldap.password $(uuidgen | sed -e 's/-//g')
      elif [[ $i == *"redis"* ]]; then
        yq w -i socops/charts/authelia/files/authelia-config.yml session.redis.password $(uuidgen | sed -e 's/-//g')
      elif [[ $i == *"mongodb"* ]]; then
        yq w -i socops/charts/authelia/files/authelia-config.yml storage.mongo.auth.password $(uuidgen | sed -e 's/-//g')
      fi

    done

  fi
)

## ** Commandline Switches ** ##
## ************************** ##
  

if [ $1 = "install-prerequisites" ]; then

  $1
  
elif [ $1 = "install-certman" ]; then

  $1

elif [ $1 = "gen-passwords" ]; then

  $1

fi
