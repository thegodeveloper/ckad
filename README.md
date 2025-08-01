# Certified Kubernetes Application Developer (CKAD)

The following was tested on the following machines and operating systems:

- MacBook Pro M3 64GB
- Huawei D15 Matebook 16GB with Debian 12 ★
- MinisForum Ryzen 7 64GB with Arch Linux
- MinisForum Ryzen 7 64GB with Pop OS
- Lenovo ThinkPad E16 Gen 2

## Requirements

- Docker Engine
- Kind (brew)
- Podman (brew)
- podman-compose (brew)
- kubernetes-cli (brew)
- kubectx (brew)
- Helm (brew)
- jq (brew)

## CKAD Notes

- The Certified Kubernetes Application Developer (CKAD) exam has 19 performance-based questions. 
- The exam is two hours long and is entirely command line based.

## Requirement for Podman in Pop OS

If you get the following error message for each `podman` command:

```shell
podman info
Error: command required for rootless mode with multiple IDs: exec: "newuidmap": executable file not found in $PATH
```

Install the `uidmap` package:

```shell
sudo apt install uidmap -y
```

Then run the `podman info` command, you should see the output:

```shell
host:
  arch: amd64
  buildahVersion: 1.40.1
  cgroupControllers:
  - memory
  - pids
  cgroupManager: systemd
  cgroupVersion: v2
...
```

## Configure auto-complete for kubectl

### Install the package in Pop OS

```shell
sudo apt install fd-find
```

### Configure .zshrc file

```shell
alias fd="fdfind"

autoload -Uz compinit
compinit

source <(kubectl completion zsh)
```

### Source the .zshrc file

```shell
source ~/.zshrc
```

The auto-completion should work with the `k` alias for `kubectl`. So, with the CKAD simulator deployed, if you run `k get ns s` and press `TAB`, you should see the following output:

```shell
 k get ns s
 saturn  sun
```

This command is listing all the `namespaces` that start with `s` and if you write `su` and press `TAB` key, it should auto complete to `sun`, because there are no more namespaces that start with `su`, there is only one match.

## Environment Configuration

```shell
alias k=kubectl
alias kc=kubectx
```

## Create the cluster

- Time to create: 6 minutes.

```shell
cd simulators
./create-envs.sh

--------------------------
👉 creating k8s-c1 cluster
--------------------------

Creating cluster "k8s-c1" ...
 ✓ Ensuring node image (kindest/node:v1.32.0) 🖼
 ✓ Preparing nodes 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-k8s-c1"
You can now use your cluster with:

kubectl cluster-info --context kind-k8s-c1

Have a nice day! 👋

🚜 Initializing the Kubernetes cluster: k8s-c1...
🚀 The Kubernetes cluster "k8s-c1" has been successfully prepared!
```

### Validate the current context

```shell
k config current-context
kind-k8s-c1
```

### Check cluster nodes

```shell
k get nodes
NAME                   STATUS   ROLES           AGE     VERSION
k8s-c1-control-plane   Ready    control-plane   3m39s   v1.32.0
k8s-c1-worker          Ready    <none>          3m23s   v1.32.0
k8s-c1-worker2         Ready    <none>          3m23s   v1.32.0
```

### Check cluster namespaces

```shell
kubectl get namspaces
NAME                 STATUS   AGE
default              Active   62m
earth                Active   60m
ingress-nginx        Active   61m
jupiter              Active   60m
kube-node-lease      Active   62m
kube-public          Active   62m
kube-system          Active   62m
local-path-storage   Active   62m
mars                 Active   60m
mercury              Active   61m
metallb-system       Active   62m
moon                 Active   60m
neptune              Active   61m
pluto                Active   60m
project-snake        Active   60m
saturn               Active   60m
sun                  Active   60m
venus                Active   60m
```

## Cheat-Sheets

Practice the `Cheat Sheet` the day before the exam.

- [Cheat Sheet](cheat_sheet.md)
- [Tmux Cheat Sheet](tmux_cheat_sheet.md)

## Labs

- [1. Namespaces - 1%](labs/01-namespaces.md)
- [2. Pods - 2 %](labs/02-pods.md)
- [3. Jobs - 2%](labs/03-jobs.md)
- [4. Helm Management - 5%](labs/04-helm-management.md)
- [5. ServiceAccount and Secret - 3%](labs/05-serviceaccount-and-secret.md)
- [6. ReadinessProbe - 7%](labs/06-readinessprobe.md)
- [7. Pods and Namespaces - 4%](labs/07-pods-and-namespaces.md)
- [8. Deployments and Rollouts - 4%](labs/08-deployments-and-rollouts.md)
- [9. Pod to Deployment - 5%](labs/09-pod-to-deployment.md)
- [10. Services and Logs - 4%](labs/10-services-and-logs.md)
- [11. Working with Containers - 7%](labs/11-working-with-containers.md)
- [12. Storage, PV, PVC, and Pod Volume - 8%](labs/12-storage-pv-pvc-pod-volume.md)
- [13. Storage, StorageClass, PVC - 6%](labs/13-storage-storageclass-pvc.md)
- [14. Secret, SecretVolume and Secret-Env - 4%](labs/14-secret-secretvolume-secret-env.md)
- [15. ConfigMap, ConfigMap-Volume - 5%](labs/15-configmap-configmap-volume.md)
- [16. Logging Sidecar - 6%](labs/16-logging-sidecar.md)
- [17. InitContainer - 4%](labs/17-initcontainer.md)
- [18. Service Misconfiguration - 4%](labs/18-service-misconfiguration.md)
- [19. Service ClusterIP - NodePort - 3%](labs/19-service-clusterip-nodeport.md)
- [20. NetworkPolicy Egress 1 - 9%](labs/20-networkpolicy-egress-1.md)
- [21. NetworkPolicy Egress 2 - 9%](labs/21-networkpolicy-egress-2.md)
- [22. Requests and Limits, ServiceAccount - 4%](labs/22-requests-and-limits-serviceaccount.md)
- [23. Labels and Annotations - 3%](labs/23-labels-and-annotations.md)

## Resources

- [Rancher Desktop Install](https://docs.rancherdesktop.io/getting-started/installation/)
- [Kubernetes Documentation](https://kubernetes.io/docs)
- [Kodekloud](https://kodekloud.com)
- [Certified Kubernetes Application Developer](https://www.udemy.com/course/mastering-certified-kubernetes-application-developer/)
- [Killer Shell (CKAD) - Videos](https://www.youtube.com/playlist?list=PLpbwBK0ptssyIgAoHR-611wt3O9wobS8T)
- [How to install Podman in Arch Linux](https://computingforgeeks.com/how-to-install-podman-on-arch-linux-manjaro/)
