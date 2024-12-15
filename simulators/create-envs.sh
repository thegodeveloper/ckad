#!/bin/zsh

## Docker Configuration
export DOCKER_CLI_HINTS=off

####### Create k8s-c1 cluster #######
echo '--------------------------'
echo '👉 creating k8s-c1 cluster'
echo '--------------------------\n'

kind create cluster --name k8s-c1 --config yaml-definitions/cluster.yaml

echo '\n🚜 Initializing the Kubernetes cluster: k8s-c1...'

# Use context
kubectl config use-context kind-k8s-c1 >/dev/null 2>&1 || true

# Install Metrics Server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true
helm upgrade --install --set args={--kubelet-insecure-tls} metrics-server metrics-server/metrics-server --namespace kube-system >/dev/null 2>&1 || true

# Install Calico CNI for Network Policies
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml >/dev/null 2>&1 || true

# Install MetalLB
helm repo add metallb https://metallb.github.io/metallb >/dev/null 2>&1 || true
helm install metallb metallb/metallb -n metallb-system --create-namespace >/dev/null 2>&1 || true

# Extract the Kind network subnet
KIND_NETWORK=$(docker network inspect kind | jq -r '.[].IPAM.Config[].Subnet' | grep -E '^[0-9]')

# Verify the KIND_NETWORK is set
if [[ -z "$KIND_NETWORK" ]]; then
  echo "Error: KIND_NETWORK is empty. Ensure Kind is running and the subnet is configured."
  exit 1
fi

# Calculate the address range for MetalLB
IFS='/' read -r NETWORK_PREFIX NETWORK_MASK <<< "$KIND_NETWORK"
IFS='.' read -r A B C D <<< "$NETWORK_PREFIX"

# Use the last octet of the prefix to create an IP range
START_IP="${A}.${B}.${C}.200"
END_IP="${A}.${B}.${C}.250"

# Create the MetalLB configuration file
cat <<EOF > yaml-definitions/metallb-ip-address-pool.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: lb-pool
  namespace: metallb-system
spec:
  addresses:
  - ${START_IP}-${END_IP}
EOF

kubectl -n metallb-system wait --for=condition=Ready pods --all --timeout=300s >/dev/null 2>&1 || true

# Apply the MetalLB IP Address Pool to Kubernetes
kubectl apply -f yaml-definitions/metallb-ip-address-pool.yaml >/dev/null 2>&1 || true

# Apply the MetalLB L2 Configuration to Kubernetes
kubectl apply -f yaml-definitions/metallb-l2-config.yaml >/dev/null 2>&1 || true

# Install Ingress Nginx Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.hostNetwork=true --set controller.kind=DaemonSet >/dev/null 2>&1 || true

# Create entry in /etc/hosts for every node in the cluster
INGRESS_LB_IP=$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
docker exec -it k8s-c1-control-plane bash -c "echo '$INGRESS_LB_IP ckad.godeveloper.io' >> /etc/hosts" >/dev/null 2>&1 || true
docker exec -it k8s-c1-worker bash -c "echo '$INGRESS_LB_IP ckad.godeveloper.io' >> /etc/hosts" >/dev/null 2>&1 || true
docker exec -it k8s-c1-worker2 bash -c "echo '$INGRESS_LB_IP ckad.godeveloper.io' >> /etc/hosts" >/dev/null 2>&1 || true

# Lab 37
kubectl apply -f yaml-definitions/37.yaml >/dev/null 2>&1 || true

# Lab 3
kubectl create namespace neptune >/dev/null 2>&1 || true

# Lab 4
# Create the mercury namespace
kubectl create namespace mercury >/dev/null 2>&1 || true
# Add Bitnami repository
helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
# Install Nginx Helm Chart internal-issue-report-apiv1
helm -n mercury install internal-issue-report-apiv1 bitnami/nginx --version 18.2.4 >/dev/null 2>&1 || true
# Install Nginx Helm Chart internal-issue-report-apiv2
helm -n mercury install internal-issue-report-apiv2 bitnami/nginx --version 18.2.5 >/dev/null 2>&1 || true
# Install Nginx Helm Chart internal-issue-report-apiv3 on pending-install state
helm -n mercury install internal-issue-report-apiv3 bitnami/nginx --version 18.2.5 --set resources.requests.memory=10Ti --set resources.requests.cpu=1000 --wait --timeout 10s >/dev/null 2>&1 || true

# Lab 5
kubectl -n neptune create serviceaccount neptune-sa-v2 >/dev/null 2>&1 || true
kubectl -n neptune create secret generic neptune-sa-v2-token --type='kubernetes.io/service-account-token' --dry-run=client -o yaml | kubectl annotate --local -f - kubernetes.io/service-account.name=neptune-sa-v2 --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Lab 7
kubectl apply -f yaml-definitions/webserver-sat.yaml >/dev/null 2>&1 || true

# Lab 8
kubectl -n neptune create deployment api-new-c32 --image=nginx:1.26.1 --replicas=3 >/dev/null 2>&1 || true
kubectl -n neptune rollout history deployment/api-new-c32 >/dev/null 2>&1 || true
kubectl -n neptune set image deployment/api-new-c32 nginx=ngnix:1.26.2 --record >/dev/null 2>&1 || true
kubectl -n neptune set image deployment/api-new-c32 nginx=ngnix:1.26.3 --record >/dev/null 2>&1 || true
kubectl -n neptune set image deployment/api-new-c32 nginx=ngnix:1.26.4 --record >/dev/null 2>&1 || true
kubectl -n neptune set image deployment/api-new-c32 nginx=ngnix:1.26.5 --record >/dev/null 2>&1 || true

# Lab 9
kubectl create namespace pluto >/dev/null 2>&1 || true
kubectl apply -f yaml-definitions/holy-api-pod.yaml >/dev/null 2>&1 || true

echo '🚀 The Kubernetes cluster "k8s-c1" has been successfully prepared!\n'