#!/bin/bash

DIR="$(git rev-parse --show-toplevel)"
source $DIR/vars.sh

#   build image as :latest
docker push "$imagebase"
#   tag this image (:latest) with php version
docker push "$imagebase:$phpversion"
