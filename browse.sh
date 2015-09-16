#!/bin/bash
DIR="$(git rev-parse --show-toplevel)"
. $DIR/vars.sh
ip="$(docker-machine ip dev)"
port="$(docker port $app_containername | grep -o '\d\+$')"
open http://$ip:$port
