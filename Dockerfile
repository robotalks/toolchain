FROM golang:1.7
RUN echo 'deb http://emdebian.org/tools/debian/ jessie main' >/etc/apt/sources.list.d/crosstools.list && \
    curl -sSL http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add - && \
    dpkg --add-architecture armhf && \
    dpkg --add-architecture armel && \
    dpkg --add-architecture arm64 && \
    apt-get -y update && \
    apt-get -y install \
        curl git tar zip xz-utils \
        yasm nasm \
        gcc g++ gfortran \
        ninja \
        automake \
        autogen \
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
    apt-get -y clean && \
    curl -sSL https://cmake.org/files/v3.6/cmake-3.6.1-Linux-x86_64.tar.gz | tar -C /usr/local --strip-components=1 -zx && \
    curl -sSL https://get.docker.com/builds/Linux/x86_64/docker-1.12.3.tgz | tar -C /usr/local/bin --strip-components=1 -zx && \
    curl -sSL https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip >/tmp/protoc.zip && \
    cd /usr/local && unzip /tmp/protoc.zip && rm /tmp/protoc.zip && \
    chmod a+rx /usr/local/bin/protoc && \
    curl -sSL https://nodejs.org/dist/v4.5.0/node-v4.5.0-linux-x64.tar.xz | tar -C /usr/local -Jx --strip-components=1 && \
    go get -v github.com/golang/protobuf/protoc-gen-go && \
    go get -v github.com/alecthomas/gometalinter && \
    go get -v golang.org/x/tools/cmd/... && \
    go get -v github.com/FiloSottile/gvt && \
    go get -v github.com/smartystreets/goconvey && \
    go get -v github.com/GeertJohan/go.rice/rice && \
    go get -v github.com/robotalks/tbus/codegen/cmd/... && \
    cp -rf /go/src/github.com/robotalks/tbus/proto/tbus /usr/local/include/ && \
    gometalinter --install && \
    chmod -R a+rx /usr/local/include && \
    chmod -R a+rw /go
ADD kit /opt/kit
RUN for k in $(find /opt/kit -name '*.sh' -executable) ; do ln -s $k /usr/local/bin/$(basename $k) ; done
