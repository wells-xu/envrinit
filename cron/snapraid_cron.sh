#!/bin/bash

export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)/api
[ ! -d $DIR_API_DEFAULT ] && DIR_API_DEFAULT=~/.local/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT rsync_daemon.sh----------------------"

source $DIR_API_DEFAULT/use.sh

export PATH=$PATH:/bin/sbin:/usr/bin:/usr/sbin:/usr/local/bin

#define dirs
DIR_ETC_ROOT=/etc


usage() {
    echo "usage: "
    echo "bash snapraid.sh [scrub | sync]"
}

main () {
    lock_ex

    if is_command_not_valid snapraid; then
        log_fatal "snapraid not exist"
    fi

    do_or_die snapraid --version
    log_ok  "snapraid exist ..."

    case "$1" in
        scrub)
            #Every run of the command checks about the 8% of the array, but not data already scrubbed
            # in the previous 10 days. You can use the -p, --plan option to specify a different amount,
            # and the -o, --older-than option to specify a different age in days. For example,
            # to check 5% of the array older than 20 days use: 
            #snapraid -p 5 -o 20 scrub
            log_msg "snapraid scrub starting..."
            if do_is snapraid -p 6 -o 30 scrub &> $DIR_BIN/log/main_log_scrub; then
                log_ok "scrub done"
                #Only report sucess message on Saturday avoid any valueness messages.
                #But can't be removed because we would known if reproting system worked as expected.
                if is_equal $(date +"%w") 6; then
                    do_or_die snapraid status >> $DIR_BIN/log/main_log_scrub
                    if do_or_retry 3 mailx -s "[$(time_string)] snapraid scrub done" xugang_2001@163.com < $DIR_BIN/log/main_log_scrub; then
                        log_ok "mail done"
                    fi
                fi
            else
                log_error "scrub failed"
                if do_or_retry 3 mailx -s "[$(time_string)] snapraid scrub error" xugang_2001@163.com < $DIR_BIN/log/main_log_scrub; then
                    log_ok "mail done"
                fi
            fi
            do_or_die cat $DIR_BIN/log/main_log_scrub
        ;;
        sync)
            log_msg "snapraid sync starting..."
            if do_is snapraid sync &> $DIR_BIN/log/main_log_sync; then
                log_ok "sync done"
                if do_or_retry 3 mailx -s "[$(time_string)] snapraid sync done" xugang_2001@163.com < $DIR_BIN/log/main_log_sync; then
                    log_ok "mail done"
                fi
            else
                log_error "sync failed"
                if do_or_retry 3 mailx -s "[$(time_string)] snapraid sync error" xugang_2001@163.com < $DIR_BIN/log/main_log_sync; then
                    log_ok "mail done"
                fi
            fi
            do_or_die cat $DIR_BIN/log/main_log_sync
        ;;
        *)
            usage
            log_fatal "error with command [$1] not found"
        ;;
    esac

    log_msg "snapraid process done"
    unlock_ex
}

#main loop
main $@
