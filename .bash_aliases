
# generates the properly funcioning alias for fuck
eval "$(thefuck --alias)"

# make lower-case aliases for all flatpaks
flatpaks=$(flatpak list --app --columns=application)
for uri in $flatpaks; do
    uriParts=( $(echo $uri | tr '.' ' ') )
    name=$( echo ${uriParts[-1]} | tr '[:upper:]' '[:lower:]')
    alias $name="&>/dev/null flatpak run $uri &"
done

# navigation
alias :q="exit" # ive typed this by accident way to many times so i might as well just make this an actual shortcut
fcd() {
    if [[ -z $1 ]]; then
        depth=6
        echo "search depth not provided, defaulting to $depth"
    else
        depth=$1
    fi
    selectedPath=$(fd -t d -d $depth | fzf $paths)
    if [[ -n $selectedPath ]]; then
        cd "$selectedPath"
    fi
}

# yazi but when quiting cd into the dir where you ended
function yz() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [ -f "$tmp" ]; then
        local cwd="$(cat -- "$tmp")"
        if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    fi
}


# shortcuts
alias la='ls -A --group-directories-first'
alias ll='ls -Alh --group-directories-first'
alias UE='/home/cronch/unreal-engine/Engine/Binaries/Linux/UnrealEditor'
alias KSP='/home/cronch/Games/KSP/KSP_linux/KSP.x86_64'
alias librewolf='nohup &>/dev/null flatpak run io.gitlab.librewolf-community &'
alias vi='nvim'
alias Vi="nvim -c 'Telescope oldfiles' -c 'cd %:h'"
alias gdvi='nvim --listen /tmp/godot.pipe'

# utility
alias copy='xclip -selection clipboard' # pipe stuff into here to copy it
alias CA='f() { git add -u && git status && git commit -m "$1" ;}; f' # commit all
alias PA='f() { git add -u && git status && echo -e "\033[36;1m------------------------------------------------------\033[0m\n" && git commit -m "$1" && git push ;}; f'
# alias JC='javac -d build *.java && java -cp ./build Main'
alias find-history='history | grep "$@"' # currently broken
# make the following command not print any output
nolog() { 
    "$@" &>/dev/null
}
alias flex='while true do ls -aR --color=always \; done' # why do i have this..

