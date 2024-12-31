# Question 19 - Service ClusterIP - NodePort - 3%

- In *Namespace* `jupiter` you'll find an apache *Deployment* (with one replica) named `jupiter-crew-deploy`.
- The *Deployment* is exposed via `ClusterIP` *Service* called `jupiter-crew-svc`.
- Change this *Service* to a *NodePort* type to make it available on all nodes on port `30100`.
- Test the *NodePort Service* using the *Internal IP* of all available *Nodes* and use the port `30100` using `curl`.
- You can reach the internal *Node* IPs directly from your main terminal.
- On which *Nodes* is the *Service* reachable?
- On which *Node* is the *Pod* running?

## Solution

<details>
  <summary>Show the solution</summary>

### Get an overview of the resources

````shell
k -n jupiter get all
NAME                                      READY   STATUS    RESTARTS   AGE
pod/jupiter-crew-deploy-6d76489fd-kcm26   1/1     Running   0          9m18s

NAME                       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/jupiter-crew-svc   ClusterIP   10.96.90.144   <none>        80/TCP    9m18s

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/jupiter-crew-deploy   1/1     1            1           9m18s

NAME                                            DESIRED   CURRENT   READY   AGE
replicaset.apps/jupiter-crew-deploy-6d76489fd   1         1         1       9m18s
````

### Test the connection using the service

```shell
k -n jupiter run svc-test --restart=Never --image=nginx:alpine --rm -it -- curl 10.96.90.144
<html><body><h1>It works!</h1></body></html>
pod "svc-test" deleted
```

### Identify Deployment Labels

```shell
k -n jupiter get deploy jupiter-crew-deploy --show-labels
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
jupiter-crew-deploy   1/1     1            1           14m   app=jupiter-crew-deploy
```

### Edit the Service

```shell
k -n jupiter edit svc jupiter-crew-svc
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: "2024-12-31T04:57:01Z"
  labels:
    app: jupiter-crew-deploy
  name: jupiter-crew-svc
  namespace: jupiter
  resourceVersion: "1617"
  uid: 5ca3b1d8-6861-476e-9e73-8de12ff3c780
spec:
  clusterIP: 10.96.90.144
  clusterIPs:
  - 10.96.90.144
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 30100 # add the nodePort
  selector:
    app: jupiter-crew-deploy
  sessionAffinity: None
  type: NodePort # add the NodePort Type
status:
  loadBalancer: {}
  
service/jupiter-crew-svc edited
```

## Validate the Service

```shell
k -n jupiter get svc jupiter-crew-svc
NAME               TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
jupiter-crew-svc   NodePort   10.96.90.144   <none>        80:30100/TCP   20m
```

## Test the connection using the service

```shell
k -n jupiter run svc-test --restart=Never --image=nginx:alpine --rm -it -- curl 10.96.90.144
<html><body><h1>It works!</h1></body></html>
pod "svc-test" deleted
```

## Get Nodes IPs Addresses

```shell
k get nodes -o wide
NAME                   STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION     CONTAINER-RUNTIME
k8s-c1-control-plane   Ready    control-plane   25m   v1.31.2   172.18.0.3    <none>        Debian GNU/Linux 12 (bookworm)   6.10.14-linuxkit   containerd://1.7.18
k8s-c1-worker          Ready    <none>          25m   v1.31.2   172.18.0.2    <none>        Debian GNU/Linux 12 (bookworm)   6.10.14-linuxkit   containerd://1.7.18
k8s-c1-worker2         Ready    <none>          25m   v1.31.2   172.18.0.4    <none>        Debian GNU/Linux 12 (bookworm)   6.10.14-linuxkit   containerd://1.7.18
```

## Validate the connection using one node IP address

### Testing connection to k8s-c1-worker node

```shell
k -n jupiter run svc-test --restart=Never --image=nginx:alpine --rm -it -- curl 172.18.0.2:30100
<html><body><h1>It works!</h1></body></html>
pod "svc-test" deleted
```

### Testing connection to k8s-c1-worker2 node

```shell
k -n jupiter run svc-test --restart=Never --image=nginx:alpine --rm -it -- curl 172.18.0.4:30100
<html><body><h1>It works!</h1></body></html>
pod "svc-test" deleted
```

## Validate in which node the Pod is running

```shell
k -n jupiter get pods -o wide
NAME                                  READY   STATUS    RESTARTS   AGE   IP              NODE            NOMINATED NODE   READINESS GATES
jupiter-crew-deploy-6d76489fd-kcm26   1/1     Running   0          29m   10.244.235.14   k8s-c1-worker   <none>           <none>
```

## Resources

- [Choosing your own port](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport-custom-port)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="18-service-misconfiguration.md" style="text-align: left;">&larr; Prev</a>
  <a href="20-networkpolicy-egress-1.md" style="text-align: right;">Next &rarr;</a>
</div>
