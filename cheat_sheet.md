# CKAD Cheat Sheet

List of the most used commands during `CKAD` exam.

## Create an alias for kubectl command

During the exam the `alias` is already set, so it is good to get used to this alias.

```shell
alias k=kubectl
```

## Kubectl Commands

### Create a Pod using kubectl

```shell
k run nginx-web --image=nginx --port=80
```

### Create a Pod using kubectl with labels

```shell
k run nginx-web --image=nginx --port=80 --labels app=nginx-web
```

### Expose a Pod with a Kubernetes Service

```shell
k expose pod nginx-web --name=nginx-web-svc --port=7777 --target-port=80 type=(LoadBalancer,NodePort,ClusterIP)
```

### Create a Pod, run a command, delete the Pod

```shell
k run test-pod --image=nginx:alpine --restart=Never --rm -it -- curl -s http://service-url-to-test:port_number
```

### Generate a Pod YAML definition with kubectl

```shell
k run nginx-web --image=nginx --port=80 --dry-run=client -o yaml > question#.yaml
```

### Generate a Deployment YAML definition with kubectl

```shell
k -n namespace_name create deploy deployment_name --image=nginx --dry-run=client -o yaml > question#.yaml
```

### Get the status of a Pod

```shell
k get pod -o jsonpath="{.status.phase}"
```

### List Pods with a specific labels

```shell
k -n namespace_name get pod -l key_name=value
```

### Add labels to Pods with specific label

```shell
k -n namespace_name label pod -l "type in (worker,runner)" protected=true

protected: true is the additional label to be applied to Pods with labels type=worker or type=runner
```

### Create a Job YAML definition with kubectl

This command has two sections, the creation of the YAML definition until `question#.yaml` and the `--` to set a `command` to run, in this case `sleep 7 && echo done`.

```shell
k create job job-name --image=busybox --dry-run=client -o yaml > question#.yaml -- sh -c "sleep 7 && echo done"
```

### Delete a Pod without waiting

```shell
k delete pod pod_name --force --grace-period=0
```

### Get a token from a secret

```shell
k -n namespace_name get secret secret_name -o jsonpath="{.data.token}" | base64 -d
```

### Search a value in all existing Pods

```shell
k -n namespace_name get pod -o yaml | grep value_to_search -A5
```

### Check Deployment history

```shell
k rollout history deploy deployment_name
```

### Rollback to a working revision

```shell
k rollout undo deploy deployment_name --to-revision=1
```

### Create a Secret

```shell
k create secret secret_name --from-literal=key=value --from-literal=key=value
```

### Execute a command in a running Pod

```shell
k -n namespace_name exec pod_name -- env | grep VAR_NAME
```

### Create a ConfigMap with a custom key_name and value from a file

```shell
k -n namespace_name create configmap configmap_name --from-file=key-name=path-to-file

key-name could be = index.html
```

### List Deployment Labels

```shell
k -n namespace_name get deploy deployment_name --show-labels
```

### Get logs from a sidecar

```shell
k -n namespace_name logs pod_name -c container_name
```

## Helm Commands

### List Helm releases on a Namespace

```shell
helm -n namespace_name list
```

### List Helm repositories

```shell
helm repo list
```

### List Helm releases of a repo

```shell
helm search repo bitnami/nginx
```

### Get Helm Chart values

```shell
helm show values bitnami/apache | grep replica
```

### Upgrade Helm release

```shell
helm -n namespace_name upgrade custom_release_name bitnami/nginx
```

### Install Helm Chart

```shell
helm -n namespace_name install custom_release_name bitnami/nginx --set replicaCount=2
```

## Docker Commands

### Build Image with Docker

```shell
docker build -t localhost:5000/image_name:latest -t localhost:5000/image_name:tag_name . (be aware of the ending dot)
```

### List Docker Images

```shell
docker image ls | grep image_name
```

## Podman Commands

### Build Image with Podman

```shell
podman build -t localhost:5000/image_name:latest . (be aware of the ending dot)
```

### List Podman Images

```shell
podman image ls | grep image_name
```

### Push Image with Podman

```shell
podman push localhost:5000/image_name:latest
```

### List Podman Containers Running

```shell
podman ps -a 
```