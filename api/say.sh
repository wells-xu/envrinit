#!/bin/bash -   
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT say.sh----------------------"
source $DIR_API_DEFAULT/log.sh
source $DIR_API_DEFAULT/dbg.sh

#assertion with say
say_is_null() {
    if [ -n "$@" ]; then
        log_fatal "do not null: $@"
    fi
}
say_is_null_verbose() {
    if [ -n "$@" ]; then
        log_fatal "do not null: $@"
    else
        log ok "do realy null: $@"
    fi
}
say_is_null_silent() {
    if [ -n "$@" ]; then
        log_fatal "do not null: $@"
    fi
}
say_is_not_null() {
   text="$@"
    if [ -z "$text" ]; then
        log_fatal "do null: $@"
    fi
}
say_is_not_null_verbose() {
    if [ -z "$@" ]; then
        log_fatal "do null: $@"
    else
        log ok "do realy not null: \""$@"\""
    fi
}
say_is_not_null_silent() {
    if [ -z "$@" ]; then
        log_fatal "do null: $@"
    fi
}
say_is_equal() {
    if [ "$1" != "$2" ]; then
        log_fatal "do not equal: $1 <-> $2"
    fi
}
say_is_equal_verbose() {
    if [ "$1" = "$2" ]; then
        log ok "do equal: $1 <-> $2"
    else
        log_fatal "do not equal: $1 <-> $2"
    fi
}
say_is_not_equal() {
    if [ "$1" = "$2" ]; then
        log_fatal "do equal: $1 <-> $2"
    fi
}
say_is_not_equal_verbose() {
    if [ "$1" != "$2" ]; then
        log ok "do not equal: $1 <-> $2"
    else
        log_fatal "equal: $1 <-> $2"
    fi
}
say_is_exist() {
    say_is_not_null "$1"
    if [ ! -e "$1" ]; then
        log_fatal "file or dir not exist: $1"
    fi
}
say_is_exist_verbose() {
    say_is_not_null_verbose "$1"
    if [ ! -e "$1" ]; then
        log_fatal "file or dir not exist: $1"
    else
        log ok "file or dir exist: "$1
    fi
}
say_is_not_exist() {
    say_is_not_null "$1"
    if [ -e "$1" ]; then
        log_fatal "file or dir exist: $1"
    fi
}
say_is_not_exist_verbose() {
    say_is_not_null_verbose "$1"
    if [ -e "$1" ]; then
        log_fatal "file or dir exist: $1"
    else
        log ok "file or dir not exist: "$1
    fi
}

say_is_file_exist() {
    say_is_not_null "$1"
    if [ ! -f "$1" ]; then
        log_fatal "file not exist: $1"
    fi
}
say_is_file_exist_verbose() {
    say_is_not_null_verbose "$1"
    if [ ! -f "$1" ]; then
        log_fatal "file not exist: $1"
    else
        log ok "file exist: "$1
    fi
}

say_is_file_empty() {
    say_is_file_exist "$1"
    if is_file_empty $1; then
        log ok "file empty: "$1
    fi
}
say_is_file_empty_verbose() {
    say_is_file_exist_verbose "$1"
    if is_file_empty $1; then
        log ok "file empty: "$1
    else
        log_fatal "file not empty: $1"
    fi
}

say_is_file_not_exist() {
    say_is_not_null "$1"
    if [ -f "$1" ]; then
        log_fatal "file exist: $1"
    fi
}
say_is_file_not_exist_verbose() {
    say_is_not_null_verbose "$1"
    if [ -f "$1" ]; then
        log_fatal "file exist: $1"
    else
        log ok "file not exist: "$1
    fi
}

say_is_file_not_empty() {
    say_is_file_exist "$1"
    if is_file_empty $1; then
        log_fatal "file not empty: $1"
    fi
}
say_is_file_not_empty_verbose() {
    say_is_file_exist_verbose "$1"
    if is_file_empty $1; then
        log_fatal "file not empty: $1"
    else
        log ok "file empty: "$1
    fi
}

say_is_dir_not_exist() {
    say_is_not_null "$1"
    if [ -d "$1" ]; then
        log_fatal "dir exist: $1"
    fi
}
say_is_dir_not_exist_verbose() {
    say_is_not_null_verbose "$1"
    if [ -d "$1" ]; then
        log_fatal "dir exist: $1"
    else
        log ok "dir not exist: "$1
    fi
}

say_is_dir_exist() {
    say_is_not_null "$1"
    if [ ! -d "$1" ]; then
        log_fatal "dir not exist: $1"
    fi
}
say_is_dir_exist_verbose() {
    say_is_not_null_verbose "$1"
    if [ ! -d "$1" ]; then
        log_fatal "dir not exist: $1"
    else
        log ok "dir exist: "$1
    fi
}
say_is_dir_empty() {
    say_is_dir_exist $1
    if [ -n "$(ls -A $1)" ]; then
        log_fatal "dir not empty: $1"
    fi
}
say_is_dir_empty_verbose() {
    say_is_dir_exist_verbose $1
    if [ -n "$(ls -A $1)" ]; then
        log_fatal "dir not empty: $1"
    else
        log_ok "dir do empty: $1"
    fi
}
say_is_dir_not_empty() {
    say_is_dir_exist $1
    if [ -z "$(ls -A $1)" ]; then
        log_fatal "dir empty: $1"
    fi
}
say_is_dir_not_empty_verbose() {
    say_is_dir_exist_verbose $1
    if [ -z "$(ls -A $1)" ]; then
        log_fatal "dir empty: $1"
    else
        log_ok "dir do not empty: $1"
    fi
}

say_is_number() {
    say_is_not_null "$1"
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        log_fatal "not a number: $1"
    fi
}
say_is_number_verbose() {
    say_is_not_null_verbose "$1"
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        log_fatal "not a number: $1"
    else
        log ok "is a number: "$1
    fi
}

say_is_number_silent() {
    say_is_not_null_silent "$1"
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        log_fatal "not a number: $1"
    #else
        #log ok "is a number: "$1
    fi
}

say_is_process_exist() {
    say_is_not_null "$1"
    local pnum=$(ps -ef|awk '{print $8}' | grep "^$1:"|wc -l)
    if [ $pnum -gt 0 ]; then
        log ok "process is exist: $1"
    else
        log_fatal "process not exist: $1"
    fi
}
