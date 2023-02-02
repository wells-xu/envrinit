#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)/api
[ ! -d $DIR_API_DEFAULT ] && DIR_API_DEFAULT=~/.local/api
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT fmt.sh----------------------"

_fmt_date() {
    echo -e `date +"%Y-%m-%d %H:%M:%S"`"\t"
}
# $1 log       print string
# $2 color     0-7 设置颜色
	#0: black
	#1: blue
	#2: green
	#3: cyan
	#4: red
	#5: magenta
	#6: yellow
	#7: white
# $3 bgcolor   0-7 设置背景颜色
	#0: black
	#1: red
	#2: green
	#3: cyan
	#4: blue
	#5: magenta
	#6: yellow
	#7: white
# $4 bold      0-1 设置粗体
	#0: normal
	#1: bold
# $5 underline 0-1 设置下划线
	#0: normal
	#1: underline

col_fmt() {
    local log_="$1"
	#echo "[fmt0]---$@---"
	#echo "[fmt1]---$1---"
	#echo "[fmt2]---$2---"
	#echo "[fmt3]---$3---"
	#echo "[fmt4]---$4---"
	#echo "[fmt5]---$5---"
    local color_=$2
    local bgcolor_=$3
    local bold_=$4
    local underline_=$5
    local setnormal=$(tput sgr0)

    local setcolor=
    case "$color_" in
    black)
	    setcolor=$(tput setaf 0;) ;;
	red)
	    setcolor=$(tput setaf 1;) ;;
	green)
	    setcolor=$(tput setaf 2;) ;;
	cyan)
	    setcolor=$(tput setaf 3;) ;;
	blue)
	    setcolor=$(tput setaf 4;) ;;
	magenta)
	    setcolor=$(tput setaf 5;) ;;
	yellow)
	    setcolor=$(tput setaf 6;) ;;
	white)
	    setcolor=$(tput setaf 7;) ;;
        *)
            setcolor="" ;;
    esac

    case "$bgcolor_" in
    black)
        setbgcolor=$(tput setab 0;) ;;
	red)
	    setbgcolor=$(tput setab 1;) ;;
	green)
	    setbgcolor=$(tput setab 2;) ;;
	cyan)
	    setbgcolor=$(tput setab 3;) ;;
	blue)
	    setbgcolor=$(tput setab 4;) ;;
	magenta)
	    setbgcolor=$(tput setab 5;) ;;
	yellow)
	    setbgcolor=$(tput setab 6;) ;;
	white)
	    setbgcolor=$(tput setab 7;) ;;
        *)
            setbgcolor="" ;;
    esac

    if [ "$bold_" = "bold" ]; then
        setbold=$(tput bold;)
    else
        setbold=""
    fi

    if [ "$underline_" = "underline" ]; then
        setunderline=$(tput smul;)
    else
        setunderline=""
    fi

    printf "$setcolor$setbgcolor$setbold$setunderline$log_$setnormal\n"
}

# colour macros
if [ -t 1 ]
then
    BLACK="$( echo -e "\e[30m" )"
    RED="$( echo -e "\e[31m" )"
    GREEN="$( echo -e "\e[32m" )"
    YELLOW="$( echo -e "\e[33m" )"
    BLUE="$( echo -e "\e[34m" )"
    PURPLE="$( echo -e "\e[35m" )"
    CYAN="$( echo -e "\e[36m" )"
    WHITE="$( echo -e "\e[37m" )"

    HL_BLACK="$( echo -e "\e[30;1m" )"
    HL_RED="$( echo -e "\e[31;1m" )"
    HL_GREEN="$( echo -e "\e[32;1m" )"
    HL_YELLOW="$( echo -e "\e[33;1m" )"
    HL_BLUE="$( echo -e "\e[34;1m" )"
    HL_PURPLE="$( echo -e "\e[35;1m" )"
    HL_CYAN="$( echo -e "\e[36;1m" )"
    HL_WHITE="$( echo -e "\e[37;1m" )"

    BG_BLACK="$( echo -e "\e[40m" )"
    BG_RED="$( echo -e "\e[41m" )"
    BG_GREEN="$( echo -e "\e[42m" )"
    BG_YELLOW="$( echo -e "\e[43m" )"
    BG_BLUE="$( echo -e "\e[44m" )"
    BG_PURPLE="$( echo -e "\e[45m" )"
    BG_CYAN="$( echo -e "\e[46m" )"
    BG_WHITE="$( echo -e "\e[47m" )"

    NORMAL="$( echo -e "\e[0m" )"
fi

_black()  { echo "$BLACK""$@""$NORMAL";}
_red()    { echo "$RED""$@""$NORMAL";}
_green()  { echo "$GREEN""$@""$NORMAL";}
_yellow() { echo "$YELLOW""$@""$NORMAL";}
_blue()   { echo "$BLUE""$@""$NORMAL";}
_purple() { echo "$PURPLE""$@""$NORMAL";}
_cyan()   { echo "$CYAN""$@""$NORMAL";}
_white()  { echo "$WHITE""$@""$NORMAL";}

_hl_black()  { echo "$HL_BLACK""$@""$NORMAL";}
_hl_red()    { echo "$HL_RED""$@""$NORMAL";}
_hl_green()  { echo "$HL_GREEN""$@""$NORMAL";}
_hl_yellow() { echo "$HL_YELLOW""$@""$NORMAL";}
_hl_blue()   { echo "$HL_BLUE""$@""$NORMAL";}
_hl_purple() { echo "$HL_PURPLE""$@""$NORMAL";}
_hl_cyan()   { echo "$HL_CYAN""$@""$NORMAL";}
_hl_white()  { echo "$HL_WHITE""$@""$NORMAL";}

_bg_black()  { echo "$BG_BLACK""$@""$NORMAL";}
_bg_red()    { echo "$BG_RED""$@""$NORMAL";}
_bg_green()  { echo "$BG_GREEN""$@""$NORMAL";}
_bg_yellow() { echo "$BG_YELLOW""$@""$NORMAL";}
_bg_blue()   { echo "$BG_BLUE""$@""$NORMAL";}
_bg_purple() { echo "$BG_PURPLE""$@""$NORMAL";}
_bg_cyan()   { echo "$BG_CYAN""$@""$NORMAL";}
_bg_white()  { echo "$BG_WHITE""$@""$NORMAL";}
