# Question 18 - Service Misconfiguration - 4%

- There seems to be an issue in *Namespace* `mars` where the *ClusterIP* service `manager-api-svc` should make the *Pods* of *Deployment* `manager-api-deployment` available inside the cluster.
- You can test this with `curl manager-api-svc.mars:4444` from a temporary `nginx:alpine` *Pod*. 
- Check for misconfiguration and apply a fix. 

## Solution

<details>
  <summary>Show the solution</summary>

### Get the overview of the resources

````shell
k -n mars get all
NAME                                          READY   STATUS    RESTARTS   AGE
pod/manager-api-deployment-796ccdf46d-b9rn6   1/1     Running   0          7m3s
pod/manager-api-deployment-796ccdf46d-gzsph   1/1     Running   0          7m3s
pod/manager-api-deployment-796ccdf46d-x2hsn   1/1     Running   0          7m3s
pod/manager-api-deployment-796ccdf46d-zp9vl   1/1     Running   0          7m3s
pod/test-init-container-7b988699d8-2vppn      1/1     Running   0          23m

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/manager-api-svc   ClusterIP   10.96.157.185   <none>        4444/TCP   6m50s

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/manager-api-deployment   4/4     4            4           7m3s
deployment.apps/test-init-container      1/1     1            1           23m

NAME                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/manager-api-deployment-796ccdf46d   4         4         4       7m3s
replicaset.apps/test-init-container-7b988699d8      1         1         1       23m
````

### Test the connection using the service

```shell
k -n mars run manager-test --restart=Never --image=nginx:alpine --rm -it -- curl manager-api-svc.mars:4444
curl: (7) Failed to connect to manager-api-svc.mars port 4444 after 2 ms: Could not connect to server
pod "manager-test" deleted
pod mars/manager-test terminated (Error)
```

### Identify the Pods IP Addresses

```shell
k -n mars get pods -o wide
NAME                                      READY   STATUS    RESTARTS   AGE   IP              NODE             NOMINATED NODE   READINESS GATES
manager-api-deployment-796ccdf46d-b9rn6   1/1     Running   0          10m   10.244.235.20   k8s-c1-worker    <none>           <none>
manager-api-deployment-796ccdf46d-gzsph   1/1     Running   0          10m   10.244.235.19   k8s-c1-worker    <none>           <none>
manager-api-deployment-796ccdf46d-x2hsn   1/1     Running   0          10m   10.244.88.207   k8s-c1-worker2   <none>           <none>
manager-api-deployment-796ccdf46d-zp9vl   1/1     Running   0          10m   10.244.88.206   k8s-c1-worker2   <none>           <none>
test-init-container-7b988699d8-2vppn      1/1     Running   0          27m   10.244.235.15   k8s-c1-worker    <none>           <none>
```

### Test connection to one Pod

```shell
k -n mars run manager-test --restart=Never --image=nginx:alpine --rm -it -- curl 10.244.235.20
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
pod "manager-test" deleted
```

Pods are responding correctly, so the problem should be in the *Service* configuration.

### Describe the Deployment and Service labels configuration

#### Deployment Labels Configuration

```shell
k -n mars describe deploy manager-api-deployment | grep Labels: -A5
Labels:                 app=manager-api-pod
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=manager-api-pod
Replicas:               4 desired | 4 updated | 4 total | 4 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
--
  Labels:  app=manager-api-pod
  Containers:
   nginx:
    Image:         nginx
    Port:          80/TCP
    Host Port:     0/TCP
```

#### Service Labels Configuration

```shell
k -n mars describe service manager-api-svc | grep Labels: -A5
Labels:                   app=manager-api-deployment
Annotations:              <none>
Selector:                 app=manager-api-deployment
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
```

The *Service* `Selector` is misconfigured.

### Fix the Service Labels

```shell
k -n mars edit svc manager-api-svc
    #id: manager-api-deployment # wrong selector
    id: manager-api-pod
    
service/manager-api-svc edited
```

### Get the Endpoints

```shell
k -n mars get ep
NAME              ENDPOINTS                                                        AGE
manager-api-svc   10.244.235.19:80,10.244.235.20:80,10.244.88.206:80 + 1 more...   19m
```

### Check the service connection

```shell
k -n mars run manager-test --restart=Never --image=nginx:alpine --rm -it -- curl manager-api-svc.mars:4444
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
pod "manager-test" deleted
```

## Resources

- [Service](https://kubernetes.io/es/docs/concepts/services-networking/service/)
- [Endpoints](https://kubernetes.io/docs/concepts/services-networking/service/#endpoints)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="17-initcontainer.md" style="text-align: left;">&larr; Prev</a>
  <a href="" style="text-align: right;">Next &rarr;</a>
</div>
