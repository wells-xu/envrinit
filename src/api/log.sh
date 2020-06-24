#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT log.sh----------------------"
source $DIR_API_DEFAULT/is.sh
source $DIR_API_DEFAULT/dbg.sh
source $DIR_API_DEFAULT/def.sh
source $DIR_API_DEFAULT/fmt.sh

log() {
    local pre_=
    local col_=
    local cmd_=$1
    shift
    case "$cmd_" in
    OK|ok)
        pre_="OK    "
        col_="green null bold"
    ;;
    FAIL|fail)
        pre_="FAIL    "
        col_="red null bold"
    ;;
    FAIL|fail)
        pre_="FAIL  "
        col_="red null bold"
    ;;
    INFO|info)
        pre_="INFO  "
    ;;
    TRACE|trace)
        pre_="TRACE "
	col_="yellow"
    ;;
    DEBUG|debug)
        pre_="DEBUG "
	col_="yellow"
    ;;
    WARN|warn)
        pre_="WARN  "
	col_="magenta"
    ;;
    ERROR|error)
        pre_="ERROR "
	col_="red null bold"
    ;;
    FATAL|fatal)
        pre_="FATAL "
	col_="white red"
    ;;
    self)
        pre_="SELF  "
	col_="$1"
	shift
    ;;
    *)
        pre_="INFO  "
    ;;
    esac
	echo "---$@---"
    col_fmt "$pre_ $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" $col_
}

log_trace() {
    log trace "$@" >&2
}
log_debug() {
    log debug "$@" >&2
}
log_info() {
    log info "$@" >&2
}
log_msg() {
    log info "$@" >&2
}
log_warn() {
    warn++
    log warn "$@" >&2
}
log_error() {
    error++
    log error "$@" >&2
}
log_fatal_msg() {
    fatal++
    log fatal "$@" >&2
}
log_fatal() {
    fatal++
    log fatal "$@"
    if [ ${G_LOCK_TYPE:-0} -eq 1 ]; then
        if is_file_exist $TASK_LOCK; then
            rm -v $TASK_LOCK || log_error "rming $TASK_LOCK failed"
        fi
    elif [ ${G_LOCK_TYPE:-0} -eq 2 ]; then
        if is_file_exist $DIR_BIN/$TASK_LOCK_V2; then
            rm -v $DIR_BIN/$TASK_LOCK_V2 || log_error "[lock] rming $DIR_BIN/$TASK_LOCK_V2 failed"
        fi
    fi
    _trap_stat_
    exit $?
}

log_ok() {
    ok++
    log ok "$@" >&2
}
log_fail() {
    fail++
    log fail "$@" >&2
}
