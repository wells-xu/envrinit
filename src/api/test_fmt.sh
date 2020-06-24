#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT test_fmt.sh----------------------"
source $DIR_API_DEFAULT/fmt.sh

test_raw() {
	col_fmt "-----------normal output-----------" green null bold null
	col_fmt "hello world!"
	col_fmt "-----------font various color-----------" green null bold null
	col_fmt "hello world!" black
	col_fmt "hello world!" white
	col_fmt "hello world!" yellow
	col_fmt "hello world!" red
	col_fmt "hello world!" cyan
	col_fmt "hello world!" green
	col_fmt "hello world!" magenta
	col_fmt "hello world!" blue
	col_fmt "----------with bg color------------" green null bold null
	col_fmt "hello world!" white red
	col_fmt "hello world!" white green
	col_fmt "hello world!" white black
	col_fmt "hello world!" white yellow
	col_fmt "hello world!" white cyan
	col_fmt "hello world!" white magenta
	col_fmt "hello world!" white blue
	col_fmt "hello world!" black white
	col_fmt "hello world!" black green
	col_fmt "hello world!" black cyan
}

log_trace() {
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" cyan >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" white >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" black >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" yellow >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" green >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" green null bold >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" magenta >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" blue >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" red >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] ----------------------------" green null bold >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" white cyan >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" white black >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" white yellow >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" white green >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" white magenta >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" white blue >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" white red >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] -----------magenta-----------------" green null bold >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" magenta white >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" magenta black >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" magenta cyan >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" magenta yellow >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" magenta green >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" magenta blue >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" magenta red >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] -----------blue-----------------" green null bold >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" blue white >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" blue black >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" blue cyan >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" blue yellow >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" blue green >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" blue magenta >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" blue red >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] -----------red-----------------" green null bold >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" red white >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" red black >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" red cyan >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" red yellow >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" red green >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" red magenta >&2
	col_fmt "TRACE $(_fmt_date) [${FUNCNAME[2]}->${FUNCNAME[1]}->${FUNCNAME[0]}] $@" red blue >&2
}

main() {
	col_fmt "[do_or_die] success done: [ls -l]" green
    test_raw
log_trace "haha ni shi ge qi pa a"
}

#main loop
main "$@"

