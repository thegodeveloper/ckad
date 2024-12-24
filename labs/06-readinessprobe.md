# Question 6 - ReadinessProbe - 7%

- Create a single *Pod* named `pod6` in *Namespace* `default` of image `busybox:1.31.0`.
- The *Pod* should have a `ReadinessProbe` executing `cat /tmp/ready`.
- It should initially wait `5` and periodically wait `10` seconds. This will set the container ready only if the file `/tmp/ready` exists.
- The `Pod` should run the command `touch /tmp/ready && sleep 1d`, which will create the necessary file to be ready and then idles.
- Create the *Pod* and confirm it starts.

## Solution

<details>
  <summary>Show the solution</summary>

### Create the Pod definition

```shell
k run pod6 --image=busybox:1.31.0 --dry-run=client -o yaml > 6.yaml
```

This command generates the following YAML definition:

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod6
  name: pod6
spec:
  containers:
  - image: busybox:1.31.0
    name: pod6
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

Edit the file according to the following:

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null # remove this line
  labels:
    run: pod6
  name: pod6
spec:
  containers:
  - image: busybox:1.31.0
    name: pod6
    args: # add the args block
      - "sh"
      - "-c"
      - "touch /tmp/ready && sleep 1d"
    resources: {}
    readinessProbe: # add the readinessProbe block
      exec:
        command:
          - "sh"
          - "-c"
          - "cat /tmp/ready"
      initialDelaySeconds: 5
      periodSeconds: 10
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {} # remove this line
```

#### Apply the YAML definition

```shell
k apply -f 6.yaml
pod/pod6 created
```

#### Validate if Pod is on ready state

```shell
k get pod pod6
NAME   READY   STATUS    RESTARTS   AGE
pod6   1/1     Running   0          66s
```

#### Validate the Readiness config

```shell
k describe pod pod6 | grep Readiness
Readiness:      exec [sh -c cat /tmp/ready] delay=5s timeout=1s period=10s #success=1 #failure=3
```
## Resources

- [Define a liveness command](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command)

**Note:**

- Use the liveness command example for readiness-probe configuration. Just change `livenessProbe` for `readinessProbe`.

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="05-serviceaccount-and-secret.md" style="text-align: left;">&larr; Prev</a>
  <a href="07-pods-and-namespaces.md" style="text-align: right;">Next &rarr;</a>
</div>