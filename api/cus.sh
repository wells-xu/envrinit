#!/bin/bash
#@author wells
#@modify 201809051513

export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)/api
[ ! -d $DIR_API_DEFAULT ] && DIR_API_DEFAULT=~/.local/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT cus.sh----------------------"

#usual directory defines
DIR_ROOT="~/.local"
DIR_BIN=$DIR_ROOT/bin
DIR_ETC=$DIR_ROOT/etc
DIR_API=$DIR_ROOT/api

alias pop='set -- $(eval printf '\''%s\\n'\'' $(seq $(expr $# - 1) | sed '\''s/^/\$/;H;$!d;x;s/\n/ /g'\'') )'
shopt -s expand_aliases

rshift() {
    pop
    echo "$@"
}

lshift() {
    shift
    echo "$@"
}

#test cases:
#lshift $(seq 1 10)
#rshift $(seq 1 10)
