kubectl delete -f services.yaml
kubectl delete -f deployment.yaml
kubectl delete -f ingress.yaml
kubectl delete -f service-monitor.yaml

#kubectl delete -f autoscaler.yaml