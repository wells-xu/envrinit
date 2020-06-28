#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
if [ ! -d $DIR_API_DEFAULT ]; then
    DIR_API_DEFAULT=/home/work/api
fi
#[ -z $DIR_API_DEFAULT ] && DIR_API_DEFAULT=/home/work/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT test_str.sh----------------------"
source $DIR_API_DEFAULT/str.sh

main() {
    local _list=$(ls .)
    echo "$(str_pure_mutiple_line_to_one_line "$_list")"
    echo "--------------"
    echo "$(str_pure_one_line_to_mutiple_line "a b c")"
    echo "--------------"
    echo "$(str_pure_one_line_to_mutiple_line "/home/work/1.bin /home/work/olime/2.bin")"
}

main "$@"
