# OwnCloud 

This creates a Docker container running [OwnCloud](https://owncloud.org) on [Alpine Linux](https://github.com/gliderlabs/docker-alpine).

### Example Usage:

    docker run --rm -it \
        -p 8888:80 \
        -v ~/docker-containers/owncloud/config:/opt/owncloud/config \
        -v ~/docker-containers/owncloud/data:/opt/owncloud/data \
        stevepacker/owncloud-alpine
