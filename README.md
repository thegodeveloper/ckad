# Certified Kubernetes Application Developer (CKAD)

## Requirements

- Docker Desktop
- Kind

## Environment Configuration

```shell
alias k=kubectl
```

## Create the cluster

```shell
cd simulators
./create-envs.sh

--------------------------
👉 creating k8s-c1 cluster
--------------------------

Creating cluster "k8s-c1" ...
 ✓ Ensuring node image (kindest/node:v1.31.2) 🖼
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
k8s-c1-control-plane   Ready    control-plane   3m39s   v1.31.2
k8s-c1-worker          Ready    <none>          3m23s   v1.31.2
k8s-c1-worker2         Ready    <none>          3m23s   v1.31.2
```

## Labs

- [Namespaces - 1%](labs/01-namespaces.md)
- [Pods - 2 %](labs/02-pods.md)
- [Jobs - 2%](labs/03-jobs.md)
- [Helm Management - 5%](labs/04-helm-management.md)

## Resources

- [Kubernetes Documentation](https://kubernetes.io/docs)
- [Kodekloud](https://kodekloud.com)
- [Certified Kubernetes Application Developer](https://www.udemy.com/course/mastering-certified-kubernetes-application-developer/)