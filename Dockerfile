# Dockerfile for Hyperledger fabric ca image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric-ca
# More usage infomation, please see https://github.com/hyperledger/fabric-ca.

FROM golang:1.8
LABEL maintainer "Baohua Yang <yeasy.github.com>"

# ca-server and ca-client will try checking the following env in order, to get the home directory
ENV FABRIC_CA_HOME /etc/hyperledger/fabric-ca-server
ENV FABRIC_CA_SERVER_HOME /etc/hyperledger/fabric-ca-server
ENV FABRIC_CA_CLIENT_HOME $HOME/.fabric-ca-client
ENV CA_CFG_PATH /etc/hyperledger/fabric-ca

# This is just for simplifying this Dockerfile
ENV FABRIC_CA_CODE $GOPATH/src/github.com/hyperledger/fabric-ca

# Usually the cmd will be installed into $GOPATH/bin, but we add local build path 
ENV PATH=$FABRIC_CA_CODE/bin:$PATH

EXPOSE 7054

#VOLUME $FABRIC_CA_CLIENT_HOME

RUN mkdir -p $GOPATH/src/github.com/hyperledger \
        $FABRIC_CA_SERVER_HOME \
        $FABRIC_CA_CLIENT_HOME \
        $CA_CFG_PATH \
        /var/hyperledger/fabric-ca-server

# The base image has libltdl-dev already, but we still need libtool to provide the header file ltdl.h
RUN apt-get update \
        && apt-get install -y libtool \
        && rm -rf /var/cache/apt

# clone and build ca
RUN cd $GOPATH/src/github.com/hyperledger \
    && git clone --single-branch -b master --depth 1 https://github.com/hyperledger/fabric-ca \
# This will install fabric-ca-server and fabric-ca-client which are under cmd into $GOPATH/bin/
    && go install -ldflags " -linkmode external -extldflags '-static -lpthread'" github.com/hyperledger/fabric-ca/cmd/... \
    && cp $FABRIC_CA_CODE/images/fabric-ca/payload/*.pem $FABRIC_CA_HOME/

# Disable the tls in the existing cfg file
# COPY ./testconfig.json $FABRIC_CA_HOME/testdata/

VOLUME $FABRIC_CA_SERVER_HOME

WORKDIR $FABRIC_CA_CODE

# if no config exists under $FABRIC_CA_HOME, will init fabric-ca-server-config.yaml and fabric-ca-server.db
# by default, the server will enable '-address 0.0.0.0'
CMD ["bash", "-c", "fabric-ca-server start -b admin:adminpw"]
#CMD ["bash", "-c", "fabric-ca-server start --ca.certfile $FABRIC_CA_HOME/ca-cert.pem --ca.keyfile $FABRIC_CA_HOME/ca-key.pem -b admin:adminpw"]
