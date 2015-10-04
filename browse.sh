#!/bin/bash

DIR="$(git rev-parse --show-toplevel)"
source $DIR/vars.sh
ip="$(docker-machine ip $(docker-machine active))"
port="$(docker port $containername | grep -o '\d\+$')"
open http://"$ip:$port"
