#!/bin/bash

export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)/api
[ ! -d $DIR_API_DEFAULT ] && DIR_API_DEFAULT=~/.local/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT dbg.sh----------------------"

source $DIR_API_DEFAULT/is.sh
source $DIR_API_DEFAULT/log.sh

if is_command_valid rsync; then
    log ok "[valid] rsync is valid"
else
    log_error "[valid] rsync is not valid"
fi

if is_command_not_valid rsync; then
    log ok "[not valid] rsync is valid"
else
    log_error "[not valid] rsync is not valid"
fi
