#create cluster
echo '---------------------- Creating cluster'

gcloud beta container \
    --project "black-scope-358204" clusters create "zerok-demo-cluster" \
    --zone "us-central1-c" --no-enable-basic-auth --cluster-version "1.22.11-gke.400" \
    --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" \
    --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --max-pods-per-node "110" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM \
    --enable-ip-alias --network "projects/black-scope-358204/global/networks/default" --subnetwork "projects/black-scope-358204/regions/us-central1/subnetworks/default" \
    --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
    --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes \
    --node-locations "us-central1-c"

# get cluster credentials in kubeconfig
gcloud components update
gcloud container clusters get-credentials "zerok-demo-cluster" --zone "us-central1-c"   


echo ''
echo '---------------------- Updating default-pool'
gcloud container node-pools update default-pool \
    --node-labels "role=system" \
    --zone "us-central1-c" \
    --cluster "zerok-demo-cluster" \
    --quiet

echo ''
echo '---------------------- Enabling autoscaling on default-pool'
gcloud container clusters update "zerok-demo-cluster" \
    --enable-autoscaling \
    --node-pool="default-pool" \
    --min-nodes=0 \
    --max-nodes=3 \
    --zone "us-central1-c"

echo ''
echo '---------------------- Creating worker cluster'
gcloud container node-pools create "worker" \
    --enable-autoscaling --min-nodes "0" --max-nodes "4" \
    --node-labels "role=worker" \
    --node-taints "dedicated=worker:NoSchedule" \
    --cluster "zerok-demo-cluster" --zone "us-central1-c" 


echo ''
echo '---------------------- Creating xk6 cluster'
gcloud container node-pools create "k6" \
    --num-nodes "1" \
    --node-labels "role=k6"\
    --cluster "zerok-demo-cluster" --zone "us-central1-c" \
    --image-type "UBUNTU_CONTAINERD" \
    --node-taints "dedicated=k6:NoSchedule" \
    --machine-type=custom-4-10240