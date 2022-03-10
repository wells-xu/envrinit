#!/bin/bash -   
#title          :use.sh 
#description    :some useful bash function connection
#author         :wells
#date           :20180518
#version        :1.0.0  
#usage          :./use.sh
#notes          :       
#bash_version   :3.00.22(2)-release
#============================================================================
echo "$0"
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)/api
[ ! -d $DIR_API_DEFAULT ] && DIR_API_DEFAULT=~/.local/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT use.sh----------------------"

source $DIR_API_DEFAULT/cus.sh
source $DIR_API_DEFAULT/log.sh
source $DIR_API_DEFAULT/say.sh

G_LOCK_TYPE=0

#locking && unlocking
lock() {
    G_LOCK_TYPE=1
    if is_file_exist $TASK_LOCK; then
        log_fatal_msg "[lock] $TASK_LOCK is locking now"
        exit 1
    fi
    touch $TASK_LOCK || log_fatal "[lock] touching $TASK_LOCK failed"
    log_info "[lock] creating lock success: $TASK_LOCK"
}
unlock() {
    if is_file_not_exist $TASK_LOCK; then
        log_fatal "[lock] lock file not found: $TASK_LOCK"
    fi
    rm -v $TASK_LOCK || log_fatal "[lock] rming $TASK_LOCK failed"
    log_info "[lock] rming lock success: $TASK_LOCK"
} 
lock_ex() {
    G_LOCK_TYPE=2
    if is_file_exist $DIR_BIN/$TASK_LOCK_V2; then
        if [ $(($(date +%s) - $(cat $DIR_BIN/$TASK_LOCK_V2))) -lt 1800 ]; then
            log_fatal_msg "[lock] $DIR_BIN/$TASK_LOCK_V2 is locking now: $(($(date +%s) - $(cat $DIR_BIN/$TASK_LOCK_V2)))"
            exit 1
        else
            log_warn_msg "lock occupated time: $(($(date +%s) - $(cat $DIR_BIN/$TASK_LOCK_V2)))"
            echo $(date +%s) > $DIR_BIN/$TASK_LOCK_V2 || log_fatal "[lock] dating $DIR_BIN/$TASK_LOCK_V2 failed"
        fi
    fi
    touch $DIR_BIN/$TASK_LOCK_V2 || log_fatal "[lock] touching $DIR_BIN/$TASK_LOCK_V2 failed"
    echo $(date +%s) > $DIR_BIN/$TASK_LOCK_V2 || log_fatal "[lock] dating $DIR_BIN/$TASK_LOCK_V2 failed"
    log_info "[lock] creating lock success: $DIR_BIN/$TASK_LOCK_V2"
}
unlock_ex() {
    if is_file_not_exist $DIR_BIN/$TASK_LOCK_V2; then
        log_fatal "[lock] lock file not found: $DIR_BIN/$TASK_LOCK_V2"
    fi
    rm -v $DIR_BIN/$TASK_LOCK_V2 || log_fatal "[lock] rming $DIR_BIN/$TASK_LOCK_V2 failed"
    log_info "[lock] rming lock success: $DIR_BIN/$TASK_LOCK_V2"
}

#time functions
lastday() {
    if is_not_null $1; then
        echo $(date -d "1 day ago" +"%Y$1%m$1%d")
    else
        echo $(date -d "1 day ago" +"%Y/%m/%d")
    fi
}
today() {
    if is_not_null $1; then
        echo $(date +"%Y$1%m$1%d")
    else
        echo $(date +"%Y/%m/%d")
    fi
}
show_date() {
    if is_null $1; then
        echo -e `date +"%Y-%m-%d %H:%M:%S"`"\t"
    else
        echo -e `date +"%Y-%m-%d %H:%M:%S"`"\t""$@"
    fi
}
#---------------
pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    echo
}

shasumed() {
    say_is_not_null $1
    echo $(echo -n "$1" | shasum | awk '{print $1}')
}
#file info
get_file_size() {
    if [ -f $1 ]; then
        echo -n `stat -c %s $1`
    else
        echo -n "-1"
    fi
}

#retry funcs
do_repeat() {
    local max_limit=$1
    say_is_number $max_limit
    local cur_=0
    shift 
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    while true; do
        if [ $cur_ -ge $max_limit ]; then
            log "max try time overflowing"
            break
        fi
        #doing sth
        eval "${args[@]}"
        if [ $? -eq 0 ]; then
            log_ok "[do_repeat] done: $@"
        else
            log_fail "[do_repeat] failed: $@"
        fi
        cur_=$(($cur_ + 1))
        log "being repeat within 5 seconds..."
        sleep 5
    done
    return 0
}
do_or_retry() {
    #echo ---"$@"---
    local max_limit=$1
    say_is_number $max_limit
    local cur_=0
    shift 
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    while true; do
        if [ $cur_ -ge $max_limit ]; then
            log "max try time overflowing"
            break
        fi
        #doing sth
        eval "${args[@]}"
        if [ $? -eq 0 ]; then
            log_ok "[do_or_retry] done: $@"
            return 0
        fi
        cur_=$(($cur_ + 1))
        log "being retry within 5 seconds..."
        sleep 5
    done
    return 1
}

#checking funcs
do_or_die() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    #echo "[do_or_die]n ---$@---"
    #echo "[do_or_die]0---$0---"
    #[ $# != 0 ] && printf "[do_or_die]---%s---\n" "$@"
    echo "[do_or_die] args---${args[@]}---"
    #local cmd=$1
    #shift
    #$cmd "$@" || log_fatal "[do_or_die] executing failed: [$cmd $@]"
    eval "${args[@]}" || log_fatal "[do_or_die] executing failed: ["${args[@]}"]"
    log_ok "[do_or_die] success done: $@"
}
dont_or_die() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    #echo "[do_or_die]n ---$@---"
    #echo "[do_or_die]0---$0---"
    #[ $# != 0 ] && printf "[do_or_die]---%s---\n" "$@"
    echo "[dont_or_die] args---${args[@]}---"
    #local cmd=$1
    #shift
    #$cmd "$@" || log_fatal "[do_or_die] executing failed: [$cmd $@]"
    eval "${args[@]}" && log_fatal "[dont_or_die] executing failed: ["${args[@]}"]"
    log_ok "[dont_or_die] failed done: [$@]"
}
do_or_die_silent() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    #echo "[do_or_die]n ---$@---"
    #echo "[do_or_die]0---$0---"
    #[ $# != 0 ] && printf "[do_or_die]---%s---\n" "$@"
    #echo "[do_or_die] args---${args[@]}---"
    #local cmd=$1
    #shift
    #$cmd "$@" || log_fatal "[do_or_die] executing failed: [$cmd $@]"
    eval "${args[@]}" || log_fatal "[do_or_die_silent] executing failed: ["${args[@]}"]"
    #log_ok "[do_or_die] success done: [$@]"
}
do_or_error() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    eval "${args[@]}" || log_error "[do_or_error] executing failed: ["${args[@]}"]"
    log_ok "[do_or_error] success executed: ["${args[@]}"]"
}
do_or_warn() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    eval "${args[@]}" || log_warn "[do_or_warn] executing failed: ["${args[@]}"]"
    log_ok "[do_or_warn] success executed: ["${args[@]}"]"
}
do_or_log() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    eval "${args[@]}" || log_info "[do_or_log] executing failed: ["${args[@]}"]"
    log_ok "[do_or_log] success executed: ["${args[@]}"]"
}
do_or_fail() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    eval "${args[@]}" || log_fail "[do_or_fail] executing failed: ["${args[@]}"]"
    log_ok "[do_or_fail] success executed: ["${args[@]}"]"
}
do_is() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
        #echo "[do_or_die]$i ---${!i}---"
    done
    eval "${args[@]}"
    local ret=$?
    if [ $ret -eq 0 ]; then
        log_ok "[do_is] success executed: ["${args[@]}"]"
    else
        log "[do_is] executing failed: ["${args[@]}"]"
    fi
    return $ret
}
do_is_silent() {
    say_is_not_null "$@"
    local args=
    for ((i=1; i <= $#; ++i))
    do
        if [ $i -eq 1 ]; then
            args=("${args[@]}" "${!i}")
        else
            args=("${args[@]}" "\"${!i}\"")
        fi
    done
    eval "${args[@]}"
}
check_result_is() {
    return $?
}
check_result_not() {
    [[ $? -ne 0 ]]
}

