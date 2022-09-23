#!/bin/bash

export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)/api
[ ! -d $DIR_API_DEFAULT ] && DIR_API_DEFAULT=~/.local/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT rsync_daemon.sh----------------------"

source $DIR_API_DEFAULT/use.sh

#define dirs
DIR_ETC_ROOT=/etc
DIR_RSYNC_CONF=$DIR_ETC_ROOT/rsyncd
DIR_RSYNC_CONF_BACKUP=$DIR_ETC_ROOT/rsyncd.backup

write_conf_line() {
    say_is_file_exist $1
    say_is_not_null $2

    echo "$2" | sudo tee -a $1
}

rsync_start() {
    #start service
    #sudo /etc/init.d/rsync start
    sudo service rsync start
}

rsync_restart() {
    #restart service
    sudo service rsync restart
}

rsync_stop() {
    #stop service
    sudo sudo service rsync stop
}

is_proc_alive() {
    if is_null $1; then
        return 1
    fi

    [ $(ps -ef | grep rsync | grep "\-\-daemon" | wc -l) == "1" ]
}

setup() {
    #say_is_not_exist $DIR_RSYNC_CONF
    if is_dir_not_exist $DIR_RSYNC_CONF; then
        do_or_die sudo mkdir -p $DIR_RSYNC_CONF
    fi
    #say_is_not_exist $DIR_RSYNC_CONF/rsyncd.conf
    if is_file_not_exist $DIR_RSYNC_CONF/rsyncd.conf; then
        do_or_die sudo touch $DIR_RSYNC_CONF/rsyncd.conf
        do_or_die sudo touch $DIR_RSYNC_CONF/rsyncd.pass
    fi 
    if is_file_not_exist $DIR_ETC_ROOT/rsyncd.conf; then 
        do_or_die sudo ln -s $DIR_RSYNC_CONF/rsyncd.conf $DIR_ETC_ROOT/rsyncd.conf
        do_or_die sudo ln -s $DIR_RSYNC_CONF/rsyncd.pass $DIR_ETC_ROOT/rsyncd.pass
    fi

    #write conf file
    local _conf_file=$DIR_RSYNC_CONF/rsyncd.conf
    file_write_empty $_conf_file
    do_or_die write_conf_line $_conf_file "#address=192.168.122.84"
    do_or_die write_conf_line $_conf_file "log file=/var/log/rsyncd.log"
    do_or_die write_conf_line $_conf_file "max connections=1"
    do_or_die write_conf_line $_conf_file "#"
    do_or_die write_conf_line $_conf_file "[share]"
    do_or_die write_conf_line $_conf_file "path=/media/vdisk/rsyshare"
    do_or_die write_conf_line $_conf_file "comment=wolfgang's rsync service house"
    do_or_die write_conf_line $_conf_file "uid=root"
    do_or_die write_conf_line $_conf_file "gid=root"
    do_or_die write_conf_line $_conf_file "port=873"
    do_or_die write_conf_line $_conf_file "read only=no"
    do_or_die write_conf_line $_conf_file "write only=no"
    do_or_die write_conf_line $_conf_file "auth users=rsyshare_user"
    do_or_die write_conf_line $_conf_file "secrets file=/etc/rsyncd.pass"
    do_or_die write_conf_line $_conf_file "#hosts allow=10.230.1.1,10.230.1.12"
    do_or_die write_conf_line $_conf_file "#hosts deny=10.230.1.1,10.230.1.12"
    do_or_die write_conf_line $_conf_file "#显示Rsync服务端资源列表"
    do_or_die write_conf_line $_conf_file "list=yes"

    #write pass file
    _conf_file=$DIR_RSYNC_CONF/rsyncd.pass
    do_or_die echo $(cat /dev/null | sudo tee $_conf_file)
    do_or_die write_conf_line $_conf_file "rsyshare_user:crabdog123"
}

#must be first setup; not installed yet.
install() {
    #make sure  not rsync service installed yet
    if is_proc_alive rsync; then
        log_fatal "rsync is aliving, install not accepted!"
    fi

    #check if rsync daemon configuration directory exist
    say_is_not_exist $DIR_RSYNC_CONF

    #setup rsync service
    do_or_die setup

    do_or_die rsync_start
}

remove() {
    #make sure  not rsync service installed yet
    if is_proc_alive rsync; then
        do_or_die rsync_stop
    fi

    if is_dir_exist $DIR_RSYNC_CONF; then
        if is_dir_not_exist $DIR_RSYNC_CONF_BACKUP; then
            do_or_die sudo mkdir -p $DIR_RSYNC_CONF_BACKUP
        fi
        do_or_die sudo mv -v $DIR_RSYNC_CONF/* $DIR_RSYNC_CONF_BACKUP
    fi

    if is_file_exist $DIR_ETC_ROOT/rsyncd.conf; then
        do_or_die sudo rm -fv $DIR_ETC_ROOT/rsyncd.conf
        do_or_die sudo rm -fv $DIR_ETC_ROOT/rsyncd.pass
    fi
    do_or_die sudo rm -rfv $DIR_RSYNC_CONF
}

usage() {
    echo "bash rsync_daemon.sh install | remove"
    echo "bash rsync_daemon.sh start | stop | restart"
}

main () { 
    if is_command_not_valid rsync; then
        log_fatal "rsync not exist, you must install rsync first!"
    fi

    case "$1" in
        install | remove)
            do_or_die "$1"
        ;;
        start | stop | restart)
            do_or_die "rsync_$1"
        ;;
        *)
            usage
            exit 1
            #log_fatal "error with command [$1] not found"
        ;;
    esac
}

#main
main $@
