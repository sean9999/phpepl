#!/bin/bash

DIR="$(git rev-parse --show-toplevel)"
imagebase="sean9999/phpepl"
containerbase="phpepl"
phpversion="$(docker run $imagebase php --version | head -n 1 | grep -o 'PHP\s\S\+' | grep -o '\S\+$')"
imagename="$imagebase:$phpversion"
containername="$containerbase-$phpversion"
