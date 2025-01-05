#!/bin/zsh

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

echo '⛔  Deleting Kubernetes clusters CKAD simulation\n'
kind delete cluster --name k8s-c1
