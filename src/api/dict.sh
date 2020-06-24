#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT dict.sh----------------------"
source $DIR_API_DEFAULT/sys.sh

check_md5() {
    say_is_file_exist $1
    say_is_not_null $2

    log_msg "starting processing md5 ...: $1"
    local cur_summ=$(md5sum $1 | awk '{print $1}')
    if [ "$cur_summ" = "$2" ]; then
        log_msg "check md5 result is same: $2"
        return 0
    else
        log_msg "check md5 result is different: cur=$cur_summ <-> $2"
        return 1
    fi
}

check_file() {
    say_is_file_exist $1
    local dict_path_name=$(basename $1)
    local dict_summ=$(echo $dict_path_name | awk -F. '{print $4}')
    say_is_not_null $dict_summ

    check_md5 $1 $dict_summ
}

is_dict_name_valid() {
    #checking dict name format
    if is_null $1; then
        return 1
    fi

    local dict_type=$(echo $1 | awk -F. '{print $1}')
    local dict_name=$(echo $1 | awk -F. '{print $2}')
    local dict_date=$(echo $1 | awk -F. '{print $3}')
    local dict_summ=$(echo $1 | awk -F. '{print $4}')
    local dict_tail=$(echo $1 | awk -F. '{print $5}')
    if is_null $dict_type; then
        return 1
    fi
    if is_null $dict_name; then
        return 1
    fi
    if is_not_number $dict_date; then
        return 1
    fi
    if is_null $dict_summ; then
        return 1
    fi
    if is_null $dict_tail; then
        return 1
    fi
    return 0
}

get_dict_key() {
    do_or_die_silent is_dict_name_valid $1
    echo $1 | awk -F. '{printf "%s %s %s", $2, $1, $5}'
}
get_dict_name() {
    do_or_die_silent is_dict_name_valid $1
    echo $1 | awk -F. '{printf "%s", $2}'
}
get_dict_type() {
    do_or_die_silent is_dict_name_valid $1
    echo $1 | awk -F. '{printf "%s", $1}'
}
get_dict_date() {
    do_or_die_silent is_dict_name_valid $1
    echo $1 | awk -F. '{printf "%s", $3}'
}
get_dict_summary() {
    do_or_die_silent is_dict_name_valid $1
    echo $1 | awk -F. '{printf "%s", $4}'
}
get_dict_tail() {
    do_or_die_silent is_dict_name_valid $1
    echo $1 | awk -F. '{printf "%s", $5}'
}

generate_dict_name() {
    if is_file_exist $1; then
        #/home/work/olime/data/hotup/egg.dat hotup
        local _dir=$(dirname $1)
        local _basename=$(basename $1)
        local _type=$2
        local _name=$(echo $_basename | awk -F. '{print $1}')
        local _tail=$(echo $_basename | awk -F. '{print $2}')
        local _date=$(date +"%Y%m%d%H%M%S")
        local _summ=$(md5sum $1 | awk '{print $1}')
        [[ -n $_dir ]] && [[ -n $_basename ]] && [[ -n $_type ]] && [[ -n $_name ]] && [[ -n $_tail ]] && [[ -n $_date ]] && [[ -n $_summ ]] && echo "$_dir/$_type.$_name.$_date.$_summ.$_tail"
    fi
}

generate_dict_name_only() {
    #/home/work/olime/data/hotup/egg.dat hotup [/tmp/egg.dat.downloading]
    local _dir=$(dirname $1)
    local _basename=$(basename $1)
    local _type=$2
    local _name=$(echo $_basename | awk -F. '{print $1}')
    local _tail=$(echo $_basename | awk -F. '{print $2}')
    local _date=$(date +"%Y%m%d%H%M%S")
    local _summ=
    if is_null $3; then
        if is_file_exist $1; then
            _summ=$(md5sum $1 | awk '{print $1}')
        fi
    else
        if is_file_exist $3; then
            _summ=$(md5sum $3 | awk '{print $1}')
        fi
    fi
    [[ -n $_dir ]] && [[ -n $_basename ]] && [[ -n $_type ]] && [[ -n $_name ]] && [[ -n $_tail ]] && [[ -n $_date ]] && [[ -n $_summ ]] && echo "$_type.$_name.$_date.$_summ.$_tail"
}

dict_ls_from_parameter() {
    say_is_not_null "$1"

    local _list="$1"
    local _dict_list=
    IFS=$'\n'$'\r' read -rd '' -a _args <<< "$_list"
    for _line in "${_args[@]}"
    do
        if is_dict_name_valid $(basename $_line); then
            if is_null "$_dict_list"; then
                _dict_list="${_line}"
            else
                _dict_list="${_dict_list}\n${_line}"
            fi
        fi
    done
    echo -e "$_dict_list"
}
dict_ls_complete_from_directory() {
    say_is_dir_exist $1
    local _dir=${1%/}

    local _list=$(find $_dir -maxdepth 1 -type f | awk -F"/" '{print $NF}' | awk -F. -v dir=$_dir '{if(NF == 5){print dir"/"$0}}')
    if is_not_null "$_list"; then
        dict_ls_from_parameter "$_list"
    fi
}
dict_ls_from_directory() {
    say_is_dir_exist $1

    local _list=$(dict_ls_complete_from_directory $1)
    if is_not_null "$_list"; then
        echo "$_list" | awk '{print system("basename "$1)}' | grep -v "^0$"
    fi
}
dict_unique_keys_from_parameter() {
    local _list="$1"
    say_is_not_null "$_list"

    echo "$_list" | sort | awk -F. '{print $2" "$1" "$5}' | uniq
}

dict_sort_from_parameter() {
    local _list="$1"
    [[ -n "$_list" ]] && echo "$_list" | sort -t"." -k3
}
dict_filter_byname() {
    if is_not_null "$1"; then
        local _name=$2
        local _type=$3
        local _tail=$4
        say_is_not_null $_name
        say_is_not_null $_type
        say_is_not_null $_tail

        echo "$1" | grep "^$_type\.$_name\." | grep "\.$_tail$"
    fi
}
dict_get_oldest_from_parameter() {
    say_is_number $2
    echo "$(dict_sort_from_parameter "$(dict_filter_byname "$1" $3 $4 $5)")" | head -n $2
}
dict_get_latest_from_parameter() {
    say_is_number $2
    echo "$(dict_sort_from_parameter "$(dict_filter_byname "$1" $3 $4 $5)")" | tail -n $2
}

dict_count_from_parameter() {
    local _list="$1"
    say_is_not_null "$_list"
    local _name=$2
    local _type=$3
    local _tail=$4
    say_is_not_null $_name
    say_is_not_null $_type
    say_is_not_null $_tail

    local found_num=$(echo "$(dict_filter_byname "$_list" $_name $_type $_tail)" | wc -l)
    say_is_number $found_num
    echo $found_num
}

# vim:set ft=sh ts=4 sw=4 et:
