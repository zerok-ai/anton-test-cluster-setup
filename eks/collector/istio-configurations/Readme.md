# Install istio
```
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.14.1 sh -
cd istio-1.14.1
export PATH=$PWD/bin:$PATH
istioctl operator init
```

# Install istio operator
```
kubectl apply -f demo-profile.yaml
```

## Check the status
Run the following command and check the status column. The installation is ready once the status is `Healthy`

```
kubectl get iop -A
```

# Install prometheus and grafana
```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/prometheus.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/grafana.yaml
```

# Sample app
```
kubectl create deploy my-nginx --image=nginx
kubectl expose deployment my-nginx --type=LoadBalancer --name=my-nginx --port 80
```

# Sample load generator

```
n=1 ; while true ; do echo -n "Call #$n: " ; curl http://servicemesh.demo/home/ ;curl  http://servicemesh.demo/api/playlists/ ; sleep 1 ; n=$(( n + 1 )) ; done
```