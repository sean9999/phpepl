#!/bin/bash

docker build --rm=true -t sean9999/phpepl .

phpversion="$(docker run sean9999/phpepl php --version | head -n 1 | grep -o 'PHP\s\S\+' | grep -o '\S\+$')"

docker build --rm=true -t sean9999/phpepl:"$phpversion" .
