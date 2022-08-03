#create cluster
echo '---------------------- Creating cluster'

# create cluster
gcloud beta container \
    --project "black-scope-358204" clusters create "zerok-demo-cluster" \
    --zone "us-central1-c" --no-enable-basic-auth --cluster-version "1.22.10-gke.600" \
    --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" \
    --disk-type "pd-standard" --disk-size "30" --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --max-pods-per-node "110" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM \
    --enable-ip-alias --network "projects/black-scope-358204/global/networks/default" --subnetwork "projects/black-scope-358204/regions/us-central1/subnetworks/default" \
    --no-enable-intra-node-visibility --default-max-pods-per-node "110" --enable-autoscaling \
    --min-nodes "0" --max-nodes "8" --no-enable-master-authorized-networks \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
    --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
    --enable-autoprovisioning --min-cpu 2 --max-cpu 6 --min-memory 8 --max-memory 24 \
    --enable-autoprovisioning-autorepair --enable-autoprovisioning-autoupgrade --autoprovisioning-max-surge-upgrade 1 \
    --autoprovisioning-max-unavailable-upgrade 0 --autoscaling-profile optimize-utilization \
    --enable-vertical-pod-autoscaling --enable-shielded-nodes --node-locations "us-central1-c"

# get cluster credentials in kubeconfig
gcloud container clusters get-credentials "zerok-demo-cluster" --zone "us-central1-c"



gcloud container clusters update "zerok-demo-cluster" \
    --min-nodes "0" --max-nodes "8"


gcloud container clusters update "zerok-demo-cluster" \
    --enable-autoscaling \
    --node-pool="default-pool" \
    --min-nodes=0 \
    --max-nodes=8 \
    --zone "us-central1-c"