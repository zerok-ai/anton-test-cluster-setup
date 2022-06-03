#! /bin/bash

kubectl apply -f deployment.yaml
kubectl apply -f services.yaml
kubectl apply -f service-monitor.yaml
kubectl apply -f ingress.yaml

# kubectl apply -f autoscaler.yaml
