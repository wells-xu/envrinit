#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)/api
[ ! -d $DIR_API_DEFAULT ] && DIR_API_DEFAULT=~/.local/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT dbg.sh----------------------"

source $DIR_API_DEFAULT/say.sh

file_write_empty() {
    say_is_file_exist $1
    do_or_die echo $(cat /dev/null | sudo tee $1)
}

