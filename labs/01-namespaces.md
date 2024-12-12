# Question 1 - Namespaces - 1%

- Get the list of namespaces and save it to `namespaces.txt`.

## Solution

<details>
  <summary>Show the solution</summary>

### List namespaces

```shell
k get ns
NAME                 STATUS   AGE
default              Active   153m
ingress-nginx        Active   152m
kube-node-lease      Active   153m
kube-public          Active   153m
kube-system          Active   153m
local-path-storage   Active   153m
metallb-system       Active   153m
neptune              Active   6s
```

### List all the namespaces into namespaces.txt file

```shell
k get ns > namespaces.txt
```

## Resources

- [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [View and finding resources](https://kubernetes.io/docs/reference/kubectl/quick-reference/#viewing-and-finding-resources)

</details>