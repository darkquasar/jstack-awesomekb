
Install Cert Manager
====================

Using Old Method for deprecated Helm Chart
------------------------------------------

Useful for automatic SSL certificate renewals. 

* Info extracted from: https://akomljen.com/get-automatic-https-with-lets-encrypt-and-kubernetes-ingress/
* More in: https://itnext.io/automated-tls-with-cert-manager-and-letsencrypt-for-kubernetes-7daaa5e0cae4

Install Cert-Manager

helm install --name cert-manager \
    --namespace ingress \
    --set ingressShim.defaultIssuerName=letsencrypt-prod \
    --set ingressShim.defaultIssuerKind=ClusterIssuer \
    stable/cert-manager \
    --version v0.5.2

2. Create a ClusterIssuer

cat << EOF| microk8s.kubectl create -n ingress -f -
apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: something@test.com
    privateKeySecretRef:
      name: letsencrypt-prod
    http01: {}
EOF

Then simply add an annotation to your ingress with *kubernetes.io/tls-acme: "true"* and a secret will be automatically created.

Using the new chart officially maintained by Jetstack
-----------------------------------------------------

Install Cert-Manager

1. Follow steps in their official page (link --> https://docs.cert-manager.io/en/latest/getting-started/install.html):

# Install the CustomResourceDefinition resources separately
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/00-crds.yaml

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Label the cert-manager namespace to disable resource validation
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install --name certman \
  --namespace cert-manager \
  --set ingressShim.defaultIssuerName=letsencrypt-prod \
  --set ingressShim.defaultIssuerKind=ClusterIssuer \
  jetstack/cert-manager \
  --version v0.7.0


2. Create a ClusterIssuer

cat << EOF| microk8s.kubectl create -n ingress -f -
apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: something@test.com
    privateKeySecretRef:
      name: letsencrypt-prod
    http01: {}
EOF

Then simply add an annotation to your ingress with *certmanager.k8s.io/cluster-issuer: nameOfClusterIssuer* and a secret will be automatically created.

Refs: 
* https://docs.cert-manager.io/en/latest/tasks/issuing-certificates/ingress-shim.html

