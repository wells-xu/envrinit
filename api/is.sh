#!/bin/bash -   
#title          :is.sh  
#description    :some functios that is condition if true
#author         :wells
#date           :20180518
#version        :1.0.0  
#usage          :./is.sh
#notes          :       
#bash_version   :3.00.22(2)-release
#============================================================================

#if condition
is_null() {
    if [ ! -n "$1" ]; then
        return 0
    fi
    return 1
}

is_not_null() {
    if [ ! -n "$1" ]; then
        return 1
    fi
    return 0
}

is_file_empty() {
    if [ -s "$1" ]; then
        return 1
    fi
    return 0
}

is_file_not_empty() {
    if [ ! -s "$1" ]; then
        return 1
    fi
    return 0
}

is_file() {
    if [ -f "$1" ]; then
        return 0
    fi
    return 1
}

is_dir() {
    if [ -d "$1" ]; then
        return 0
    fi
    return 1
}
#usage: if is_file_exist $2; then
is_file_exist() {
    if [ -f "$1" ]; then 
        return 0
    fi
    return 1
}

#usage: if is_file_not_exist $2; then
is_file_not_exist() {
    if [ ! -f "$1" ]; then 
        return 0
    fi
    return 1
}

#usage: if is_dir $2; then
is_dir_exist() {
    if [ -d "$1" ]; then 
        return 0
    fi
    return 1
}
is_dir_not_exist() {
    if [ ! -d "$1" ]; then 
        return 0
    fi
    return 1
}
is_dir_empty() {
    say_is_dir_exist $1
    [[ -n "$(find $1 -type d -empty)" ]]
}
is_dir_not_empty() {
    say_is_dir_exist $1
    [[ -z "$(find $1 -type d -empty)" ]]
}

#usage: if is_exist $2; then
is_exist() {
    if [ -e "$1" ]; then 
        return 0
    fi
    return 1
}
#usage: if is_exist $2; then
is_not_exist() {
    if [ ! -e "$1" ]; then 
        return 0
    fi
    return 1
}

is_equal() {
    if [ "$1" == "$2" ]; then
	return 0
    fi
    return 1
}
is_not_equal() {
    if [ "$1" == "$2" ]; then
	return 1
    fi
    return 0
}

is_number() {
    local re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        return 1
    else
        return 0
    fi
}
is_not_number() {
    local re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        return 0
    else
        return 1
    fi
}

is_command_valid() {
    if is_null $1; then
        return 1
    fi
    #command -v $1
    eval "command -v $1"
} 
is_command_not_valid() {
    if is_command_valid $1; then
        return 1
    fi
    return 0
} 

