# Question 4 - Helm Management - 5%

## Task Definition

- Perform all the operations in the `mercury` *Namespace*.
- Delete release `internal-issue-report-apiv1`.
- Upgrade release `internal-issue-report-apiv2` to any newer version available of chart bitnami/nginx.
- Install a new release `internal-issue-report-apache` of chart `bitnami/apache`. The Deployment should have `2` replicas, set these via Helm-values during install.
- There seems to be a broken release, it is on `failed` state. Find it and delete it.

## Solution

<details>
  <summary>Show the solution</summary>

### List Helm releases on mercury namespace

```shell
helm -n mercury ls
NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
internal-issue-report-apiv1     mercury         1               2024-12-13 10:00:40.120005001 -0500 -05 deployed        nginx-18.2.4    1.27.2     
internal-issue-report-apiv2     mercury         1               2024-12-13 10:00:42.038539298 -0500 -05 deployed        nginx-18.2.5    1.27.2     
internal-issue-report-apiv3     mercury         1               2024-12-13 10:13:15.645517385 -0500 -05 failed          nginx-18.2.5    1.27.2
```

## Delete release internal-issue-report-apiv1

```shell
helm -n mercury delete internal-issue-report-apiv1
release "internal-issue-report-apiv1" uninstalled
```

## Upgrade the release internal-issue-report-apiv2

### List the repositories

```shell
helm repo list
NAME            URL                                              
metrics-server  https://kubernetes-sigs.github.io/metrics-server/
nginx-chart     https://thegodeveloper.github.io/gd-charts/      
ingress-nginx   https://kubernetes.github.io/ingress-nginx       
metallb         https://metallb.github.io/metallb                
bitnami         https://charts.bitnami.com/bitnami
```

### Search Nginx in the repos

The release `internal-issue-report-apiv2` is on version `18.2.5` and the latest release in the repo is `18.3.1`.

```shell
helm search repo bitnami/nginx
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/nginx                           19.1.1          1.27.5          NGINX Open Source is a web server that can be a...
bitnami/nginx-ingress-controller        11.6.14         1.12.1          NGINX Ingress Controller is an Ingress controll...
bitnami/nginx-intel                     2.1.15          0.4.9           DEPRECATED NGINX Open Source for Intel is a lig...
```

### Upgrade the release internal-issue-report-apiv2 to the latest version

```shell
helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx
Release "internal-issue-report-apiv2" has been upgraded. Happy Helming!
NAME: internal-issue-report-apiv2
LAST DEPLOYED: Wed Apr 23 17:55:38 2025
NAMESPACE: mercury
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
CHART NAME: nginx
CHART VERSION: 19.1.1
APP VERSION: 1.27.5
...
```
### Check release

Check that release `internal-issue-report-apiv2` change from version `18.2.5` to `19.1.1`.

```shell
helm -n mercury ls
NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
internal-issue-report-apiv2     mercury         2               2025-04-23 17:55:38.166311 -0500 -05    deployed        nginx-19.1.1    1.27.5     
internal-issue-report-apiv3     mercury         1               2025-04-23 17:19:34.363498 -0500 -05    failed          nginx-18.2.5    1.27.2
```

## Install the release internal-issue-report-apache

### Get the Helm chart values

I am using `replica` in the search because I don't know the exact name of the value.

```shell
helm show values bitnami/apache | grep replica
## @param replicaCount Number of replicas of the Apache deployment
replicaCount: 1
## @param autoscaling.minReplicas Minimum number of Apache replicas
## @param autoscaling.maxReplicas Maximum number of Apache replicas
```

The example shows that the default value for `replicaCount` is `1`.

```shell
helm -n mercury install internal-issue-report-apache bitnami/apache --set replicaCount=2
NAME: internal-issue-report-apache
LAST DEPLOYED: Wed Apr 23 18:04:40 2025
NAMESPACE: mercury
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: apache
CHART VERSION: 11.3.5
APP VERSION: 2.4.63
...
```

If you get the following error:

```text
Error: INSTALLATION FAILED: failed to authorize: failed to fetch oauth token: Post "https://auth.docker.io/token": dial tcp: lookup auth.docker.io: i/o timeout
```

Execute the following command:

```shell
docker login -u hachikoapp

Info → A Personal Access Token (PAT) can be used instead.
         To create a PAT, visit https://app.docker.com/settings


Password: [INTRODUCE YOUR TOKEN]
Login Succeeded
```

### Check the release

Validate if release `internal-issue-report-apache` is on `deployed` state.

```shell
helm -n mercury ls
NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
internal-issue-report-apache    mercury         1               2025-04-23 18:04:40.594345 -0500 -05    deployed        apache-11.3.5   2.4.63     
internal-issue-report-apiv2     mercury         2               2025-04-23 17:55:38.166311 -0500 -05    deployed        nginx-19.1.1    1.27.5     
internal-issue-report-apiv3     mercury         1               2025-04-23 17:19:34.363498 -0500 -05    failed          nginx-18.2.5    1.27.2
```

## Find a release on failed state and delete it

### List the releases

The release `internal-issue-report-apiv3` is on `failed` state.

```shell
helm -n mercury ls
NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
internal-issue-report-apache    mercury         1               2024-12-13 10:35:41.416842758 -0500 -05 deployed        apache-11.3.0   2.4.62     
internal-issue-report-apiv2     mercury         2               2024-12-13 10:26:26.022928089 -0500 -05 deployed        nginx-18.3.1    1.27.3     
internal-issue-report-apiv3     mercury         1               2024-12-13 10:13:15.645517385 -0500 -05 failed          nginx-18.2.5    1.27.2
```

### Delete the release internal-issue-report-apiv3

```shell
helm -n mercury delete internal-issue-report-apiv3
release "internal-issue-report-apiv3" uninstalled
```

### Check the releases again

```shell
helm -n mercury ls
NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
internal-issue-report-apache    mercury         1               2025-04-23 18:04:40.594345 -0500 -05    deployed        apache-11.3.5   2.4.63     
internal-issue-report-apiv2     mercury         2               2025-04-23 17:55:38.166311 -0500 -05    deployed        nginx-19.1.1    1.27.5
```

## Resources

- [Helm Cheat Sheet](https://helm.sh/docs/intro/cheatsheet/)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="03-jobs.md" style="text-align: left;">&larr; Prev</a>
  <a href="05-serviceaccount-and-secret.md" style="text-align: right;">Next &rarr;</a>
</div>