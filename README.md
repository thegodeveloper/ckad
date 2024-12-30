# Certified Kubernetes Application Developer (CKAD)

## Requirements

- Docker Desktop
- Kind (brew)
- Podman (brew)
- podman-compose (brew)

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

## Resources

- [Kubernetes Documentation](https://kubernetes.io/docs)
- [Kodekloud](https://kodekloud.com)
- [Certified Kubernetes Application Developer](https://www.udemy.com/course/mastering-certified-kubernetes-application-developer/)
- [Killer Shell (CKAD) - Videos](https://www.youtube.com/playlist?list=PLpbwBK0ptssyIgAoHR-611wt3O9wobS8T)
- [How to install Podman in Arch Linux](https://computingforgeeks.com/how-to-install-podman-on-arch-linux-manjaro/)