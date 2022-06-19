dashboardName=$1

kubectl create configmap ${dashboardName} \
    --namespace monitoring \
	--from-file ../../grafana/${dashboardName}.json \
    -o yaml --dry-run=client | kubectl apply -f -

kubectl label --overwrite --namespace monitoring configmap \
    ${dashboardName} \
    grafana_dashboard="1" 