#!/bin/zsh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml

kubectl delete -f "$SCRIPTPATH/issuers/secret-cloudflare-token.yaml"
kubectl delete -f "$SCRIPTPATH/issuers/letsencrypt-staging.yaml"
kubectl delete -f "$SCRIPTPATH/certificates/staging/k8s-local-darkanakin41-com.yaml"
kubectl delete -f "$SCRIPTPATH/issuers/letsencrypt-production.yaml"
kubectl delete -f "$SCRIPTPATH/certificates/production/k8s-local-darkanakin41-com.yaml"

kubectl delete namespace cert-manager