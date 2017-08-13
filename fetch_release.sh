#!/usr/bin/env bash
set -eux -o pipefail

. VERSION

url_get() {
    if command -v fetch 2>&1; then
        fetch -m "$1"
    elif command -v wget 2>&1; then
        wget --mirror "$1"
    else
        curl -O "$1"
    fi
}

#DISTS="base base-dbg doc kernel-dbg kernel lib32-dbg lib32 ports src tests"
DISTS="base lib32"

WORKDIR=$(dirname "$(pwd)/$0")
pushd "$WORKDIR"
  for dist in $DISTS; do
    SHA256SUM_WANTS=$(awk "/^${dist}.txz/ {print \$2}" MANIFEST)
    url_get "https://download.freebsd.org/ftp/releases/amd64/${RELVER}/${dist}.txz"
    SHA256SUM_HAS=$(openssl dgst -sha256 "${dist}.txz" | awk '{print $2}')
    [ "$SHA256SUM_WANTS" = "$SHA256SUM_HAS" ]
  done
popd