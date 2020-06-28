#!/bin/bash -
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT sys.sh----------------------"
source $DIR_API_DEFAULT/use.sh

del_lines_from_file() {
    say_is_file_exist $1
    say_is_not_null $2

    do_or_die sed -i "/$2/d" $1
}
del_one_line_from_file() {
    say_is_file_exist $1
    say_is_not_null $2

    do_or_die sed -i "0,/$2/{/$2/d;}" $1
}
add_line_from_file() {
    #for ((i=0; i <= $#; ++i))
    #do
        #echo "[add_line_from_file]$i ---${!i}---"
    #done
    #echo "[add_line_from_file]n ---$@---"
    #echo "[add_line_from_file]0---$0---"
    #[ $# != 0 ] && printf "[add_line_from_file]---%s---\n" "$@"
    say_is_file_exist $1
    say_is_not_null $2

    do_or_die sed -i -e '$a' $1
    do_or_die "echo \"$2\" >> $1"
}
set_lines_from_file() {
    say_is_file_exist $1
    say_is_not_null $2
    say_is_not_null $3

    do_or_die sed -i "/$2/c $3" $1
}
set_one_line_from_file() {
    log_fatal "not implemented yet"
    say_is_file_exist $1
    say_is_not_null $2
    say_is_not_null $3
}

#PROCESS STUFF
#count process number with ps aux
#0 means process not exist
process_count() {
    #local cmd_param="ps aux"
    local cmd_param="ps -A"
    for i in $@; do
        local _first=${i:0:1}
        local _other=${i:1}
        local _cmd="[$_first]$_other"
        cmd_param=$cmd_param" | grep $_cmd"
    done
    cmd_param=$cmd_param" | wc -l"
    echo $(eval $cmd_param)
}

wait_until_exit() {
    local timeout_cur=0
    local timeout=60
    if is_number $1; then
        timeout=$1
        shift
    fi
    echo "timeout=$timeout"

    while true; do
        local count=$(process_count "$@")
        if [ $count -eq 0 ]; then
            log_msg "[wait_until_exit] process check clear now :$count"
            break
        elif [ $timeout_cur -ge $timeout ]; then
            log_error_msg "[wait_until_exit] process waiting timeout :$count"
            return 1
        else
            log_msg "[wait_until_exit] process is waiting :$count"
            timeout_cur=$(($timeout_cur + 5))
            sleep 5
        fi
    done
}

#@exe 240 /home/work/olime/pblog/rac.log*
clear_files_with_amount() {
    say_is_number $1
    say_is_not_null $2
    say_is_dir_exist $(dirname "$2")

	local _lines=$(ls -tr $2)
    if check_result_is; then
        local _now=$(echo "$_lines" | wc -l)
        local _abs=$(($_now - $1))
        if [ $_abs -gt 0 ]; then
            ls -tr $2 | head -n $_abs | xargs rm -v
        else
            log_msg "[clear_files_with_amount] Not necessarily to remove: [$_abs]/[$1]"
        fi
    else
        log_msg "[clear_files_with_amount] not found: [$2]"
    fi
}

