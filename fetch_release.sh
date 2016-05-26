#!/usr/bin/env bash
set -eux -o pipefail

. VERSION

WORKDIR="$(dirname "$(pwd)/$0")"
pushd "$WORKDIR"
  curl -O https://download.freebsd.org/ftp/releases/amd64/${RELVER}/base.txz
  BASE_SHA256SUM=$(awk '/^base.txz/ {print $2}' MANIFEST)
  [ $BASE_SHA256SUM = $(openssl dgst -sha256 base.txz | awk '{print $2}') ]
  LIB32_SHA256SUM=$(awk '/^lib32.txz/ {print $2}' MANIFEST)
  curl -O https://download.freebsd.org/ftp/releases/amd64/${RELVER}/lib32.txz
  [ $LIB32_SHA256SUM = $(openssl dgst -sha256 lib32.txz | awk '{print $2}') ]
popd
