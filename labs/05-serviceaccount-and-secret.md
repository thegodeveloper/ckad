# Question 5 - ServiceAccount and Secret - 3%

- There is a `ServiceAccount` named `neptune-sa-v2` in *Namespace* `neptune`.
- Get the token from the *Secret* that belongs to that *ServiceAccount*.
- Write the *base64* decoded token to file `token.txt`.

## Solution

<details>
  <summary>Show the solution</summary>

### Describe the ServiceAccount

```shell
k -n neptune describe sa neptune-sa-v2
Name:                neptune-sa-v2
Namespace:           neptune
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   <none>
Tokens:              neptune-sa-v2-token
Events:              <none>
```

### Check if neptune-sa-v2-token is a secret

```shell
k -n neptune describe secret neptune-sa-v2-token
Name:         neptune-sa-v2-token
Namespace:    neptune
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: neptune-sa-v2
              kubernetes.io/service-account.uid: fd63dbf6-6f8d-4d9f-97c9-b69d3f972aa0

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1107 bytes
namespace:  7 bytes
token:      TOKEN_VALUE
```

### Get the token value from neptune-sa-v2-token secret

```shell
k -n neptune get secret neptune-sa-v2-token -o jsonpath='{.data.token}' && echo | base64 -d
TOKEN_VALUE
```

### Create the file token.txt

```shell
k -n neptune get secret neptune-sa-v2-token -o jsonpath='{.data.token}' | base64 -d > token.txt
```

## Resources

- [Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Managing Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="04-helm-management.md" style="text-align: left;">&larr; Prev</a>
  <a href="06-readinessprobe.md" style="text-align: right;">Next &rarr;</a>
</div>