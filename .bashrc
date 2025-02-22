# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      # We have color support; assume it's compliant with Ecma-48
      # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
      # a case would tend to support setf rather than setaf.)
      color_prompt=yes
    else
      color_prompt=
    fi
fi

# if in a git repo, add a `(current_branch)` to the prompt and make it refresh each time a new prompt is printed
if [ "$color_prompt" = yes ]; then
    # Define color variables
    RESET="\[\033[00m\]"
    BOLD="\[\033[01m\]"
    WHITE="\[\033[01;37m\]"
    YELLOW="\[\033[33m\]"
    BLUE="\[\033[01;34m\]"

    set_git_branch_prompt() {
        if git rev-parse --is-inside-work-tree &>/dev/null; then
            git_branch_name=$(git rev-parse --abbrev-ref HEAD)
            PS1="${debian_chroot:+($debian_chroot)}\\n  ${WHITE}[${BOLD}\h${RESET}/${BOLD}\u${RESET}]${YELLOW} ${git_branch_name} ${RESET}${BOLD}${BLUE}[\w]\\n${RESET}  "
        else
            PS1="${debian_chroot:+($debian_chroot)}\\n  ${WHITE}[${BOLD}\h${RESET}/${BOLD}\u${RESET}] ${RESET}${BOLD}${BLUE}[\w]\\n${RESET}  "
        fi
    }
    PROMPT_COMMAND=set_git_branch_prompt
else
    PS1="${debian_chroot:+($debian_chroot)}┌── \u @ \h : \w\\n└ "
fi

unset color_prompt force_color_prompt


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# i have the same config on my PC and laptop, this here loads the 
# laptop specific things
if [ -f ~/.bash_laptop_aliases ]; then
    . ~/.bash_laptop_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

bind "set completion-ignore-case on"
shopt -s autocd

export XKB_DEFAULT_OPTIONS="ctrl:swapcaps"

