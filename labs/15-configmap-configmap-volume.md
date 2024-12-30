# Question 15 - ConfigMap, ConfigMap-Volume - 5%

- There is a Nginx Server *Deployment* called `web-moon` in *Namespace* moon.
- Someone started to configuring it but it was never completed.
- To complete the configuration, please create a *ConfigMap* called `configmap-web-moon-html` containing the content of the `labs/15/web-moon.html`, under the data key-name `index.html`.
- The *Deployment* `web-moon` is already configured to work with this *ConfigMap* and serve its content.
- Test the Nginx configuration for example using *curl* from a temporary `nginx:alpine` *Pod*.

## Solution

<details>
  <summary>Show the solution</summary>

### Check the Deployment and Pods

````shell
k -n moon get deploy,pods
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/web-moon   0/3     3            0           17m

NAME                            READY   STATUS              RESTARTS   AGE
pod/secret-handler              1/1     Running             0          110m
pod/web-moon-7f48dfbf67-8wg5w   0/1     ContainerCreating   0          16m
pod/web-moon-7f48dfbf67-k6d6l   0/1     ContainerCreating   0          16m
pod/web-moon-7f48dfbf67-wlk46   0/1     ContainerCreating   0          17m
````

### Describe a Pod

```shell
k -n moon describe pod web-moon-7f48dfbf67-8wg5w | grep -A10 Events:
Events:
  Type     Reason       Age                 From               Message
  ----     ------       ----                ----               -------
  Normal   Scheduled    18m                 default-scheduler  Successfully assigned moon/web-moon-7f48dfbf67-8wg5w to k8s-c1-worker
  Warning  FailedMount  18s (x17 over 18m)  kubelet            MountVolume.SetUp failed for volume "html-volume" : configmap "configmap-web-moon-html" not found
```

In the *Pod* Events you can see the message telling us that the `configmap-web-moon-html` *ConfigMap* is not found.


### Create the ConfigMap

It's very important to set the `index.html` key in the command.

```shell
k -n moon create configmap -h # run this command to get help

k -n moon create configmap configmap-web-moon-html --from-file=index.html=labs/15/web-moon.html
configmap/configmap-web-moon-html created
```

### Describe the ConfigMap

```shell
k -n moon describe configmap configmap-web-moon-html
Name:         configmap-web-moon-html
Namespace:    moon
Labels:       <none>
Annotations:  <none>

Data
====
index.html:
----
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Web Moon Webpage</title>
</head>
<body>
This is some great content.
</body>
</html>


BinaryData
====

Events:  <none>
```

### Validate the Deployment Pods and get IP address

```shell
k -n moon get pod -o wide
NAME                        READY   STATUS    RESTARTS   AGE    IP              NODE             NOMINATED NODE   READINESS GATES
secret-handler              1/1     Running   0          121m   10.244.88.199   k8s-c1-worker2   <none>           <none>
web-moon-7f48dfbf67-8wg5w   1/1     Running   0          27m    10.244.235.13   k8s-c1-worker    <none>           <none>
web-moon-7f48dfbf67-k6d6l   1/1     Running   0          27m    10.244.88.201   k8s-c1-worker2   <none>           <none>
web-moon-7f48dfbf67-wlk46   1/1     Running   0          28m    10.244.88.200   k8s-c1-worker2   <none>           <none>
```

### Check the result from one Pod

```shell
k -n moon run nginx-test --image=nginx:alpine --rm -it --restart=Never -- curl 10.244.235.13
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Web Moon Webpage</title>
</head>
<body>
This is some great content.
</body>
</html>pod "nginx-test" deleted
```

#### Validate the Deployment Events

```shell
k -n moon describe pod web-moon-7f48dfbf67-8wg5w | grep -A10 Events:
Events:
  Type     Reason       Age                   From               Message
  ----     ------       ----                  ----               -------
  Normal   Scheduled    32m                   default-scheduler  Successfully assigned moon/web-moon-7f48dfbf67-8wg5w to k8s-c1-worker
  Warning  FailedMount  9m55s (x19 over 32m)  kubelet            MountVolume.SetUp failed for volume "html-volume" : configmap "configmap-web-moon-html" not found
  Normal   Pulling      7m52s                 kubelet            Pulling image "nginx:latest"
  Normal   Pulled       7m48s                 kubelet            Successfully pulled image "nginx:latest" in 3.99s (3.99s including waiting). Image size: 72099410 bytes.
  Normal   Created      7m48s                 kubelet            Created container nginx
  Normal   Started      7m48s                 kubelet            Started container nginx
```

## Resources

- [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Create ConfigMaps from files](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-files)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="14-secret-secretvolume-secret-env.md" style="text-align: left;">&larr; Prev</a>
  <a href="" style="text-align: right;">Next &rarr;</a>
</div>
