#!/bin/bash
#@author wells
#@modify 201809051516
#first version

export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT dbg.sh----------------------"

#debug info defines
g_API_DBG_FATAL=0
g_API_DBG_ERROR=0
g_API_DBG_WARN=0
g_API_DBG_OK=0
g_API_DBG_FAIL=0
ok++() {
    g_API_DBG_OK=$(($g_API_DBG_OK + 1))
}
fail++() {
    g_API_DBG_FAIL=$(($g_API_DBG_FAIL + 1))
}
fatal++() {
    g_API_DBG_FATAL=$(($g_API_DBG_FATAL + 1))
}
error++() {
    g_API_DBG_ERROR=$(($g_API_DBG_ERROR + 1))
}
warn++() {
    g_API_DBG_WARN=$(($g_API_DBG_WARN + 1))
}
_trap_stat_() {
    log self white "-----------TRAP STAT---------------"
    if [ $g_API_DBG_FAIL -gt 0 ]; then
        log self red "global fail  number: $g_API_DBG_FAIL"
    else
        log self green "global fail  number: $g_API_DBG_FAIL"
    fi
    if [ $g_API_DBG_FATAL -gt 0 ]; then
        log self red "global fatal number: $g_API_DBG_FATAL"
    else
        log self green "global fatal number: $g_API_DBG_FATAL"
    fi
    if [ $g_API_DBG_ERROR -gt 0 ]; then
        log self red "global error number: $g_API_DBG_ERROR"
    else
        log self green "global error number: $g_API_DBG_ERROR"
    fi
    if [ $g_API_DBG_WARN -gt 0 ]; then
        log self red "global warn number: $g_API_DBG_WARN"
    else
        log self green "global warn number: $g_API_DBG_ERROR"
    fi
    log self green "global ok    number: $g_API_DBG_OK"
    log self white "---------TRAP STAT END-------------"
    local err=$(($g_API_DBG_FATAL + $g_API_DBG_ERROR + $g_API_DBG_WARN + $g_API_DBG_FAIL))
    if [ $err -gt 0 ]; then
        rm -fv $TASK_LOCK
        exit $err
    fi
}
