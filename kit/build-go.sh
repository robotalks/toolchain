#!/bin/bash

set -ex

. $(dirname $(readlink $BASH_SOURCE))/functions.sh

ARCH=$1
OUT_FN=$2
test -n "$ARCH"
test -n "$OUT_FN"
OUT_DIR=$OUT_BASE/$ARCH
OUT_BIN=$OUT_DIR/$OUT_FN

shift; shift

LDFLAGS=
if [ -n "$RELEASE" ]; then
    case "$RELEASE" in
        y|yes|final) LDFLAGS="$LDFLAGS -X main.VersionSuffix=" ;;
        *) LDFLAGS="$LDFLAGS -X main.VersionSuffix=-$RELEASE" ;;
    esac
else
    suffix=$(git log -1 --format=%h || true)
    if [ -n "$suffix" ]; then
        test -z "$(git status --porcelain || true)" || suffix="${suffix}+"
        LDFLAGS="$LDFLAGS -X main.VersionSuffix=-g${suffix}"
    fi
fi

if [ -z "$CGO_ENABLED" -o "$CGO_ENABLED" == "0" ]; then
    LDFLAGS="$LDFLAGS -extldflags -static"
fi

case "$ARCH" in
    amd64)
        export GOARCH=$ARCH
        export CC=x86_64-linux-gnu-gcc
        export CXX=x86_64-linux-gnu-g++
    ;;
    armhf)
        export GOARCH=arm
        export GOARM=7
        export CC=arm-linux-gnueabihf-gcc
        export CXX=arm-linux-gnueabihf-g++
    ;;
    arm64)
        export GOARCH=arm64
        export CC=aarch64-linux-gnu-gcc
        export CXX=aarch64-linux-gnu-g++
    ;;
    *)
        echo Unknown ARCH=$ARCH >&2
        exit 1
    ;;
esac

mkdir -p $(dirname $OUT_BIN)
CGO_ENABLED=${CGO_ENABLED:-0} go build -o $OUT_BIN \
    -ldflags "$LDFLAGS $GO_LDFLAGS" \
    $@
