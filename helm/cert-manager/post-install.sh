#!/bin/zsh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

kubectl apply -f "$SCRIPTPATH/issuers/secret-cloudflare-token.yaml"
kubectl apply -f "$SCRIPTPATH/issuers/letsencrypt-staging.yaml"
kubectl apply -f "$SCRIPTPATH/certificates/staging/local-example-com.yaml"
kubectl apply -f "$SCRIPTPATH/issuers/letsencrypt-production.yaml"
kubectl apply -f "$SCRIPTPATH/certificates/production/local-example-com.yaml"