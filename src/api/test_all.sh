#!/bin/bash -   
#title          :test_all.sh
#description    :all test cases main
#author         :wells
#date           :20180518
#version        :1.0.0  
#usage          :./test_all.sh
#notes          :       
#bash_version   :3.00.22(2)-release
#============================================================================
source ./use.sh

main() {
    #do_or_die bash test_log.sh
    do_or_die bash test_use.sh
    _trap_stat_
}

main "$@"
