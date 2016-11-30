Hyperledger-Fabric-Cop
===
Docker images for [Hyperledger Fabric Cop](https://github.com/hyperledger/fabric-cop).

# Supported tags and respective Dockerfile links

* [`latest` (latest/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-cop/blob/master/Dockerfile): Default to enable pbft as consensus.

For more information about this image and its history, please see the relevant manifest file in the [`yeasy/docker-hyperledger-fabric-cop` GitHub repo](https://github.com/yeasy/docker-hyperledger-fabric-cop).

If you want to quickly deploy a local cluster without any configuration and vagrant, please refer to [Start hyperledger clsuter using compose](https://github.com/yeasy/docker-compose-files#hyperledger).

# What is docker-hyperledger-fabric-cop?
Docker image with hyperledger fabric-cop (memberservice for fabric 1.0).

# How to use this image?
The docker image is auto built at [https://registry.hub.docker.com/u/yeasy/hyperledger-fabric-cop/](https://registry.hub.docker.com/u/yeasy/hyperledger-fabric-cop/).

## In Dockerfile
```sh
FROM yeasy/hyperledger-fabric-cop:latest
```

## Usage

Login into the container and execute cmd as you like.

```sh
$ docker run -it --rm yeasy/hyperledger-fabric-cop bash
```
More usage, please refer to [https://github.com/hyperledger/fabric-cop](https://github.com/hyperledger/fabric-cop).

# Which image is based on?
The image is built based on [golang](https://hub.docker.com/_/golang/) base image.

# What has been changed?
## install dependencies
Install required  libsnappy-dev, zlib1g-dev, libbz2-dev.

## install rocksdb
Install required  rocksdb 4.1.

## install hyperledger
Install hyperledger and build the peer 

# Supported Docker versions

This image is officially supported on Docker version 1.7.0.

Support for older versions (down to 1.0) is provided on a best-effort basis.

# Known Issues
* N/A.

# User Feedback
## Documentation
Be sure to familiarize yourself with the [repository's `README.md`](https://github.com/yeasy/docker-hyperledger-fabric-cop/blob/master/README.md) file before attempting a pull request.

## Issues
If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/yeasy/docker-hyperledger-fabric-cop/issues).

You can also reach many of the official image maintainers via the email.

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/yeasy/docker-hyperledger-fabric-cop/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
