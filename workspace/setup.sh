# Cluster over kind
brew install kind
kind create cluster --name istio --image kindest/node:v1.24.2

# Test workspace
docker run -it --rm -v ${HOME}:/root -v ${PWD}:/work -w /work --net host alpine sh -l

# Run the following inside the container
apk add --no-cache curl nano
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
export KUBE_EDITOR="nano"
apk update && apk add bash
