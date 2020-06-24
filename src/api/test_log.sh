#!/bin/bash
export DIR_API_DEFAULT=$(cd $(dirname $0); pwd)
echo "----------------------$0 DIR_API_DEFAULT = $DIR_API_DEFAULT test_log.sh----------------------"
source $DIR_API_DEFAULT/log.sh

test_log_raw() {
	log "hello world!"
	log ok "hello world!"
	log debug "hello world!"
	log trace "hello world!"
	log warn "hello world!"
	log error "hello world!"
	log info "hello world!"
	log fatal "hello world!"
}
test_log_self() {
	log self red "hello world!"
	log self blue "hello world!"
	log self black "hello world!"
	log self green "hello world!"
	log self cyan "hello world!"
	log self white "hello world!"
	log self green "hello world!"
	log self magenta "hello world!"
}

test_log() {
	log_trace "hello world!"
	log_trace_msg "hello world!"
	log_debug "hello world"
	log_debug_msg "hello world"
	log_info "hello world"
	log_msg "hello world"
	log_warn "hello world"
	log_error "hello world"
	log_ok "hello world"
	log_fail "hello world"
	log_fatal_msg "hello world!"
	log_fatal "hello world"
}

main() {
	test_log_self
	test_log_raw
	test_log
}

#main loop
main "$@"
