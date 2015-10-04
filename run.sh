#!/bin/bash
DIR="$(git rev-parse --show-toplevel)"
source $DIR/vars.sh

docker stop "$containername" 2> /dev/null
docker rm "$containername" 2> /dev/null

docker run -P -d \
	-v $DIR/code:/var/www/public/ \
	-v $DIR/logz:/var/log/apache2/ \
	--name "$containername" \
    "$imagename"

bash $DIR/browse.sh