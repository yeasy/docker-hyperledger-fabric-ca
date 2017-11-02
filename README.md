Hyperledger Fabric CA
===
Docker images for [Hyperledger Fabric CA](https://github.com/hyperledger/fabric-ca).

# Supported tags and respective Dockerfile links

* [`latest` (latest/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/Dockerfile): Default to enable pbft as consensus.
* [`v1.1.0-preview` (v1.1.0-preview/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/v1.1.0-preview/Dockerfile): v1.1.0-preview release.
* [`v1.0.4` (v1.0.4/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/v1.0.4/Dockerfile): v1.0.4 release.
* [`v1.0.3` (v1.0.3/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/v1.0.3/Dockerfile): v1.0.3 release.
* [`v1.0.2` (v1.0.2/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/v1.0.2/Dockerfile): v1.0.2 release.
* [`v1.0.1` (v1.0.1/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/v1.0.1/Dockerfile): v1.0.1 release.
* [`v1.0.0` (v1.0.0/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/v1.0.0/Dockerfile): v1.0.0 release.
* [`v1.0.0-rc1` (v1.0.0-rc1/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/v1.0.0-rc1/Dockerfile): v1.0.0-rc1 release.
* [`v1.0.0-beta` (v1.0.0-beta/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/v1.0.0-beta/Dockerfile): v1.0.0-beta release.

For more information about this image and its history, please see the relevant manifest file in the [`yeasy/docker-hyperledger-fabric-ca` GitHub repo](https://github.com/yeasy/docker-hyperledger-fabric-ca).

If you want to quickly deploy a local cluster without any configuration and vagrant, please refer to [Start hyperledger clsuter using compose](https://github.com/yeasy/docker-compose-files#hyperledger).

# What is docker-hyperledger-fabric-ca?
Docker image with hyperledger fabric-ca (memberservice for fabric 1.0).

# How to use this image?
The docker image is auto built at [https://registry.hub.docker.com/u/yeasy/hyperledger-fabric-ca/](https://registry.hub.docker.com/u/yeasy/hyperledger-fabric-ca/).

## In Dockerfile
```sh
FROM yeasy/hyperledger-fabric-ca:latest
```

## Usage

### As Server
By default will start the ca server with default certificates and [$COP/testdata/ca.json](https://github.com/hyperledger/fabric-ca/blob/master/testdata/ca.json) file, and map to local `8888` port.

```sh
$ docker run -it -p 8888:8888 yeasy/hyperledger-fabric-ca
```


### As Client

Note in the config file, we have the "admin" user with a password of "adminpw".

#### Enroll the admin client

```sh
$ docker run -it --rm yeasy/hyperledger-fabric-ca ca client enroll admin adminpw http://localhost:8888
```

### Reenroll the admin client

The following command renews the enrollment certificate of a client.

```sh
$ docker run -it --rm yeasy/hyperledger-fabric-ca ca client reenroll http://localhost:8888
```

Note that this updates the enrollment material in the `$COP_HOME/client.json` file.


### Register a new user
Need to config a json file first.

e.g., the $COP/testdata/registerrequest.json:

```json
{
  "id": "User1",
  "type": "client",
  "group": "bank_a",
  "attrs": [{"name":"AttributeName","value":"AttributeValue"}]
}
```

```sh
$ docker run -it --rm yeasy/hyperledger-fabric-ca ca client register ../testdata/registerrequest.json http://localhost:8888
```

### Run tests

```sh
$ docker run -it --rm yeasy/hyperledger-fabric-ca make tests
```
### Custom cmd

Login into the container and execute cmd as you like.

```sh
$ docker run -it --rm yeasy/hyperledger-fabric-ca bash
```
More usage, please refer to [https://github.com/hyperledger/fabric-ca](https://github.com/hyperledger/fabric-ca).

# Which image is based on?
The image is built based on [golang](https://hub.docker.com/_/golang/) base image.

# What has been changed?

## install fabric-ca
Install and build fabric-ca as $COP/bin/ca.

# Supported Docker versions

This image is officially supported on Docker version 1.7.0+.

Support for older versions (down to 1.0) is provided on a best-effort basis.

# Known Issues
* N/A.

# User Feedback
## Documentation
Be sure to familiarize yourself with the [repository's `README.md`](https://github.com/yeasy/docker-hyperledger-fabric-ca/blob/master/README.md) file before attempting a pull request.

## Issues
If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/yeasy/docker-hyperledger-fabric-ca/issues).

You can also reach many of the official image maintainers via the email.

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/yeasy/docker-hyperledger-fabric-ca/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
