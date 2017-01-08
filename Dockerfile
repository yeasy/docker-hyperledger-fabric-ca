# Dockerfile for Hyperledger fabric cop image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric-cop
# More usage infomation, please see https://github.com/hyperledger/fabric-cop.

FROM golang:1.7
MAINTAINER Baohua Yang <yangbaohua@gmail.com>

ENV COP_DEBUG false
ENV COP_HOME $GOPATH/src/github.com/hyperledger/fabric-cop
# Then we can run `cop` cmd directly
ENV PATH=$COP_HOME/bin:$PATH
ENV COP_CFG_HOME=/var/hyperledger/fabric/.cop
ENV CA_CERTIFICATE=$COP_CFG_HOME/ec.pem
ENV CA_KEY_CERTIFICATE=$COP_CFG_HOME/ec-key.pem
ENV COP_CONFIG=$COP_CFG_HOME/cop.json
ENV CSR_CONFIG=$COP_CFG_HOME/csr.json

EXPOSE 8888

RUN mkdir -p $GOPATH/src/github.com/hyperledger \
        && mkdir -p /var/hyperledger/fabric/.cop

RUN go get github.com/go-sql-driver/mysql \
    && go get github.com/lib/pq

# clone and build cop
RUN cd $GOPATH/src/github.com/hyperledger \
    && git clone --single-branch -b master --depth 1 https://github.com/hyperledger/fabric-cop \
    && cd fabric-cop \
    && cp docker/fabric-cop/cop.json $COP_CFG_HOME \
    && cp docker/fabric-cop/csr.json $COP_CFG_HOME \
    && cp docker/fabric-cop/ec.pem $COP_CFG_HOME \
    && cp docker/fabric-cop/ec-key.pem $COP_CFG_HOME \
    && mkdir -p bin && cd cli && go build -o ../bin/cop

WORKDIR $GOPATH/src/github.com/hyperledger/fabric-cop

# cop server start -ca $CA_CERTIFICATE -ca-key $CA_KEY_CERTIFICATE -config $COP_CONFIG -address "0.0.0.0"
# cop server start -ca ./testdata/ec.pem -ca-key ./testdata/ec-key.pem -config ./testdata/cop.json -address "0.0.0.0"
CMD ["cop", "server", "start", "-ca", "$CA_CERTIFICATE", "-ca-key", "$CA_KEY_CERTIFICATE", "-config", "$COP_CONFIG", "-address", "0.0.0.0"]
