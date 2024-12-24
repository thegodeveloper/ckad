# Question 2 - Namespaces - 2%

- Create a `Pod` of image `httpd:2.4.41-alpine` in Namespace `default`.
- The `Pod` should be named `pod1` and the container should be named `pod1-container`.
- Write a command that shows the status of `pod1` in `pod1-status-command.sh`.

## Solution

<details>
  <summary>Show the solution</summary>

### Create a Pod definition

```shell
k run pod1 --image=httpd:2.4.41-alpine --dry-run=client -o yaml > 2.yaml
```

### Add container name to YAML definition

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod1
  name: pod1
spec:
  containers:
    - image: httpd:2.4.41-alpine
      name: pod1-container <-- add this
      resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
```

### Apply the YAML definition

```shell
k apply -f 2.yaml
pod/pod1 created
```

### Validate the Pod

```shell
k get pod pod1
NAME   READY   STATUS    RESTARTS   AGE
pod1   1/1     Running   0          40s
```

### Get the Pod container name

```shell
kubectl get pod pod1 -o jsonpath='{.spec.containers[0].name}'
```

## Write the command to show the pod1-container status

### Option 1

```shell
echo "kubectl get pod pod1 -o jsonpath='{.status.phase}'" > pod1-status-command.sh
```

```shell
sh pod1-status-command.sh
Running
```

### Option 2

```shell
echo "kubectl describe pod pod1 | grep -i Status:" > pod1-status-command.sh
```

```shell
sh pod1-status-command.sh
Status:           Running
```

## Resources

- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [View and finding resources](https://kubernetes.io/docs/reference/kubectl/quick-reference/#viewing-and-finding-resources)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="01-namespaces.md" style="text-align: left;">&larr; Prev</a>
  <a href="03-jobs.md" style="text-align: right;">Next &rarr;</a>
</div>
