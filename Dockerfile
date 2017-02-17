# Dockerfile for Hyperledger fabric ca image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric-ca
# More usage infomation, please see https://github.com/hyperledger/fabric-ca.

FROM golang:1.7
MAINTAINER Baohua Yang <yangbaohua@gmail.com>

ENV FABRIC_CA_DEBUG true
ENV FABRIC_CA_PATH $GOPATH/src/github.com/hyperledger/fabric-ca

ENV CA_CFG_PATH /etc/hyperledger/fabric-ca
ENV CERT_PATH /.fabric-ca

# Then we can run `ca` cmd directly
ENV PATH=$FABRIC_CA_PATH/bin:$PATH

EXPOSE 7054

VOLUME $CA_CFG_PATH

RUN mkdir -p $GOPATH/src/github.com/hyperledger /var/hyperledger/fabric-ca $CERT_PATH

#RUN go get github.com/go-sql-driver/mysql \
#    && go get github.com/lib/pq

# clone and build ca
RUN cd $GOPATH/src/github.com/hyperledger \
    && git clone --single-branch -b master --depth 1 https://github.com/hyperledger/fabric-ca \
    && cd fabric-ca \
    && go install -ldflags " -linkmode external -extldflags '-static -lpthread'" github.com/hyperledger/fabric-ca \
#this are wrapper cmds for client/server
    && mkdir -p bin \
    && go build -ldflags " -linkmode external -extldflags '-static -lpthread'" -o bin/fabric-ca-server ./cmd/fabric-ca-server \
    && go build -ldflags " -linkmode external -extldflags '-static -lpthread'" -o bin/fabric-ca-client ./cmd/fabric-ca-client \
#copy the sample cfg files
    && cp $FABRIC_CA_PATH/images/fabric-ca/config/* $CA_CFG_PATH/ \
    && cp $FABRIC_CA_PATH/images/fabric-ca/certs/*.pem $CERT_PATH

# Disable the tls in the existing cfg file
# COPY ./testconfig.json $FABRIC_CA_PATH/testdata/

WORKDIR $FABRIC_CA_PATH

#CMD ["bash", "-c", "fabric-ca server start -ca ./testdata/ec.pem -ca-key ./testdata/ec-key.pem -config ./testdata/testconfig.json -address 0.0.0.0"]
CMD ["bash", "-c", "fabric-ca server start -config ./$CA_CFG_PATH/server-config.json -address 0.0.0.0"]
