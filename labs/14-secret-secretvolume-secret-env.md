# Question 14 - Secret, Secret-Volume, and Secret-Env - 4%

- Make changes on an existing *Pod* in *Namespace* `moom` called `secret-handler`.
- Create a new *Secret* `secret1` which contains `user=test` and `pass=pwd`.
- The *Secret's* content should be available in *Pod* `secret-handler` as environment variables `SECRET1_USER` and `SECRET1_PASS`.
- The *YAML* for *Pod* `secret-handler` is available at `simulators/yaml-definitions/secret-handler.yaml`.
- There is an existing *YAML* for another *Secret* at `simulators/yaml-definitions/secret2.yaml`. 
- Create this *Secret* and mount it inside the same *Pod* at `/tmp/secret2`.
- Your changes should be saved under `secret-handler-new.yaml` file.
- Both *Secrets* should only be available in *Namespace* `moon`.

## Solution

<details>
  <summary>Show the solution</summary>

### Create the secret1

````shell
k -n moon create secret generic secret1 --from-literal=user=test --from-literal=pass=pwd
secret/secret1 created
````

### Create the secret2

```shell
k -n moon apply -f simulators/yaml-definitions/secret2.yaml
secret/secret2 created
```

### Copy secret-handler.yaml to secret-handler-new.yaml

```shell
cp simulators/yaml-definitions/secret-handler.yaml secret-handler-new.yaml
```

#### Modify the secret-handler-new.yaml

According to the task:

- The *Secret's* content should be available in *Pod* `secret-handler` as environment variables `SECRET1_USER` and `SECRET1_PASS`.
- Create the *Secret* `secret2` and mount it inside the same *Pod* at `/tmp/secret2`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: secret-handler
    red_ident: 9cf7a7c0-fdb2-4c35-9c13-c2a0bb52b4a9
    type: automatic
  name: secret-handler
  namespace: moon
spec:
  volumes:
    - name: cache-volume1
      emptyDir: {}
    - name: cache-volume2
      emptyDir: {}
    - name: cache-volume3
      emptyDir: {}
    - name: secret2-volume
      secret:
        secretName: secret2
  containers:
    - name: secret-handler
      image: bash:5.0.11
      args: ['bash', '-c', 'sleep 2d']
      volumeMounts:
        - mountPath: /cache1
          name: cache-volume1
        - mountPath: /cache2
          name: cache-volume2
        - mountPath: /cache3
          name: cache-volume3
        - mountPath: /tmp/secret2
          name: secret2-volume
      env:
        - name: SECRET_KEY_1
          value: ">8$kH#kj..i8}HImQd{"
        - name: SECRET_KEY_2
          value: "IO=a4L/XkRdvN8jM=Y+"
        - name: SECRET_KEY_3
          value: "-7PA0_Z]>{pwa43r)__"
        - name: SECRET1_USER
          valueFrom:
            secretKeyRef:
              name: secret1
              key: user
        - name: SECRET1_PASS
          valueFrom:
            secretKeyRef:
              name: secret1
              key: pass
```

## Delete the existing Pod

```shell
k delete -f simulators/yaml-definitions/secret-handler.yaml --force --grace-period=0
Warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "secret-handler" force deleted
```

## Create the new Pod

```shell
k apply -f secret-handler-new.yaml
pod/secret-handler created
```

## Validate the resources (Optional)

### Secrets as environment variables

```shell
k -n moon exec secret-handler -- env | grep SECRET1
SECRET1_USER=test
SECRET1_PASS=pwd
```

### Check secret2 

```shell
k -n moon exec secret-handler -- find /tmp/secret2
/tmp/secret2
/tmp/secret2/..2024_12_24_19_34_33.2255989923
/tmp/secret2/..2024_12_24_19_34_33.2255989923/halt
/tmp/secret2/..data
/tmp/secret2/halt
```

## Resources

- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Create a Pod that has access to the secret data through a Volume](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#create-a-pod-that-has-access-to-the-secret-data-through-a-volume)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="13-storage-storageclass-pvc.md" style="text-align: left;">&larr; Prev</a>
  <a href="" style="text-align: right;">Next &rarr;</a>
</div>
