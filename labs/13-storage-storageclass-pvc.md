# Question 13 - Storage, StorageClass, and PVC - 6%

- Create a *StorageClass* named `moon-retain`, with the provisioner `moon-retainer` and `reclaimPolicy` as `Retain`.
- Create a new *PersistentVolumeClaim* in *Namespace* `moon` named `moon-pvc-126`. 
- It should request `3Gi` for storage, set the *accessMode* to `ReadWriteOnce` and it should use the new *storageClass*.
- The *Provisioner* `moon-retainer` will be created by another team, so it's expected that the *PVC* will not boot yet.
- Confirm this by writing the log message from the *PVC* into file `13-reason.txt`. 

## Solution

<details>
  <summary>Show the solution</summary>

### Create the StorageClass

- Go to Kubernetes documentation an search for `StorageClass`.
- Select the first link `Storage Class | Kubernetes`.
- Go to `StorageClass objects` and copy the YAML definition until `reclaimPolicy`.
- Set the `name` to `moon-retain`.
- Remove the `annotations`.
- Change the `provisioner` to `moon-retainer`.
- The `reclaimPolicy` is currently set to the requested value.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: low-latency
provisioner: moon-retainer
reclaimPolicy: Retain
```

Create the `13-sc.yaml` file.

#### Apply the StorageClass YAML file

```shell
k apply -f 13-sc.yaml
storageclass.storage.k8s.io/low-latency created
```

### Create the PersistentVolumeClaim

- Go to Kubernetes documentation and search for `PersistentVolumeClaim`.
- Press the link `Configure a Pod to Use a PersistentVolume for Storage | Kubernetes`.
- Go to `Create a PersistentVolumeClaim` section.
- Copy the `PersistentVolumeClaim` YAML definition.
- Change the `name` to `moon-pvc-126`.
- Add the `namespace` set it to `moon`.
- Set the `storageClassName` to `moon-retain`.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: moon-pvc-126
  namespace: moon
spec:
  storageClassName: moon-retain
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
```

#### Create the PVC Yaml definition

```shell
vim 13-pvc.yaml
```

#### Apply the YAML definition

```shell
k apply -f 13-pvc.yaml
persistentvolumeclaim/moon-pvc-126 created
```

### Get the PVC events

```shell
k -n moon describe pvc moon-pvc-126 | grep -A10 Events:
Events:
  Type     Reason              Age                 From                         Message
  ----     ------              ----                ----                         -------
  Warning  ProvisioningFailed  12s (x8 over 116s)  persistentvolume-controller  storageclass.storage.k8s.io "moon-retain" not found
```

#### Write the event message to 13-reason.txt file

```shell
echo 'Warning  ProvisioningFailed  12s (x8 over 116s)  persistentvolume-controller  storageclass.storage.k8s.io "moon-retain" not found' > 13-reason.txt
```

## Resources

- [StorageClass Object](https://kubernetes.io/docs/concepts/storage/storage-classes/#storageclass-objects)
- [Create a PersistentVolumeClaim](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolumeclaim)

</details>
