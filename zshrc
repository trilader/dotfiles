# kate: syntax zsh;

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

def update-dotfiles()
{
    pushd $__DOTFILES > /dev/null
    git pull
    popd > /dev/null
}

if [ -f "/etc/gentoo-release" ]; then
    def open-gentoobug()
    {
        if [ -z "$1" ]; then
            echo "Usage: open-gentoobug <bug-id>"
            return 1
        fi
        xdg-open "https://bugs.gentoo.org/show_bug.cgi?id=$1"
        return 0
    }

    alias sync-portage='sudo eix-sync'
    alias update-world='sudo emerge -avDNu --with-bdeps=y @world'
    alias preserved-rebuild='sudo emerge -a @preserved-rebuild'
    alias depclean-world='sudo emerge -ac'
    alias estimate-update='emerge -DNup @world|genlop -p'
fi

if [[ -e "$XDG_RUNTIME_DIR/ssh-agent.socket" && -z "$SSH_AUTH_SOCK" ]]; then
	export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi
export PATH=$HOME/bin:$HOME/.local/bin:$PATH
export MOSH_TITLE_NOPREFIX=1
export EDITOR=vim

alias watch='watch -c'
alias fuck='sudo $(fc -ln -1)'
alias ddstatus='dd status=progress'
alias sddstatus='sudo dd status=progress'

# ctrl-s will no longer freeze the terminal.
stty erase "^?"

antigen use oh-my-zsh
antigen bundle colored-man-pages
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle history-substring-search
antigen bundle mosh
antigen bundle git
antigen bundle virtualenv
antigen bundle screen
antigen theme gallifrey
antigen apply

def autoquote()
{
    for f in $(cat); do echo -n "'$f', "; done
}

def playtwitch()
{
    if [ -z "$1" ]; then
         echo "Expected channel name as first parameter"
         return 1
    fi
    xdg-open "https://player.twitch.tv?channel=${1}&html5"
}

def sltwitch()
{
    CHANNEL=$1
    shift
    if [ -z "$CHANNEL" ]; then
         echo "Expected channel name as first parameter"
         return 1
    fi
    QUALITY="best"
    ARGS="--player mpv --retry-streams 60 --twitch-disable-hosting --default-stream $QUALITY"
    streamlink $=ARGS "twitch.tv/$CHANNEL" $@
}

if [ -e ".autoscreen" -a -n "$(which screen)" ]; then
    [ -z "$SSH_CONNECTION" ] && (screen -qx || screen)
fi

# vim: set ai sw=4 ts=4 expandtab:
