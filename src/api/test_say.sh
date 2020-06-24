#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT test_say.sh----------------------"
source $DIR_API_DEFAULT/use.sh

test() {
    do_or_die echo xxx 
    say_is_null "xxx"
}

main() {
    lock_ex
    test
    unlock_ex
}

main "$@"
