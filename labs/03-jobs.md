# Question 3 - Jobs - 2%

- Create a `Job` template named `job.yaml`.
- The `Job` should run image `busybox:1.31.0` and execute `sleep 7 && echo done`.
- Should be in namespace `neptune`.
- Run a total of `3` times and execute `2` runs in parallel. 
- Each `Pod` created by the `Job` should have the label `id: awesome-job`.
- The `Job` should be named `nep-new-job` and the container `nep-new-job-container`.

## Solution

<details>
  <summary>Show the solution</summary>

### Create a Pod definition

```shell
k -n neptune create job nep-new-job --image=busybox:1.31.0 --dry-run=client -o yaml > job.yaml -- sh -c "sleep 7 && echo done"
```

### Add container name to YAML definition

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null <-- remove this
  name: nep-new-job
  namespace: neptune
spec:
  completions: 3 # <-- add this
  parallelism: 2 # <-- add this
  template:
    metadata:
      creationTimestamp: null # <-- remove this
      labels: # <-- add this
        id: awesome-job # <-- add this
    spec:
      containers:
        - command:
            - sh
            - -c
            - sleep 7 && echo done
          image: busybox:1.31.0
          name: nep-new-job-container <-- change this
          resources: {}
      restartPolicy: Never
status: {} # <-- remove this
```

Final YAML definition:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: nep-new-job
  namespace: neptune
spec:
  completions: 3
  parallelism: 2
  template:
    metadata:
      labels:
        id: awesome-job
    spec:
      containers:
        - command:
            - sh
            - -c
            - sleep 7 && echo done
          image: busybox:1.31.0
          name: nep-new-job-container
          resources: {}
      restartPolicy: Never
```

### Apply the YAML definition

```shell
k apply -f job.yaml
job.batch/nep-new-job created
```

### Validate the Pods created by Job using the labels

```shell
 k -n neptune get pod -l id=awesome-job
NAME                READY   STATUS      RESTARTS   AGE
nep-new-job-2fcvj   0/1     Completed   0          57s
nep-new-job-2jvxq   0/1     Completed   0          70s
nep-new-job-v5bn6   0/1     Completed   0          70s
```

### Get the Pod container name of one of the pods

```shell
kubectl -n neptune get pod nep-new-job-2fcvj -o jsonpath='{.spec.containers[0].name}'
nep-new-job-container
```

## Resources

- [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- [Creating objects](https://kubernetes.io/docs/reference/kubectl/quick-reference/#creating-objects)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="02-pods.md" style="text-align: left;">&larr; Prev</a>
  <a href="04-helm-management.md" style="text-align: right;">Next &rarr;</a>
</div>