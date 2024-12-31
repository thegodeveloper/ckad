# Question 22 - Requests and Limits, ServiceAccount - 9%

## Task Definition

- Create a *Deployment* named `neptune-10ab` with `3`replicas, set image to `httpd:2.4-alpine`.
- The containers should be named `neptune-pod-10ab`.
- Each container should have a memory request of `20Mi` and a memory limit of `50Mi`.
- The team has its own *ServiceAccount* `neptune-sa-v2` under which the *Pods* should run.
- The *Deployment* should be in *Namespace* `neptune`.

## Solution

<details>
  <summary>Show the solution</summary>

### Create the initial configuration of the Deployment

```shell
k -n neptune create deploy neptune-10ab --image=httpd:2.4-alpine --replicas=3 --dry-run=client -o yaml > 22.yaml
```

### Edit the YAML file

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: neptune-10ab
  name: neptune-10ab
  namespace: neptune
spec:
  replicas: 3
  selector:
    matchLabels:
      app: neptune-10ab
  strategy: {}
  template:
    metadata:
      labels:
        app: neptune-10ab
    spec:
      serviceAccountName: neptune-sa-v2 # add
      containers:
        - image: httpd:2.4-alpine
          name: neptune-pod-10ab
          resources: 
            limits:
              memory: 50Mi
            requests:
              memory: 20Mi
```

### Apply the YAML

```shell
k apply -f 22.yaml
deployment.apps/neptune-10ab created
```

### Validate the Pods

```shell
k -n neptune get pods -l app=neptune-10ab
NAME                            READY   STATUS    RESTARTS   AGE
neptune-10ab-747558cb5c-ddvgk   1/1     Running   0          6m50s
neptune-10ab-747558cb5c-r49dz   1/1     Running   0          6m50s
neptune-10ab-747558cb5c-v2ntf   1/1     Running   0          6m50s
```

### Validate Deployment Configuration

```shell
k -n neptune describe deployment neptune-10ab | grep Limits: -A5
    Limits:
      memory:  50Mi
    Requests:
      memory:      20Mi
    Environment:   <none>
    Mounts:        <none>
```

## Resources

- [Container resources example](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#example-1)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="21-networkpolicy-egress-2.md" style="text-align: left;">&larr; Prev</a>
  <a href="23-labels-and-annotations.md" style="text-align: right;">Next &rarr;</a>
</div>