# Question 1 - Namespaces - 1%

- Get the list of namespaces and save it to `namespaces.txt`.

## Solution

<details>
  <summary>Show the solution</summary>

### List namespaces

```shell
k get ns
NAME                 STATUS   AGE
default              Active   4m39s
ingress-nginx        Active   3m40s
kube-node-lease      Active   4m39s
kube-public          Active   4m39s
kube-system          Active   4m39s
local-path-storage   Active   4m36s
metallb-system       Active   4m20s
```

### List all the namespaces into namespaces.txt file

```shell
k get ns > namespaces.txt
```

## Resources

- [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [View and finding resources](https://kubernetes.io/docs/reference/kubectl/quick-reference/#viewing-and-finding-resources)

</details>