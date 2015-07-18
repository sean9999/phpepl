#!/bin/bash
DIR="$(git rev-parse --show-toplevel)"
. $DIR/vars.sh

#	dev
htdocs=src
#	pod
#htdocs=dist

docker stop $app_containername 2> /dev/null
docker rm $app_containername  2> /dev/null

docker run -P -v $DIR/code/$htdocs:/var/www/public/ -v $DIR/logz:/var/log/apache2/ -d --name $app_containername sean9999/phprepl:7.0
