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

#This line here because of some output error when excuting occsurs from crontab ("tput: No value for $TERM and no -T specified").
#Some specified issue found from overflow here: https://stackoverflow.com/questions/29979966/tput-no-value-for-term-and-no-t-specified-error-logged-by-cron-process
#The cron daemon is run by 'root' user in its own shell. By default, cron will append a system mail sent to the user running the script (that's why you see the sender as 'root' in the system mail). The 'user' is the user you were logged in as when setting the crontab. The mail will contain console and error messages. On Ubuntu, the mail file is viewable at /var/mail/<username>.
#
#If no $TERM variable is set, cron will emit a tput: No value for $TERM and no -T specified error in the mail file. To stop these errors, set the $TERM variable using TERM=dumb (or another available terminal in your system, like xterm) in the crontab. The toe command will show you the terminfo definitions on the current system. If you lack that command, you can see the raw data in /usr/share/terminfo on most Linux systems.
#
#Even though you have stopped the errors, you may still get appended system mail with console messages. This file will fill up like a log over time, so you may want to stop these messages. To stop cron system mail, set the MAILTO variable using MAILTO=""
#
#So your crontab might look like:
#
#MAILTO=""
#TERM=xterm
#
#* * * * * sh /path/to/myscript.sh
#You can view the crontab (for the user you are signed in as) with 'crontab -l'.
#
#So under the crontab mode TERM will be dumb here(UBUNTU 20 LTS SERVER), so must be replaced with xterm.
[[ $TERM=="dumb" ]] && export TERM=xterm

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

is_interactive_mode() {
    # [[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'
    [[ $- == *i* ]] && return 0 || return 1
}

time_string() {
    echo -e `date +"%Y-%m-%d %H:%M:%S"`
}
