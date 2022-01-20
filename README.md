# sarathy
"one with a chariot"

### Toolchain info

### Usage
```bash
# run minikube container
# creds: docker / docker
mkdir -p $(pwd)/.sarathy/minikube

docker run -it --rm \
    --privileged -it -h minikube \
    --mount type=bind,source=$(pwd)/.sarathy/minikube,target=/var/lib/docker \
    --name sarathy-minikube \
    savyasachi9/sarathy:minikube

# connect to container
docker exec -it --user docker sarathy-minikube bash

```
> IMP: --mount is needed for /var/lib/docker else docker service fails to run in the conatiner