#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

if [ -f ~/.dircolors ]; then
  eval $(gdircolors ~/.dircolors)
fi

# Customize to your needs...
export XDG_CONFIG_HOME=~/.config

PATH=${PATH}:"$HOME/.cargo/bin"
export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src"

export PATH="$HOME/.rbenv/shims:$PATH"

eval "$(rbenv init -)"

export PATH="/usr/local/smlnj/bin:$PATH"

setopt auto_cd
function chpwd() { exa -a }

bindkey -v

bindkey -M viins 'jj' vi-cmd-mode

tmux setw -g mode-keys vi

# mkdirとcdを同時実行
function mkcd() {
  if [[ -d $1 ]]; then
    echo "$1 already exists!"
    cd $1
  else
    mkdir -p $1 && cd $1
  fi
}


function get_load_average_tmux(){
    echo "(#[fg=yellow]$(uptime | awk '{print $(NF-2)}')#[default]) "
}

function get_volume_tmux() {
    if sound_info=$(osascript -e 'get volume settings') ; then
        if [ "$(echo $sound_info | awk '{print $8}')" = "muted:false" ]; then
            sound_volume=$(expr $(echo $sound_info | awk '{print $2}' | sed "s/[^0-9]//g") / 6 )
            str=""
            for ((i=0; i < $sound_volume; i++ )); do
                str="${str}■"
            done
            for ((i=$sound_volume; i < 16; i++ )); do
                str="${str} "
            done
            sound="#[bold][$str]#[default] "
        else
            sound="#[bold][      mute      ]#[default] "
        fi
        echo $sound
    fi
}

function get_ssid_tmux() {

    airport_path="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

    if air_info=($(eval "$airport_path" -I | grep -E "^ *(agrCtlRSSI|state|SSID):" | awk '{print $2}')) ; then

        rssi=${air_info[0]}
        state=${air_info[1]}
        ssid=${air_info[2]}

        case "$state" in
            "running" )
                signals=(▁ ▂ ▄ ▆ █)
                signal=""
                rssi_=$(expr 5 - ${rssi} / -20)
                for ((i=0; i < $rssi_; i++ )); do
                    signal="${signal}${signals[$i]}"
                done
                airport_=" #[underscore]${ssid}#[default] | ${signal} "
                ;;
            "init"    ) airport_="#[fg=yellow] ... " ;;
            *         ) airport_="#[fg=red] ✘  " ;;
        esac
        echo "#[bold]|#[default]${airport_}#[fg=colour014]|#[default] "
        fi
    }


# Goolge Search by Google Chrome
# terminalからググったりqiita検索をできる
google() {
    local str opt
    if [ $# != 0 ]; then
        for i in $*; do
            # $strが空じゃない場合、検索ワードを+記号でつなぐ(and検索)
            str="$str${str:++}$i"
        done
        opt='search?num=100'
        opt="${opt}&q=${str}"
    fi
    open -a Google\ Chrome http://www.google.co.jp/$opt
}

safari() {
    local str opt
    if [ $# != 0 ]; then
        for i in $*; do
            # $strが空じゃない場合、検索ワードを+記号でつなぐ(and検索)
            str="$str${str:++}$i"
        done
        opt='search?num=100'
        opt="${opt}&q=${str}"
    fi
    open -a "Safari" http://www.google.co.jp/$opt
}

qiita() {
    local str opt
    if [ $# != 0 ]; then
        for i in $*; do
            # $strが空じゃない場合、検索ワードを+記号でつなぐ(and検索)
            str="$str${str:++}$i"
        done
        opt='search?num=100'
        opt="${opt}&q=${str}"
    fi
    open -a "Safari" http://qiita.com/$opt
}

# peco を使えるようにする
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

alias ls='exa'
alias ll='ls -alF'
alias la='ls -a'

alias cat='bat'
alias grep='rg'

alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gst='git status'
alias gp='git push'
alias gb='git branch'
alias gco='git checkout'
alias gf='git fetch'
alias gc='git commit'

alias n='nvim'
alias nv='nvim'

alias szrc='source ~/.zshrc'

alias o='open'
