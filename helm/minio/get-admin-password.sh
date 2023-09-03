#!/bin/zsh
echo "Username: $(kubectl get secret --namespace minio minio -o jsonpath="{.data.root-user}" | base64 -d)"
echo "Password: $(kubectl get secret --namespace minio minio -o jsonpath="{.data.root-password}" | base64 -d)"