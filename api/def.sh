#!/bin/bash
#@author wells
#@modify 201805171620
#first version
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)/api
[ ! -d $DIR_API_DEFAULT ] && DIR_API_DEFAULT=~/.local/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT def.sh----------------------"

#usual directory defines
DIR_PWD=$(pwd)
DIR_BIN=$(cd $(dirname $0); pwd)
PATH_BIN=$DIR_BIN/$(basename $0)

#platform check
GLOBAL_PLATFORM_CUSTOM_DEFINE_LINUX=
GLOBAL_PLATFORM_CUSTOM_DEFINE_MACOS=
GLOBAL_PLATFORM_CUSTOM_DEFINE_CYGWIN=
GLOBAL_PLATFORM_CUSTOM_DEFINE_MINGW=
GLOBAL_PLATFORM_CUSTOM_DEFINE_UNKOWN=
case "$(uname -s)" in
    Linux*)     GLOBAL_PLATFORM_CUSTOM_DEFINE_LINUX=1;;
    Darwin*)    GLOBAL_PLATFORM_CUSTOM_DEFINE_MACOS=1;;
    CYGWIN*)    GLOBAL_PLATFORM_CUSTOM_DEFINE_CYGWIN=1;;
    MINGW*)     GLOBAL_PLATFORM_CUSTOM_DEFINE_MINGW=1;;
    *)          GLOBAL_PLATFORM_CUSTOM_DEFINE_UNKOWN=1;;
esac
#other
if [ -n $GLOBAL_PLATFORM_CUSTOM_DEFINE_MACOS ]; then
	SELF_PRIVATE_HASH=$(echo -n "$(pwd)/$0" | shasum | awk '{print $1}')
else
	SELF_PRIVATE_HASH=$(echo -n "$(pwd)/$0" | sha1sum | awk '{print $1}')
fi
if [ -n $GLOBAL_PLATFORM_CUSTOM_DEFINE_MACOS ]; then
	SELF_PRIVATE_HASH_V2=$(echo -n "$PATH_BIN" | shasum | awk '{print $1}')
else
	SELF_PRIVATE_HASH_V2=$(echo -n "$PATH_BIN" | sha1sum | awk '{print $1}')
fi
TASK_LOCK="occupat.task.lock.$SELF_PRIVATE_HASH"
TASK_LOCK_V2="occupatex.task.lock.$SELF_PRIVATE_HASH_V2"
