#!/bin/zsh

check_docker() {
  if ! docker info >/dev/null 2>&1; then
    echo "Docker is not running. Please start Docker Desktop"
    exit 1
  fi
}

check_docker

echo 'delete images'
docker image rm localhost:5000/sun-cipher:latest >/dev/null 2>&1 || true

echo 'stop podman container'
podman container stop sun-cipher >/dev/null 2>&1 || true

echo 'delete container'
podman container rm sun-cipher >/dev/null 2>&1 || true

echo 'delete podman image'
podman image rm localhost:5000/sun-cipher:v1-podman >/dev/null 2>&1 || true

echo '⛔  shutting down podman registry'
podman-compose -f ~/podman-registry/podman-registry.yaml down >/dev/null 2>&1 || true

echo 'delete namespaces'
kubectl delete ns earth --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns jupiter --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns mars --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns mercury --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns moon --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns neptune --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns pluto --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns project-snake --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns saturn --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns sun --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete ns venus --force --grace-period=0 >/dev/null 2>&1 || true

echo 'delete resources from default namespace'
kubectl delete pod pod1 --force --grace-period=0 >/dev/null 2>&1 || true
kubectl delete pod pod6 --force --grace-period=0 >/dev/null 2>&1 || true

echo 'delete persistent volumes'
kubectl delete pv earth-project-earthflower-pv --force --grace-period=0 >/dev/null 2>&1 || true

echo 'delete storage class'
kubectl delete storageclass moon-retain --force --grace-period=0 >/dev/null 2>&1 || true

echo '⛔  Deleting labs files\n'
cd ../
rm -rf *.yaml *.log >/dev/null 2>&1 || true
