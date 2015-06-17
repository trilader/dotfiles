export __DOTFILES=$(dirname $(readlink -f ${(%):-%N}))

source $__DOTFILES/antigen/antigen.zsh

HOST_PARTS=${(s:.:)HOST}
for i in {${#HOST_PARTS}..1}; do
    candidate_part=${(j:.:)${HOST_PARTS[$i,${#HOST_PARTS}]}}
    candidate_file=$__DOTFILES/${candidate_part}.profile
    if [ -f $candidate_file ]; then
        source $candidate_file
    fi
done

export PATH=$HOME/bin:$HOME/.local/bin:$PATH
export MOSH_TITLE_NOPREFIX=1
export EDITOR=vim

alias watch='watch -c'
alias estimate-update='emerge -DNup @world|genlop -p'
alias fuck='sudo $(fc -ln -1)'
# ctrl-s will no longer freeze the terminal.
stty erase "^?"

antigen use oh-my-zsh
antigen bundle colored-man
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle history-substring-search
antigen bundle mosh
antigen bundle git
antigen bundle virtualenv
antigen bundle screen
antigen theme gallifrey
antigen-apply

if [ -e ".autoscreen" -a -n "$(which screen)" ]; then
    [ -z "$STY" ] && (screen -qx || screen)
fi