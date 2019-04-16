#!/bin/bash

## ** Script to deploy SocOps KB in Kubernetes Cluster ** ##
## ****************************************************** ##
 
install-prerequisites() {
  # Checking whether we have the required packages and installing those absent
  echo "dev"
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


## ** Commandline Switches ** ##
## ************************** ##
  

if [ $1 = "install-prerequisites" ]; then

  $1
  
elif [ $1 = "install-certman" ]; then

  $1

fi
