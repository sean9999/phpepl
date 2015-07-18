#!/bin/bash
DIR="$(git rev-parse --show-toplevel)"
. $DIR/vars.sh
ip="$(boot2docker ip)"
port="$(docker port $app_containername | grep -o '\d\+$')"
open http://$ip:$port
