#! /bin/bash

kubectl delete -f highload-deployment.yaml
kubectl delete -f highload-services.yaml
kubectl delete -f highload-service-monitor.yaml

# kubectl delete -f highload-autoscaler.yaml
