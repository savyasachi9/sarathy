# Sarathy
"one with a chariot"

### Usage
```bash
# Run container with 'minikube' k8s cluster
# credentials: docker / docker
docker run -it --rm --privileged \
    -p 9090:9090 -p 9091:9091 \
    -h k8s --name sarathy \
    savyasachi9/sarathy:live-amd64

# Connect to container
docker exec -it --user docker sarathy bash

# Visit webtty/gotty in browser (not available for arm64 yet)
http://localhost:9091

# Visit code-server/vscode in browser
http://localhost:9091

```
> use image 'savyasachi9/sarathy:live-arm64' for arm64 arch (apple m1, raspberry pi etc)

> *live* in the tag *live-amd64 / live-arm64* means container image has docker, k8s etc already up & running aka live !!!

### Programming Languages
- c/c++, gcc 9, gdb
- golang1.17
- PHP8.1, xdebug
- Python3.8, pip3
> above languages have code-server debug extensions pre-installed ( 'Ctrl + F5' )
