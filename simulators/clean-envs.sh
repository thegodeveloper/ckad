#!/bin/zsh

echo '⛔  shutting down podman registry'
podman-compose -f ~/podman-registry/podman-registry.yaml down
echo ' '

echo '⛔  Deleting Kubernetes clusters CKAD simulation\n'
kind delete cluster --name k8s-c1
