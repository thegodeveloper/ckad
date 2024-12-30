# Question 16 - Logging Sidecar - 6%

- There is an existing container named `cleaner-con` in *Deployment* `cleaner` in *Namespace* `mercury`.
- This container mounts a volume and writes logs into a file called `cleaner.log`.
- The YAML definition for the existing *Deployment* is available at `simulators/yaml-definitions/cleaner.yaml` file. 
- Persist your changes at `cleaner-new.yaml` file but also make sure the *Deployment* is running.
- Create a *sidecar* container named `logger-con`, with the image `busybox:1.31.0`, which mounts the same volume and writes the content of `cleaner.log` to `stdout`, you can use `tail -f` command for this. 
- Create a `cleaner.log` file with the logs of the *sidecar* container from any of the *Deployment's Pod*.

## Solution

<details>
  <summary>Show the solution</summary>

### Create a copy of the YAML file

````shell
cp simulators/yaml-definitions/cleaner.yaml cleaner-new.yaml
````

### Validate the Deployment Pods

```shell
NAME                                                 READY   STATUS    RESTARTS   AGE   LABELS
cleaner-55c97f6d6b-lj98k                             1/1     Running   0          32s   id=cleaner,pod-template-hash=55c97f6d6b
cleaner-55c97f6d6b-vst9h                             1/1     Running   0          32s   id=cleaner,pod-template-hash=55c97f6d6b
internal-issue-report-apiv1-nginx-766f4d948-28n55    1/1     Running   0          21m   app.kubernetes.io/instance=internal-issue-report-apiv1,app.kubernetes.io/managed-by=Helm,app.kubernetes.io/name=nginx,app.kubernetes.io/version=1.27.2,helm.sh/chart=nginx-18.2.4,pod-template-hash=766f4d948
internal-issue-report-apiv2-nginx-6488479f56-tjzx2   1/1     Running   0          21m   app.kubernetes.io/instance=internal-issue-report-apiv2,app.kubernetes.io/managed-by=Helm,app.kubernetes.io/name=nginx,app.kubernetes.io/version=1.27.2,helm.sh/chart=nginx-18.2.5,pod-template-hash=6488479f56
internal-issue-report-apiv3-nginx-96448755-gb2kl     0/1     Pending   0          21m   app.kubernetes.io/instance=internal-issue-report-apiv3,app.kubernetes.io/managed-by=Helm,app.kubernetes.io/name=nginx,app.kubernetes.io/version=1.27.2,helm.sh/chart=nginx-18.2.5,pod-template-hash=96448755
```

```shell
NAME                       READY   STATUS    RESTARTS   AGE
cleaner-55c97f6d6b-lj98k   1/1     Running   0          74s
cleaner-55c97f6d6b-vst9h   1/1     Running   0          74s
```

### Add the sidecar definition to cleaner-new.yaml file

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cleaner
  namespace: mercury
spec:
  replicas: 2
  selector:
    matchLabels:
      id: cleaner
  template:
    metadata:
      labels:
        id: cleaner
    spec:
      volumes:
        - name: logs
          emptyDir: {}
      initContainers:
        - name: init
          image: bash:5.0.11
          command: ['bash', '-c', 'echo init > /var/log/cleaner/cleaner.log']
          volumeMounts:
            - name: logs
              mountPath: /var/log/cleaner
      containers:
        - name: cleaner-con
          image: bash:5.0.11
          args: ['bash', '-c', 'while true; do echo `date`: "remove random file" >> /var/log/cleaner/cleaner.log; sleep 1; done']
          volumeMounts:
            - name: logs
              mountPath: /var/log/cleaner
        - name: logger-con # add
          image: busybox:1.31.0 # add
          command: ["sh", "-c", "tail -f /var/log/cleaner/cleaner.log"] # add
          volumeMounts: # add
            - name: logs # add
              mountPath: /var/log/cleaner # add
```

### Apply the cleaner-new.yaml definition

```shell
k -n mercury apply -f cleaner-new.yaml
deployment.apps/cleaner configured
```

### Validate Deployment Pods

```shell
k -n mercury get pods -l id=cleaner
NAME                       READY   STATUS        RESTARTS   AGE
cleaner-55c97f6d6b-lj98k   1/1     Terminating   0          6m26s
cleaner-55c97f6d6b-vst9h   1/1     Terminating   0          6m26s
cleaner-8b4b66ddc-2gqxz    2/2     Running       0          28s
cleaner-8b4b66ddc-8q9hr    2/2     Running       0          23s
```

### Get logs from sidecar

```shell
k -n mercury logs cleaner-8b4b66ddc-2gqxz -c logger-con
init
Mon Dec 30 20:11:51 UTC 2024: remove random file
Mon Dec 30 20:11:52 UTC 2024: remove random file
Mon Dec 30 20:11:53 UTC 2024: remove random file
Mon Dec 30 20:11:54 UTC 2024: remove random file
Mon Dec 30 20:11:55 UTC 2024: remove random file
```

### Create the cleaner.log file

```shell
k -n mercury logs cleaner-8b4b66ddc-2gqxz -c logger-con > cleaner.log
```

## Resources

- [Sidecar Containers](https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="15-configmap-configmap-volume.md" style="text-align: left;">&larr; Prev</a>
  <a href="" style="text-align: right;">Next &rarr;</a>
</div>
