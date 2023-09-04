#!/bin/zsh
echo "Password: $(kubectl get secret influxdb-influxdb2-auth -o "jsonpath={.data['admin-password']}" --namespace observability | base64 --decode)"
echo "Token: $(kubectl get secret influxdb-influxdb2-auth -o "jsonpath={.data['admin-token']}" --namespace observability | base64 --decode)"