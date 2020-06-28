# editor
if command -v nvim > /dev/null 2>&1; then
    alias vim=nvim
    export VISUAL=nvim
else
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

# Alias for tree view of commit history.
git config --global alias.tree "log --all --graph --decorate=short --color --format=format:'%C(bold blue)%h%C(reset) %C(auto)%d%C(reset)\n         %C(blink yellow)[%cr]%C(reset)  %x09%C(white)%an: %s %C(reset)'"

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
