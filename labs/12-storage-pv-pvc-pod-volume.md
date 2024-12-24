# Question 12 - Storage, PV, PVC, and Pod Volume - 8%

- Create a new *PersistentVolume* named `earth-project-earthflower-pv`.
- It should have a capacity of `2Gi`, *accessMode* `ReadWriteOnce`, *hostPath* `/Volumes/Data`, and no `storageClassName` defined.
- Create a new *PersistentVolumeClaim* in *Namespace* `earth` named `earth-project-earthflower-pvc`. 
- It should request `2Gi` storage, *accessMode* `ReadWriteOnce` and should not define a *storageClassName*.
- The *PVC* should bound to the *PV* correctly.
- Create a new *Deployment* `project-earthflower` in *Namespace* `earth` which mounts that volume at `/tmp/project-data`.
- *Pods* of that *Deployment* should be of image `httpd:2.4.41-alpine`.

## Solution

<details>
  <summary>Show the solution</summary>

### Create the PersistentVolume

#### Get PersistentVolume Definition from Kubernetes Documentation

- Go to https://kubernetes.io/docs.
- Search for `PersistentVolume` yaml.
- Open the first link `Configure a Pod to Use a PersistentVolume for Storage`.
- Scroll down to `Create a PersistentVolume` and copy the YAML definition and update accordingly to the task.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: earth-project-earthflower-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/Volumes/Data"
```

#### Create the PersistentVolume YAML Definition

```shell
vim 12-pv.yaml
```

#### Apply the PersistentVolume YAML Definition

```shell
k apply -f 12-pv.yaml
persistentvolume/earth-project-earthflower-pv created
```

### Create the PersistentVolumeClaim

#### Get PersistentVolumeClaim Definition from Kubernetes Documentation

- In the same document scroll down to `Create a PersistentVolumeClaim` and copy the YAML definition and update accordingly to the task.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: earth-project-earthflower-pvc
  namespace: earth
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

#### Create the PersistentVolumeClaim YAML Definition

```shell
vim 12-pvc.yaml
```

#### Apply the PersistentVolumeClaim YAML Definition

```shell
k apply -f 12-pvc.yaml
persistentvolumeclaim/earth-project-earthflower-pvc created
```

#### List the PersistentVolumeClaim

```shell
k -n earth get pvc,pv
NAME                               STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/safari-pvc   Pending                                      standard       <unset>                 2m1s

NAME                         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
persistentvolume/safari-pv   2Gi        RWO            Retain           Available                          <unset>                          10m
```

### Create the Deployment YAML Definition

```shell
k -n earth create deploy project-earthflower --image=httpd:2.4.41-alpine -o yaml --dry-run=client > 12-deploy.yaml
```

Update `volumes` and `volumeMounts` entries.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: project-earthflower
  name: project-earthflower
  namespace: earth
spec:
  replicas: 1
  selector:
    matchLabels:
      app: project-earthflower
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: project-earthflower
    spec:
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: earth-project-earthflower-pvc
      containers:
      - image: httpd:2.4.41-alpine
        name: httpd
        resources: {}
        volumeMounts:
          - name: data
            mountPath: /tmp/project-data
status: {}
```

#### Apply the Deployment YAML Definition

```shell
k apply -f 12-deploy.yaml
deployment.apps/project-earthflower created
```

#### Validate the Deployment

```shell
k -n earth get deploy
NNAME                  READY   UP-TO-DATE   AVAILABLE   AGE
project-earthflower   1/1     1            1           24s
```

#### Validate the PersistentVolume and PersistentVolumeClaim

```shell
k -n earth get pv,pvc
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                                 STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
persistentvolume/earth-project-earthflower-pv               2Gi        RWO            Retain           Available                                                        <unset>                          16m
persistentvolume/pvc-74f8b50e-e2e2-4f15-98ed-35ee7afa6da7   2Gi        RWO            Delete           Bound       earth/earth-project-earthflower-pvc   standard       <unset>                          48s

NAME                                                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/earth-project-earthflower-pvc   Bound    pvc-74f8b50e-e2e2-4f15-98ed-35ee7afa6da7   2Gi        RWO            standard       <unset>                 11m
```

#### Validate the Deployment Pod Mount

Get the Deployment's Pods:

```shell
k -n earth get pod
NAME                                   READY   STATUS    RESTARTS   AGE
project-earthflower-8459866d9c-q5gpp   1/1     Running   0          114s
```

```shell
k -n earth describe pod project-earthflower-8459866d9c-q5gpp | grep -A2 Mounts:
    Mounts:
      /tmp/project-data from data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-vjkcd (ro)
```

## Resources

- [Create a PersistentVolume](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolume)
- [Create a PersistentVolumeClaim](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolumeclaim)
- [Creatre a Pod](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-pod)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="11-working-with-containers.md" style="text-align: left;">&larr; Prev</a>
  <a href="13-storage-storageclass-pvc.md" style="text-align: right;">Next &rarr;</a>
</div>