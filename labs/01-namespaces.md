# Question 1 - Namespaces - 1%

## Task Definition

- Get the list of namespaces and save it to `namespaces.txt`.

## Solution

<details>
  <summary>Show the solution</summary>

### List namespaces

```shell
k get ns
NAME                 STATUS   AGE
default              Active   43m
ingress-nginx        Active   42m
kube-node-lease      Active   43m
kube-public          Active   43m
kube-system          Active   43m
local-path-storage   Active   43m
mercury              Active   41m
metallb-system       Active   42m
neptune              Active   41m
```

### List all the namespaces into namespaces.txt file

```shell
k get ns > namespaces.txt
```

## Resources

- [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [View and finding resources](https://kubernetes.io/docs/reference/kubectl/quick-reference/#viewing-and-finding-resources)

</details>

<br>
<div style="text-align: right;">
  <a href="02-pods.md">Next &rarr;</a>
</div>