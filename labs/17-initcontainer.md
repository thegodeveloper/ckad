# Question 17 - InitContainer - 4%

## Task Definition

- There is a *Deployment* YAML definition at `labs/17/test-init-container.yaml` file.
- Create a copy of the file `labs/17/test-init-container.yaml` in `17-test-init-container.yaml` file.
- This *Deployment* spins up a single *Pod* of image `nginx:1.17.3-alpine` and serves files from a mounted volume, which is empty right now.
- Create an *initContainer* named `init-con` which also mounts that volume and creates a file `index.html` with content `check this out!` in the root of the mounted volume.
- For this test we ignore that it doesn't contain a valid HTML.
- The *initContainer* should be using image `busybox:1.31.0`.
- Test your implementation for example using `curl` from a temporary `nginx:alpine` Pod.

## Solution

<details>
  <summary>Show the solution</summary>

### Create a copy of the YAML file

````shell
cp labs/17/test-init-container.yaml 17-test-init-container.yaml
````

### Add the initContainer to 17-test-init-container.yaml file

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
  namespace: mars
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
        - name: web-content
          emptyDir: {}
      initContainers:                 # initContainer start
        - name: init-con
          image: busybox:1.31.0
          command: ['sh', '-c', 'echo "check this out!" > /tmp/web-content/index.html']
          volumeMounts:
            - name: web-content
              mountPath: /tmp/web-content # initContainer end
      containers:
        - image: nginx:1.17.3-alpine
          name: nginx
          volumeMounts:
            - name: web-content
              mountPath: /usr/share/nginx/html
          ports:
            - containerPort: 80
```

### Create the Deployment

```shell
k apply -f 17-test-init-container.yaml
deployment.apps/test-init-container created
```

### Test the configuration

#### Get the Pod IP

```shell
k -n mars get pod -o wide
NAME                                   READY   STATUS    RESTARTS   AGE    IP              NODE            NOMINATED NODE   READINESS GATES
test-init-container-7b988699d8-2vppn   1/1     Running   0          2m4s   10.244.235.15   k8s-c1-worker   <none>           <none>
```

#### Run the test with the alpine image

```shell
k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl 10.244.235.15
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    16  100    16    0     0  21108      0 --:--:-- --:--:-- --:--:-- 16000
check this out!
pod "tmp" deleted
```

## Resources

- [InitContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="16-logging-sidecar.md" style="text-align: left;">&larr; Prev</a>
  <a href="18-service-misconfiguration.md" style="text-align: right;">Next &rarr;</a>
</div>
