#!/bin/zsh

## Docker Configuration
export DOCKER_CLI_HINTS=off

####### Create k8s-c1 cluster #######
echo '--------------------------------'
echo '👉 Connecting to Docker Desktop '
echo '--------------------------------'

echo '\n🚜 Initializing the Kubernetes cluster: docker-desktop...'

# Use context
kubectl config use-context docker-desktop >/dev/null 2>&1 || true

# Enable autocomplete in Kubernetes
autoload -Uz compinit
compinit
source <(kubectl completion zsh)

# Install Metrics Server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true
helm upgrade --install --set args={--kubelet-insecure-tls} metrics-server metrics-server/metrics-server --namespace kube-system >/dev/null 2>&1 || true

# Install Calico CNI for Network Policies
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml >/dev/null 2>&1 || true

# Install Ingress Nginx Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.hostNetwork=true --set controller.kind=DaemonSet >/dev/null 2>&1 || true

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
kubectl -n neptune create deployment api-new-c32 --image=bitnami/nginx:1.26.1 --replicas=3 >/dev/null 2>&1 || true
kubectl -n neptune rollout history deployment/api-new-c32 >/dev/null 2>&1 || true
kubectl -n neptune set image deployment/api-new-c32 nginx=bitnami/nginx:1.26.2 --record >/dev/null 2>&1 || true
kubectl -n neptune set image deployment/api-new-c32 nginx=bitnami/nginx:1.26.3 --record >/dev/null 2>&1 || true
kubectl -n neptune set image deployment/api-new-c32 nginx=bitnami/nginx:1.26.4 --record >/dev/null 2>&1 || true
kubectl -n neptune set image deployment/api-new-c32 nginx=bitnami/nginx:1.26.5 --record >/dev/null 2>&1 || true

# Lab 9
kubectl create namespace pluto >/dev/null 2>&1 || true
kubectl apply -f yaml-definitions/holy-api-pod.yaml >/dev/null 2>&1 || true

# Lab 11
mkdir -p ~/podman-registry/data >/dev/null 2>&1 || true
rm -rf ~/podman-registry/podman-registry.yaml >/dev/null 2>&1 || true
rm -rf ~/.config/containers/registries.conf >/dev/null 2>&1 || true
cp -f yaml-definitions/podman-registry.yaml ~/podman-registry/ >/dev/null 2>&1 || true
podman-compose -f ~/podman-registry/podman-registry.yaml up -d >/dev/null 2>&1 || true
mkdir -p ~/.config/containers >/dev/null 2>&1 || true
cp -f yaml-definitions/registries.conf ~/.config/containers/registries.conf >/dev/null 2>&1 || true
rm -rf ../labs/11/image/Dockerfile >/dev/null 2>&1 || true
cp ./dockerfiles/11-Dockerfile ../labs/11/image/Dockerfile >/dev/null 2>&1 || true

# Lab 12
kubectl create namespace earth >/dev/null 2>&1 || true

# Lab 13
kubectl create namespace moon >/dev/null 2>&1 || true

# Lab 14
kubectl apply -f yaml-definitions/secret-handler.yaml >/dev/null 2>&1 || true

# Lab 15
kubectl apply -f yaml-definitions/web-moon.yaml >/dev/null 2>&1 || true

# Lab 16
kubectl apply -f yaml-definitions/cleaner.yaml >/dev/null 2>&1 || true

# Lab 17
kubectl create namespace mars >/dev/null 2>&1 || true

# Lab 18
kubectl apply -f yaml-definitions/manager-api-deployment.yaml >/dev/null 2>&1 || true
kubectl apply -f yaml-definitions/manager-api-svc.yaml >/dev/null 2>&1 || true

# Lab 19
kubectl create namespace jupiter >/dev/null 2>&1 || true
kubectl -n jupiter create deployment jupiter-crew-deploy --image=bitnami/apache --replicas=1 >/dev/null 2>&1 || true
kubectl -n jupiter expose deployment jupiter-crew-deploy --name=jupiter-crew-svc --port=80 --target-port=80 >/dev/null 2>&1 || true

# Lab 20
kubectl create ns project-snake >/dev/null 2>&1 || true
kubectl -n project-snake run backend-0 --image=alpine/curl --labels app=backend --command -- /bin/sh -c "while true; do sleep 3600; done" >/dev/null 2>&1 || true
kubectl -n project-snake run db1-0 --image=hashicorp/http-echo --labels app=db1 --port=1111 -- --text="database one" --listen=:1111 >/dev/null 2>&1 || true
kubectl -n project-snake run db2-0 --image=hashicorp/http-echo --labels app=db2 --port=2222 -- --text="database two" --listen=:2222 >/dev/null 2>&1 || true
kubectl -n project-snake run vault-0 --image=hashicorp/http-echo --labels app=vault --port=3333 -- --text="vault secret storage" --listen=:3333 >/dev/null 2>&1 || true

# Lab 21
kubectl create namespace venus >/dev/null 2>&1 || true
kubectl -n venus run frontend --image=alpine/curl --labels app=frontend --command -- /bin/sh -c "while true; do sleep 3600; done" >/dev/null 2>&1 || true
kubectl -n venus run api --image=hashicorp/http-echo --labels app=api --port=2222 -- --text="You are connected to API" --listen=:2222 >/dev/null 2>&1 || true

# Lab 23
kubectl create namespace sun >/dev/null 2>&1 || true
kubectl -n sun run 0509649a --image=bitnami/nginx --port=80 --labels type=runner,type_old=messenger >/dev/null 2>&1 || true
kubectl -n sun run 0509649b --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true
kubectl -n sun run 1428721e --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true
kubectl -n sun run 1428721f --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true
kubectl -n sun run 43b9a --image=bitnami/nginx --port=80 --labels type=test >/dev/null 2>&1 || true
kubectl -n sun run 4c09 --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true
kubectl -n sun run 4c35 --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true
kubectl -n sun run 4fe4 --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true
kubectl -n sun run 5555a --image=bitnami/nginx --port=80 --labels type=messenger >/dev/null 2>&1 || true
kubectl -n sun run 86cda --image=bitnami/nginx --port=80 --labels type=runner >/dev/null 2>&1 || true
kubectl -n sun run 8d1c --image=bitnami/nginx --port=80 --labels type=messenger >/dev/null 2>&1 || true
kubectl -n sun run a004a --image=bitnami/nginx --port=80 --labels type=runner >/dev/null 2>&1 || true
kubectl -n sun run a94128196 --image=bitnami/nginx --port=80 --labels type=runner,type_old=messenger >/dev/null 2>&1 || true
kubectl -n sun run afd79200c56a --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true
kubectl -n sun run b667 --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true
kubectl -n sun run fdb2 --image=bitnami/nginx --port=80 --labels type=worker >/dev/null 2>&1 || true

echo '🚀 The Kubernetes cluster "docker-desktop" has been successfully prepared!\n'
