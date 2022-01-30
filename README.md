# Sarathy
"one with a chariot"

### Usage
```bash
# Run container with 'minikube' k8s cluster
# credentials: docker / docker

docker run -it --rm --privileged \
    --hostname k8s \
    --name sarathy \
    savyasachi9/sarathy:live-amd64

# Connect to container
docker exec -it --user docker sarathy bash

```
> NOTE: use image 'savyasachi9/sarathy:minikube-amd64' for arm64 arch (apple m1, raspberry pi etc)