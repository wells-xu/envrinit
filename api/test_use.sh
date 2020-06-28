#!/bin/bash -   
#title          :test_use.sh
#description    :use.sh test cases
#author         :wells
#date           :20180518
#version        :1.0.0  
#usage          :./test_use.sh
#notes          :       
#bash_version   :3.00.22(2)-release
#============================================================================
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
source $DIR_API_DEFAULT/use.sh

test_check() {
   do_or_die ls
   do_or_die "ls -l" 
   touch alsdfjlsadjflasjdkf.alsafjdklaksdjlfjkla
   do_or_die "rm -v alsdfjlsadjflasjdkf.alsafjdklaksdjlfjkla"
   do_or_error "rm -v alsdfjlsadjflasjdkf.alsafjdklaksdjlfjkla"
   do_or_warn "rm -v alsdfjlsadjflasjdkf.alsafjdklaksdjlfjkla"
   do_or_die "rm -v alsdfjlsadjflasjdkf.alsafjdklaksdjlfjkla"
}

test_lock() {
    do_or_die "lock"
    do_or_die "unlock"
    do_or_die "lock_ex"
    do_or_die "unlock_ex"
}

test01() {
    echo "$@"
    $@
}

main() {
    test_lock
    test_check
}

main "$@"
