# Question 9 - Pod to Deployment - 5%

- In *Namespace* `pluto` there is a single *Pod* named `holy-api`.
- Convert the *Pod* into a *Deployment* with `3` replicas and name `holy-api`.
- The raw *Pod* template file is available at `simulators/yaml-definitions/holy-api-pod.yaml`.
- In addition, the new *Deployment* should set `allowPrivilegeEscalation: false` and `privileged: false` for the security context on container level.
- Please create the *Deployment* and save its YAML under `9.yaml` file.

## Solution

<details>
  <summary>Show the solution</summary>

### List the Pod

```shell
k -n pluto get pod
NAME       READY   STATUS    RESTARTS   AGE
holy-api   1/1     Running   0          6m6s
```

### Copy the Pod definition file

```shell
cp simulators/yaml-definitions/holy-api-pod.yaml 9.yaml
```

### Convert the working file to Deployment

Editing using `vim` editor:

- Change *apiVersion:* to `apps/v1`.
- Change *kind:* to `Deployment`.
- After *namespace:* add:
  - `spec:` at same level of *metadata:*.
  - Add `template:` indented 2 spaces from the above *spec:*.
- The rest of the file is bad indented. From *Pod* `metadata:` to last line. Practice doing the following with `vim` editor:
  - Position the cursor in the `metadata:` below template.
  - Press `Shift + :`.
  - Write `:set shiftwidth=2` and press `Enter`.
  - Still positioned in the *Pod* `metadata:` line below the `template:`, press `Shift + v` to enter in `vim` visual mode.
  - Press `down arrow` to select all the lines bad indented (until the end).
  - Once they are selected press `>` to indent one time, we need one more, so press `.` (dot) to repeat the action.
- Write the file pressing `Shift + :` and writing `w` and press `Enter`.
- Continue editing the file.

Add *Deployment* configuration following the comments in the YAML definition:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    id: holy-api
  name: holy-api
  namespace: pluto
spec:
  replicas: 3 # add this line
  selector: # add this line
    matchLabels: # add this line
      id: holy-api # add this line
  template: 
    metadata: # From here corresponds to Pod definition
      labels:
        id: holy-api
      name: holy-api
      securityContext:
        allowPrivilegeEscalation: false # add this line
        privileged: false # add this line
    spec: 
      containers:
        - env:
            - name: CACHE_KEY_1
              value: b&MTCi0=[T66RXm!jO@
            - name: CACHE_KEY_2
              value: PCAILGej5Ld@Q%{Q1=#
            - name: CACHE_KEY_3
              value: 2qz-]2OJlWDSTn_;RFQ
          image: nginx:1.17.3-alpine
          name: holy-api-container
          volumeMounts:
            - mountPath: /cache1
              name: cache-volume1
            - mountPath: /cache2
              name: cache-volume2
            - mountPath: /cache3
              name: cache-volume3
      volumes:
        - emptyDir: {}
          name: cache-volume1
        - emptyDir: {}
          name: cache-volume2
        - emptyDir: {}
          name: cache-volume3
```

### Apply the Deployment Definition

```shell
k apply -f 9.yaml
deployment.apps/holy-api created
```

### Validate the Deployment

```shell
k -n pluto get deploy holy-api
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
holy-api   3/3     3            3           41s
```

### Validate Pods in the Deployment

```shell
k -n pluto get pods
NAME                        READY   STATUS    RESTARTS   AGE
holy-api                    1/1     Running   0          61m
holy-api-54d4c8cd79-6lqqh   1/1     Running   0          69s
holy-api-54d4c8cd79-hjgd5   1/1     Running   0          69s
holy-api-54d4c8cd79-vvz75   1/1     Running   0          69s
```

### Delete the Pod

````shell
k -n pluto delete pod holy-api --force --grace-period=0
pod "holy-api" deleted
````

### Validate the task

```shell
k -n pluto get deploy,pod
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/holy-api   3/3     3            3           3m41s

NAME                            READY   STATUS    RESTARTS   AGE
pod/holy-api-54d4c8cd79-6lqqh   1/1     Running   0          3m41s
pod/holy-api-54d4c8cd79-hjgd5   1/1     Running   0          3m41s
pod/holy-api-54d4c8cd79-vvz75   1/1     Running   0          3m41s
```

## Resources

- [Creating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment)
- [Set the security context for a Pod](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="08-deployments-and-rollouts.md" style="text-align: left;">&larr; Prev</a>
  <a href="10-services-and-logs.md" style="text-align: right;">Next &rarr;</a>
</div>