#!/bin/zsh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

kubectl apply -f "$SCRIPTPATH/secret.yaml"
kubectl apply -f "$SCRIPTPATH/default-headers.yaml"
kubectl apply -f "$SCRIPTPATH/dashboard/ingress.yaml"
