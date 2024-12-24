# Question 7 - Pods and Namespaces - 4%

- There are some webservers deployed on `saturn` *Namespace*, the only thing we know is the system is called `my-happy-shop`.
- Search for the correct *Pod* in the `saturn` *Namespace* and move it to `neptune` *Namespace*.
- It does not matter if you have to shut it down and spin it up again.

## Solution

<details>
  <summary>Show the solution</summary>

### List the Pods in saturn namespace

```shell
k -n saturn get pod
NAME                READY   STATUS    RESTARTS   AGE
webserver-sat-001   1/1     Running   0          9m18s
webserver-sat-002   1/1     Running   0          9m18s
webserver-sat-003   1/1     Running   0          9m18s
webserver-sat-004   1/1     Running   0          9m18s
webserver-sat-005   1/1     Running   0          9m18s
webserver-sat-006   1/1     Running   0          9m18s
webserver-sat-007   1/1     Running   0          9m18s
```

### Get the YAML definition of all Pods and filter by `my-happy-shop`

```shell
k -n saturn get pod -o yaml | grep my-happy-shop -A10
      description: this is the server for the E-Commerce System my-happy-shop
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{"description":"this is the server for the E-Commerce System my-happy-shop"},"labels":{"id":"webserver-sat-007"},"name":"webserver-sat-007","namespace":"saturn"},"spec":{"containers":[{"image":"nginx:1.16.1-alpine","imagePullPolicy":"IfNotPresent","name":"webserver-sat"}],"restartPolicy":"Always"}}
    creationTimestamp: "2024-12-14T23:27:47Z"
    labels:
      id: webserver-sat-007
    name: webserver-sat-007
    namespace: saturn
    resourceVersion: "24286"
    uid: 59b6dfad-57f0-45dc-9678-a8835cb66cb8
  spec:
    containers:
    - image: nginx:1.16.1-alpine
```

With the output of that command probably the `webserver-sat-007` *Pod* is the one we are looking for.

### Get the YAML definition of the webserver-sat-007 Pod

```shell
k -n saturn get pod webserver-sat-007 -o yaml > 7.yaml
```

Looking at in the `annotations` there is a `description` with the following value:

`this is the server for the E-Commerce System my-happy-shop`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    cni.projectcalico.org/containerID: 19442f19b375e0db2edbd0aa6d711333d0d0745c4791caa4eae30000ca65637c
    cni.projectcalico.org/podIP: 10.244.88.197/32
    cni.projectcalico.org/podIPs: 10.244.88.197/32
    description: this is the server for the E-Commerce System my-happy-shop
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{"description":"this is the server for the E-Commerce System my-happy-shop"},"labels":{"id":"webserver-sat-007"},"name":"webserver-sat-007","namespace":"saturn"},"spec":{"containers":[{"image":"nginx:1.16.1-alpine","imagePullPolicy":"IfNotPresent","name":"webserver-sat"}],"restartPolicy":"Always"}}
  creationTimestamp: "2024-12-14T23:27:47Z"
  labels:
    id: webserver-sat-007
  name: webserver-sat-007
  namespace: saturn
  resourceVersion: "24286"
  uid: 59b6dfad-57f0-45dc-9678-a8835cb66cb8
spec:
  containers:
  - image: nginx:1.16.1-alpine
    imagePullPolicy: IfNotPresent
    name: webserver-sat
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-2ttrc
      readOnly: true
```

### Change the namespace saturn to neptune in the YAML definition file

- Remove from the `7.yaml` file the `uuid` lines.
- Change `namespace: saturn` to `namespace: neptune`.
- Remove the `status` block.
- Save the file.

### Delete the existing webserver-sat-007 from saturn Namespace

```shell
k -n saturn delete pod webserver-sat-007
pod "webserver-sat-007" deleted
```

### Create the Pod webserver-sat-007 in neptune Namespace

```shell
k apply -f 7.yaml
pod/webserver-sat-007 created
```

### List the Pods in saturn Namespace

````shell
k -n saturn get pod
NAME                READY   STATUS    RESTARTS   AGE
webserver-sat-001   1/1     Running   0          26m
webserver-sat-002   1/1     Running   0          26m
webserver-sat-003   1/1     Running   0          26m
webserver-sat-004   1/1     Running   0          26m
webserver-sat-005   1/1     Running   0          26m
webserver-sat-006   1/1     Running   0          26m
````

### List the Pods in neptune Namespace

```shell
k -n neptune get pod
NAME                READY   STATUS    RESTARTS   AGE
webserver-sat-007   1/1     Running   0          66s
```

## Resources

- [Viewing and finding resources](https://kubernetes.io/docs/reference/kubectl/quick-reference/#viewing-and-finding-resources)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="06-readinessprobe.md" style="text-align: left;">&larr; Prev</a>
  <a href="08-deployments-and-rollouts.md" style="text-align: right;">Next &rarr;</a>
</div>