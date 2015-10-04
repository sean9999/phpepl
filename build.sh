#!/bin/bash

DIR="$(git rev-parse --show-toplevel)"
source $DIR/vars.sh

#   build image as :latest
docker build --rm=true -t "$imagebase" .
#   get php version by running :latest and asking PHP what version it is
phpversion="$(docker run $imagebase php --version | head -n 1 | grep -o 'PHP\s\S\+' | grep -o '\S\+$')"
#   tag this image (:latest) with php version
docker build --rm=true -t "$imagebase:$phpversion" .
