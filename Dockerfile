# Dockerfile for Hyperledger fabric ca image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric-ca
# More usage infomation, please see https://github.com/hyperledger/fabric-ca.

FROM golang:1.7
MAINTAINER Baohua Yang <yangbaohua@gmail.com>

ENV COP_DEBUG false
ENV COP_HOME $GOPATH/src/github.com/hyperledger/fabric-ca
# Then we can run `ca` cmd directly
ENV PATH=$COP_HOME/bin:$PATH
#ENV COP_CFG_HOME=/etc/hyperledger/fabric/.ca
#ENV CA_CERTIFICATE=$COP_CFG_HOME/ec.pem
#ENV CA_KEY_CERTIFICATE=$COP_CFG_HOME/ec-key.pem
#ENV COP_CONFIG=$COP_CFG_HOME/ca.json
#ENV CSR_CONFIG=$COP_CFG_HOME/csr.json

EXPOSE 8888

RUN mkdir -p $GOPATH/src/github.com/hyperledger \
        && mkdir -p /etc/hyperledger/fabric-ca \
        && mkdir -p ~/.fabric-ca

RUN go get github.com/go-sql-driver/mysql \
    && go get github.com/lib/pq

# clone and build ca
RUN cd $GOPATH/src/github.com/hyperledger \
    && git clone --single-branch -b master --depth 1 https://github.com/hyperledger/fabric-ca \
    && cd fabric-ca \
#   && cp docker/fabric-ca/ca.json $COP_CFG_HOME \
#   && cp docker/fabric-ca/csr.json $COP_CFG_HOME \
#   && cp docker/fabric-ca/ec.pem $COP_CFG_HOME \
#   && cp docker/fabric-ca/ec-key.pem $COP_CFG_HOME \
#   && cp docker/fabric-ca/ec.pem ~/.ca \
#   && cp docker/fabric-ca/ec-key.pem ~/.ca \
    && mkdir -p bin &&  go build -o bin/fabric-ca

# Disable the tls in the existing cfg file
COPY ./testconfig.json $GOPATH/src/github.com/hyperledger/fabric-ca/testdata/

WORKDIR $GOPATH/src/github.com/hyperledger/fabric-ca

# ca server start -ca $CA_CERTIFICATE -ca-key $CA_KEY_CERTIFICATE -config $COP_CONFIG -address "0.0.0.0"
#CMD ["ca", "server", "start", "-ca", "$CA_CERTIFICATE", "-ca-key", "$CA_KEY_CERTIFICATE", "-config", "$COP_CONFIG", "-address", "0.0.0.0"]
#CMD ["bash", "-c", "ca server start -ca $CA_CERTIFICATE -ca-key $CA_KEY_CERTIFICATE -config $COP_CONFIG -address 0.0.0.0"]
#CMD ["bash", "-c", "ca server start -ca ./testdata/ec.pem -ca-key ./testdata/ec-key.pem -config ./testdata/ca.json -address 0.0.0.0"]
CMD ["bash", "-c", "fabric-ca server start -ca ./testdata/ec.pem -ca-key ./testdata/ec-key.pem -config ./testdata/testconfig.json -address 0.0.0.0"]
