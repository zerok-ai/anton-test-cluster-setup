#! /bin/bash

kubectl apply -f highload-deployment.yaml
kubectl apply -f highload-services.yaml
kubectl apply -f highload-service-monitor.yaml
kubectl apply -f highload-ingress.yaml

# kubectl apply -f highload-autoscaler.yaml
