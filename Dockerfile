FROM golang:1.10-stretch
RUN dpkg --add-architecture armhf && \
    dpkg --add-architecture arm64 && \
    apt-get -y update && \
    apt-get -y install \
        curl git tar zip xz-utils \
        yasm nasm \
        gcc g++ gfortran \
        automake \
        autogen \
        cmake \
        bzip2 \
        bsdtar \
        libtool \
        bison \
        flex \
        libx11-dev \
        libgtk-3-dev \
        libasound2-dev:amd64 libasound2-dev:armhf libasound2-dev:arm64 \
        crossbuild-essential-armhf \
        crossbuild-essential-arm64 \
        gfortran-arm-linux-gnueabihf \
        gfortran-aarch64-linux-gnu && \
    apt-get -y clean
RUN curl -sSL https://get.docker.com/builds/Linux/x86_64/docker-1.12.3.tgz | tar -C /usr/local/bin --strip-components=1 -zx
RUN curl -sSL https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz | tar -C /usr/local -Jx --strip-components=1
RUN go get -v github.com/alecthomas/gometalinter && \
    go get -v golang.org/x/tools/cmd/... && \
    go get -v github.com/golang/dep/cmd/dep && \
    go get -v github.com/FiloSottile/gvt && \
    go get -v github.com/smartystreets/goconvey && \
    go get -v github.com/GeertJohan/go.rice/rice && \
    gometalinter --install
RUN curl -sSL https://github.com/google/protobuf/releases/download/v3.5.1/protoc-3.5.1-linux-x86_64.zip >/tmp/protoc.zip && \
    cd /usr/local && unzip /tmp/protoc.zip && rm /tmp/protoc.zip && \
    chmod a+rx /usr/local/bin/protoc && \
    go get -v github.com/golang/protobuf/protoc-gen-go && \
    go get -v github.com/robotalks/tbus/codegen/cmd/... && \
    cp -rf /go/src/github.com/robotalks/tbus/proto/tbus /usr/local/include/ && \
    chmod -R a+rx /usr/local/include && \
    chmod -R a+rw /go
ADD kit /opt/kit
RUN for k in $(find /opt/kit -name '*.sh' -executable) ; do ln -s $k /usr/local/bin/$(basename $k) ; done
