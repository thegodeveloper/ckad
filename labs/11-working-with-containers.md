# Question 11 - Working with Containers - 7%

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

### Update the Dockerfile

```dockerfile

```

### Build the Image using Docker

```shell

```

### Build the Image using Podman

```shell

```

### Build the Image using Podman to create a tag

```shell

```

## Resources


</details>
