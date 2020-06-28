#!/bin/bash -
export DIR_API_DEFAULT=$(pwd)
source ./sys.sh

test_conf_file() {
    local _conf_file=./test_conf_file.conf
    say_is_not_exist $_conf_file
    echo "key=value" > $_conf_file
    echo "key0=value00" >> $_conf_file
    echo "key0=value10" >> $_conf_file
    echo "key1=value10" >> $_conf_file
    echo "key1=value11" >> $_conf_file
    echo "key2=value20" >> $_conf_file
    echo "key2=value21" >> $_conf_file
    echo "key3=value30" >> $_conf_file
    echo "key3=value31" >> $_conf_file

    cat $_conf_file
    echo "----------------------------------"
    del_one_line_from_file $_conf_file "key="
    cat $_conf_file
    echo "----------------------------------"
    del_lines_from_file $_conf_file "key1="
    cat $_conf_file
    echo "----------------------------------"
    add_line_from_file $_conf_file "key1=new value 1"
    cat $_conf_file
    echo "----------------------------------"

    do_or_die rm -fv $_conf_file
}

main () {
    #bns_test
    test_conf_file
}

main "$@"
