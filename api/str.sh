#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT str.sh----------------------"
source $DIR_API_DEFAULT/is.sh

#             a
# "a b c" ->  b
#             c
str_pure_one_line_to_mutiple_line() {
    local _list=
    if is_not_null "$1"; then
        for i in $1; do
            if is_null "$_list"; then
                _list="${i}"
            else
                _list="${_list}\n${i}"
            fi
        done
    fi
    echo -e "$_list"
}

# "a         
# b  ->  a b c
# c"        
str_pure_mutiple_line_to_one_line() {
    local _list=
    if is_not_null "$1"; then
        IFS=$'\n'$'\r'
        for i in $1; do
            if is_null "$_list"; then
                _list="${i}"
            else
                _list="${_list} ${i}"
            fi
        done
        IFS=' '
    fi
    echo "$_list"
}
