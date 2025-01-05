# Question 11 - Working with Containers - 7%

## Task Definition

- There are files to build a container image located at `labs/11/image`.
- The container will run a Golang application which outputs information stdout.
- Change the *Dockerfile* to set an environment variable `SUN_CIPHER_ID` with the value `7d6e2993-p86p-7b78-b17b-cE6decb8c18p`.
- Build an image using *Docker*, named `localhost:5000/sun-cipher` and tagged as `latest` and `v1-docker`.
- Build an image using *Podman*, named `localhost:5000/sun-cipher`, tagged as `v1-podman` and push it to the registry.
- Run a container using *Podman*, which keeps running in the background, named `sun-cipher` using image `localhost:5000/sun-cipher:v1-podman`.
- Write the logs of the container `sun-cipher` into `11-logs.txt` file.
- Then write a list of all running *Podman* containers into `11-containers.txt`

**Notes:**

- Use `localhost:5000` to push images locally.

## Solution

<details>
  <summary>Show the solution</summary>

### Update the Dockerfile

```dockerfile
# build container stage 1
FROM docker.io/library/golang:1.15.15-alpine3.14
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bin/app .

# app container stage 2
FROM docker.io/library/alpine:3.12.4
COPY --from=0 /src/bin/app app
# Add next line
ENV SUN_CIPHER_ID=7d6e2993-p86p-7b78-b17b-cE6decb8c18p
CMD ["./app"]
```

### Build the Image using Docker

```shell
cd labs/11/image
docker build -t localhost:5000/sun-cipher:latest -t localhost:5000/sun-cipher:v1-docker .
...
 => => naming to localhost:5000/sun-cipher:latest                                                                                                                                                                                              0.0s
 => => unpacking to localhost:5000/sun-cipher:latest                                                                                                                                                                                           0.0s
 => => naming to localhost:5000/sun-cipher:v1-docker                                                                                                                                                                                           0.0s
 => => unpacking to localhost:5000/sun-cipher:v1-docker 
```

### List the docker image

```shell
docker image ls | grep sun-cipher
localhost:5000/sun-cipher   latest      9c299608aca1   About a minute ago   12.2MB
localhost:5000/sun-cipher   v1-docker   9c299608aca1   About a minute ago   12.2MB
```

### Build the Image using Podman to create a tag

```shell
podman build -t localhost:5000/sun-cipher:v1-podman .
...
Successfully tagged localhost:5000/sun-cipher:v1-podman
1112002a882e775779406bd55c788af240f45c9281f4566c46ac69f0959ffc3d
```

### List the image in Podman

```shell
podman image ls | grep sun-cipher
localhost:5000/sun-cipher   v1-podman           1112002a882e  2 minutes ago  7.91 MB
```

### Push the image to registry

```shell
podman push localhost:5000/sun-cipher:v1-podman 
Getting image source signatures
Copying blob d3bec89f4ed7 done   | 
Copying blob 33e8713114f8 done   | 
Copying config 1112002a88 done   | 
Writing manifest to image destination
```

### Run a container using Podman

```shell
podman run -d --name sun-cipher localhost:5000/sun-cipher:v1-podman
822f3ffe7e34c5bfab01b66545f1c8457c2c496083a7bfc33cd30091c0d39087
```

### Check the container

```shell
podman ps -a
CONTAINER ID  IMAGE                                COMMAND               CREATED            STATUS            PORTS                   NAMES
add5f77c3b8a  docker.io/library/registry:2         /etc/docker/regis...  About an hour ago  Up About an hour  0.0.0.0:5000->5000/tcp  podman-registry
91139877e881  localhost:5000/sun-cipher:v1-podman  ./app                 10 seconds ago     Up 10 seconds                             sun-cipher
```

### List running containers

````shell
podman ps -a > 11-containers.txt
````

### Get container logs

```shell
podman logs 91139877e881
Environment variable SUN_CIPHER_ID: 7d6e2993-p86p-7b78-b17b-cE6decb8c18p
Container is now running. Press Ctrl+C to stop.
```

## Resources

- [Basic Setup and Use of Podman](https://github.com/containers/podman/blob/main/docs/tutorials/podman_tutorial.md)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="10-services-and-logs.md" style="text-align: left;">&larr; Prev</a>
  <a href="12-storage-pv-pvc-pod-volume.md" style="text-align: right;">Next &rarr;</a>
</div>