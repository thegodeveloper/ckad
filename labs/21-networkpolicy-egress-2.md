# Question 21 - Network Policy Egress 2 - 9%

## Task Definition

- In *Namespace* `venus` you'll find two *Pods* named `api` and `frontend`.
- Create a *NetworkPolicy* named `np1` which restricts outgoing TCP connections from *Pod* `frontend` and only allows those going to *Pod* `api`.
- Make sure the *NetworkPolicy* still allows outgoing traffic on *UDP/TCP* ports 53 for DNS resolution.
- Test using `wget www.google.com` and `wget api:2222` from a *Pod* of *Pod* `frontend`.

## Solution

<details>
  <summary>Show the solution</summary>

### Validate existing Pods and their labels

```shell
k -n venus get pod -L app
NAME       READY   STATUS    RESTARTS   AGE     APP
api        1/1     Running   0          3m28s   api
frontend   1/1     Running   0          3m28s   frontend
```

### Validate the connection

```shell
k -n venus get pod -o wide
NAME       READY   STATUS    RESTARTS   AGE   IP              NODE             NOMINATED NODE   READINESS GATES
api        1/1     Running   0          4m    10.244.88.209   k8s-c1-worker2   <none>           <none>
frontend   1/1     Running   0          4m    10.244.235.13   k8s-c1-worker    <none>           <none>
```

```shell
k -n venus exec frontend -- curl -s 10.244.88.209:2222
You are connected to API
```

### Create a NetworkPolicy by copying and changing an example from the Kubernetes docs

```shell
vim 21.yaml
```

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np1
  namespace: venus
spec:
  podSelector:
    matchLabels:
      app: frontend
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: api
    ports:
    - protocol: TCP
      port: 2222
  - ports:
    - port: 53
      protocol: UDP
    - port: 53
      protocol: TCP
```

### Apply the NetworkPolicy

```shell
k apply -f 21.yaml
networkpolicy.networking.k8s.io/np1 created
```

### Validate the NetworkPolicy

#### Validate External Connection

```shell
k -n venus exec frontend -- wget -O- www.google.de 
Connecting to www.google.de ([::ffff:142.250.78.3]:80)
^C
```

#### Validate Internal Connection

```shell
k -n venus exec frontend -- curl -s 10.244.88.209:2222
You are connected to API
```
</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="20-networkpolicy-egress-1.md" style="text-align: left;">&larr; Prev</a>
  <a href="" style="text-align: right;">Next &rarr;</a>
</div>