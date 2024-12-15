# Question 8 - Deployment and Rollouts - 4%

- There is an existing *Deployment* named `api-new-c32` in `neptune` *Namespace*.
- An upgrade was made to the Deployment but the updated version never came online.
- Check the *Deployment* history and find a revision that works, then rollback to it.

## Solution

<details>
  <summary>Show the solution</summary>

### List the Deployment

```shell
k -n neptune get deploy api-new-c32
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
api-new-c32   0/3     1            0           71s
```

### List the Pods

```shell
NAME                           READY   STATUS             RESTARTS   AGE
api-new-c32-5957d59bcb-s4w72   0/1     ImagePullBackOff   0          2m14s
api-new-c32-6675746675-gs7p9   0/1     ImagePullBackOff   0          2m14s
api-new-c32-6dcc55d47d-bk2tq   0/1     ImagePullBackOff   0          2m14s
api-new-c32-c9cdb5f85-mgn2b    0/1     ImagePullBackOff   0          2m14s
```

### Check Deployment History

```shell
k -n neptune rollout history deployment/api-new-c32
deployment.apps/api-new-c32 
REVISION  CHANGE-CAUSE
1         <none>
2         kubectl set image deployment/api-new-c32 nginx=ngnix:1.26.2 --namespace=neptune --record=true
3         kubectl set image deployment/api-new-c32 nginx=ngnix:1.26.3 --namespace=neptune --record=true
4         kubectl set image deployment/api-new-c32 nginx=ngnix:1.26.4 --namespace=neptune --record=true
5         kubectl set image deployment/api-new-c32 nginx=ngnix:1.26.5 --namespace=neptune --record=true
```

### Rollback to Working Revision

```shell
k -n neptune rollout undo deployment/api-new-c32 --to-revision=1
deployment.apps/api-new-c32 rolled back
```

### Validate the Deployment

```shell
k -n neptune get deploy api-new-c32
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
api-new-c32   3/3     3            3           8m46s
```

### Validate Pods in the Deployment

```shell
k -n neptune get pods
NAME                           READY   STATUS    RESTARTS   AGE
api-new-c32-79b499db9f-drjff   1/1     Running   0          103s
api-new-c32-79b499db9f-g9hgz   1/1     Running   0          105s
api-new-c32-79b499db9f-w4ml7   1/1     Running   0          97s
```

### Validate Deployment History (not necessary)

````shell
k -n neptune rollout history deployment/api-new-c32
deployment.apps/api-new-c32 
REVISION  CHANGE-CAUSE
2         kubectl set image deployment/api-new-c32 nginx=ngnix:1.26.2 --namespace=neptune --record=true
3         kubectl set image deployment/api-new-c32 nginx=ngnix:1.26.3 --namespace=neptune --record=true
4         kubectl set image deployment/api-new-c32 nginx=ngnix:1.26.4 --namespace=neptune --record=true
5         kubectl set image deployment/api-new-c32 nginx=ngnix:1.26.5 --namespace=neptune --record=true
6         <none>
````

## Resources

- [Update resources](https://kubernetes.io/docs/reference/kubectl/quick-reference/#updating-resources)

</details>
