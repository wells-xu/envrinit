#!/bin/bash
set -e
DIR_WORK_LOCAL=~/.local

init() {
	mkdir -p $DIR_WORK_LOCAL/bin
	mkdir -p $DIR_WORK_LOCAL/etc
	cd $DIR_WORK_LOCAL
	if [ -d $DIR_WORK_LOCAL/envrinit ]; then
		cd $DIR_WORK_LOCAL/envrinit && git pull
	else
		git clone https://github.com/wells-xu/envrinit.git
	fi
	cp -rv envrinit/bin/* $DIR_WORK_LOCAL/bin/
	cp -rv envrinit/etc/* $DIR_WORK_LOCAL/etc/
	cp -v envrinit/bootstrap.sh $DIR_WORK_LOCAL/bin/

    # source init.sh
    sed -i "\:$DIR_WORK_LOCAL/etc/init.sh:d" ~/.bashrc
    echo ". $DIR_WORK_LOCAL/etc/init.sh" >> ~/.bashrc
    . ~/.bashrc

    # for neovim
    if [ -f $DIR_WORK_LOCAL/etc/init.vim ]; then
        mkdir -p ~/.config/nvim
        cp $DIR_WORK_LOCAL/etc/init.vim ~/.config/nvim/init.vim
    fi

    # source vimrc.vim
    touch ~/.vimrc
    sed -i "\:$DIR_WORK_LOCAL/etc/vimrc.vim:d" ~/.vimrc
    echo "source $DIR_WORK_LOCAL/etc/vimrc.vim" >> ~/.vimrc

    # update git config
    git config --global color.status auto
    git config --global color.diff auto
    git config --global color.branch auto
    git config --global color.interactive auto
    git config --global core.quotepath false

    # install vim plug
    if command -v nvim 2>/dev/null; then
        nvim +PlugInstall +qall
    else
        vim_version=`vim --version | head -1`
        if [[ `echo $vim_version | awk -F '[ .]' '{print $5}'` -gt 7 ]]; then
            vim +PlugInstall +qall
        fi
    fi
}

main() {
}

#main loop
main "$@"
