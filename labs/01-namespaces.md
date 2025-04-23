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
default              Active   2m30s
earth                Active   68s
ingress-nginx        Active   100s
jupiter              Active   68s
kube-node-lease      Active   2m30s
kube-public          Active   2m30s
kube-system          Active   2m30s
local-path-storage   Active   2m26s
mars                 Active   68s
mercury              Active   85s
metallb-system       Active   2m12s
moon                 Active   68s
neptune              Active   85s
pluto                Active   68s
project-snake        Active   67s
saturn               Active   68s
sun                  Active   67s
venus                Active   67s
```

### List all the namespaces into namespaces.txt file

```shell
k get ns -o name > namespaces.txt
```

### Verify the file

```shell
cat namespaces.txt
```

```text
namespace/default
namespace/earth
namespace/ingress-nginx
namespace/jupiter
namespace/kube-node-lease
namespace/kube-public
namespace/kube-system
namespace/local-path-storage
namespace/mars
namespace/mercury
namespace/metallb-system
namespace/moon
namespace/neptune
namespace/pluto
namespace/project-snake
namespace/saturn
namespace/sun
namespace/venus
```

## Resources

- [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [View and finding resources](https://kubernetes.io/docs/reference/kubectl/quick-reference/#viewing-and-finding-resources)

</details>

<br>
<div style="text-align: right;">
  <a href="02-pods.md">Next &rarr;</a>
</div>