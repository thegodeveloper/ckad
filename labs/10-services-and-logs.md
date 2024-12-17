# Question 10 - Services and Logs - 4%

- Create a *Pod* named `project-plt-6cc-api` of image `nginx:1.17.3-alpine`.
- The *Pod* should be identified by label `project: plt-6cc-api`.
- Create a `ClusterIP` *Service* named `project-plt-6cc-svc` in *Namespace* `pluto` to expose the *Pod*.
- The *Service* should use the TCP Port redirection of `3333:80`.
- Use a `curl` form a temporary `nginx:alpine` *Pod* to get the response from the *Service*.
- Write the response into `service_test.html` file.
- Check the logs of *Pod* `project-plt-6cc-api` to show the request and write it into `service_test.log`.

## Solution

<details>
  <summary>Show the solution</summary>

### Create a Pod

```shell
k -n pluto run project-plt-6cc-api --image=nginx:1.17.3-alpine --labels project=plt-6cc-api
pod/project-plt-6cc-api created
```

### Expose the Pod

```shell
k -n pluto expose pod project-plt-6cc-api --name=project-plt-6cc-svc --port=3333 --target-port=80
service/project-plt-6cc-svc exposed
```

### Get response from service

```shell
k run test --image=nginx:alpine --restart=Never --rm -i -- curl -s http://project-plt-6cc-svc.pluto:3333
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
pod "test" deleted
```

### Get response from service and save to file

```shell
k run test --image=nginx:alpine --restart=Never --rm -i -- curl -s http://project-plt-6cc-svc.pluto:3333 > service_test.html
```

### Get the Pod Logs

```shell
k -n pluto logs project-plt-6cc-api
10.244.88.204 - - [16/Dec/2024:23:52:41 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/8.11.0" "-"
10.244.235.7 - - [16/Dec/2024:23:53:12 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/8.11.0" "-"
10.244.88.205 - - [16/Dec/2024:23:53:33 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/8.11.0" "-"
10.244.88.206 - - [16/Dec/2024:23:56:10 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/8.11.0" "-"
```

### Save the Pod Logs

```shell
k -n pluto logs project-plt-6cc-api > service_test.log
```

## Resources

- [Exposing Pods to the cluster](https://kubernetes.io/docs/tutorials/services/connect-applications-service/#exposing-pods-to-the-cluster)
- [Service](https://kubernetes.io/docs/concepts/services-networking/service/)

</details>
