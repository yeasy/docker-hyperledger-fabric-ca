# Dockerfile for Hyperledger fabric ca image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric-ca
# More usage infomation, please see https://github.com/hyperledger/fabric-ca.

FROM golang:1.7
MAINTAINER Baohua Yang <yangbaohua@gmail.com>

ENV FABRIC_CA_DEBUG true
ENV FABRIC_CA_PATH $GOPATH/src/github.com/hyperledger/fabric-ca

ENV CA_CFG_PATH /etc/hyperledger/fabric-ca
ENV FABRIC_CA_HOME /etc/hyperledger/fabric-ca-server
ENV CERT_PATH /.fabric-ca

# Then we can run `ca` cmd directly
ENV PATH=$FABRIC_CA_PATH/bin:$PATH

EXPOSE 7054

VOLUME $CA_CFG_PATH

RUN mkdir -p $GOPATH/src/github.com/hyperledger $CA_CFG_PATH $FABRIC_CA_HOME $CERT_PATH /var/hyperledger/fabric-ca-server

# The base image has libltdl-dev already, but we still need libtool to provide the header file ltdl.h
RUN apt-get update \
        && apt-get install -y libtool \
        && rm -rf /var/cache/apt

# clone and build ca
RUN cd $GOPATH/src/github.com/hyperledger \
    && git clone --single-branch -b master --depth 1 https://github.com/hyperledger/fabric-ca \
# This will install fabric-ca-server and fabric-ca-client which are under cmd into $GOPATH/bin/
    && go install github.com/hyperledger/fabric-ca/cmd/... \
    && cp $FABRIC_CA_PATH/images/fabric-ca/payload/*.pem $FABRIC_CA_HOME/

# Disable the tls in the existing cfg file
# COPY ./testconfig.json $FABRIC_CA_PATH/testdata/

WORKDIR $FABRIC_CA_PATH

#CMD ["bash", "-c", "fabric-ca server start -ca ./testdata/ec.pem -ca-key ./testdata/ec-key.pem -config ./testdata/testconfig.json -address 0.0.0.0"]
#CMD ["bash", "-c", "fabric-ca server start -config ./$CA_CFG_PATH/server-config.json -address 0.0.0.0"]
CMD ["bash", "-c", "fabric-ca-server start -b admin:adminpw -address 0.0.0.0"]
