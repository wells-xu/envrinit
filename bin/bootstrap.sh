#!/bin/bash
set -e
DIR_WORK_LOCAL=~/.local

init() {
	mkdir -p $DIR_WORK_LOCAL/bin
	mkdir -p $DIR_WORK_LOCAL/etc
	cd $DIR_WORK_LOCAL
	if [ -d $DIR_WORK_LOCAL/envrinit ]; then
		cd $DIR_WORK_LOCAL/envrinit
		git pull
	else
		git clone https://github.com/wells-xu/envrinit.git
	fi
	cp -rv envrinit/bin/* $DIR_WORK_LOCAL/bin/
	cp -rv envrinit/etc/* $DIR_WORK_LOCAL/etc/
	cp -v envrinit/bootstrap.sh $DIR_WORK_LOCAL/bin/

	# source vimrc.vim
	touch ~/.vimrc
	sed -i "\:$DIR_WORK_LOCAL/etc/vimrc.vim:d" ~/.vimrc
	echo "source $ETC/vimrc.vim" >> ~/.vimrc
}

main() {
}

#main loop
main "$@"
