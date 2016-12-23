# Dockerfile for Hyperledger fabric cop image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric-cop
# More usage infomation, please see https://github.com/hyperledger/fabric-cop.

FROM golang:1.7
MAINTAINER Baohua Yang

ENV COP_DEBUG false
ENV COP $GOPATH/src/github.com/hyperledger/fabric-cop
# Then we can run `cop` cmd directly
ENV PATH=$COP/bin/:$PATH

EXPOSE 8888

RUN mkdir -p $GOPATH/src/github.com/hyperledger

RUN go get github.com/go-sql-driver/mysql \
    && go get github.com/lib/pq

# clone and build cop
RUN cd $GOPATH/src/github.com/hyperledger \
    && git clone --single-branch -b master --depth 1 https://github.com/hyperledger/fabric-cop \
    && cd fabric-cop \
    && make cop

WORKDIR $GOPATH/src/github.com/hyperledger/fabric-cop

CMD ["cop", "server", "start", "-ca", "../testdata/cop-cert.pem", "-ca-key", "../testdata/cop-key.pem", "-config", "../testdata/cop.json"]
