# Deployment Container
This repository uses ```docker.io/library/node:22``` as its base image.  
Its main purpose is to serve as a template / Proof of Concept (PoC) / quick development environment.  
- Secrets can be set in ```./config/secrets.env```.  
- Configuration (e.g., Git URL and branch) can be set in ```./config/settings.json```.  
- The main setup logic is handled by ```entrypoint.sh```, which runs before you enter the container.
  
After the entrypoint script has executed, you’ll land in an interactive shell, ready for development.  
  
## Configuration
For configuration there are  
```configuration/secrets.env```  
for passing secrets as environment variables,  
and  
```configuration/settings.json```  
for general configuration.  
```entrypoint.sh``` provides a simple node function to read ```/configuration/settings.json``` and make them into environment variables as well.  
  
## Initializing VM  
On macOS, Podman runs inside a Linux virtual machine.  
To initialize and start it:  
```podman machine init```  
```podman machine start```  
  
## Creating an Image
The helper script ```./build``` runs:  
```podman build -t deployment:arm64 .```

You can verify the image with:  
```podman image list```  
Example output:  
<code>REPOSITORY              TAG         IMAGE ID      CREATED         SIZE
localhost/deployment    arm64       0d4488102fde  39 seconds ago  1.16 GB
docker.io/library/node  22          1139ddf15c23  10 days ago     1.16 GB</code>

This builds an image from the repos ```Containerfile``` names it ```deployment``` and tags it ```arm64```.  
(Node:22 is currently used as this repos base image, see ```Containerfile```)  



## Running a Container
The helper script ```./run``` executes:  
<code>podman run --rm -it \
    --env-file ./config/secrets.env \
    -v ./config:/config:ro \
    -v ./destination:/destination:rw \
    deployment:arm64 bash</code>  
#### Flags explained
- ```--rm``` → deletes the container after it stops  
- ```--it``` → provides an interactive TTY session  
- ```--env-file``` → each line in the file becomes an environment variable inside the container  
- ```-v``` → creates bind mounts:  
    - ```./config``` → mounted read-only as ```/config```  
    - ```./destination``` → mounted read-write as ```/destination```  
  
After startup, you’ll drop into an interactive shell inside the container.  
  
## Cleaning up  
The helper script ```./clean``` runs:  
```podman system prune -a -f```  
This removes all unused containers, images, networks, and volumes.  
- ```-a``` → also removes unused images (not just dangling ones)  
- ```-f``` → skips the confirmation prompt  
