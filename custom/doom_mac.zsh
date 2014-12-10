if [ ! -d "$HOME" ]; then
    [[ -d "/tmp/$USER" ]] || mkdir "/tmp/$USER"
    export HOME="/tmp/$USER"
    [[ -d "$HOME/.ssh" ]] || mkdir "$HOME/.ssh"
fi

[[ -d "$HOME/.ssh" ]] || mkdir "$HOME/.ssh"
touch "$HOME/.ssh/known_hosts"
    
ZSH_THEME="baba"

setopt no_beep
setopt APPEND_HISTORY         # Apppends the histroy file instead of overriding original one
setopt INC_APPEND_HISTORY     # Update history file after the commmand is execuated... otherwise it will do it when shell exits
setopt SHARE_HISTORY          # share between multiple shells
setopt EXTENDED_HISTORY       # store times and all crap,.. not
setopt HIST_EXPIRE_DUPS_FIRST # store dups, but when history reaches the capacilty, then expire the DUP entries first
setopt HIST_REDUCE_BLANKS     #
setopt HIST_IGNORE_SPACE      #
setopt HIST_FIND_NO_DUPS      # As the same suggest, dont fine dups
setopt HIST_VERIFY             # Make those history commands nice

if [[ "$OSTYPE" = darwin* ]]; then
  DISABLE_AUTO_UPDATE="false"
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_71.jdk/Contents/Home
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/apollo/env/envImprovement/bin"
  export PATH="/apollo/env/ruby193/bin:/apollo/env/SDETools/bin:$PATH"
  export PATH="$HOME:$PATH"
  export PATH="$HOME/bin:$PATH"
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
  export ANT_OPTS='-Dbuild.compiler=javac1.7'
else
  DISABLE_AUTO_UPDATE="true"
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/apollo/env/envImprovement/bin:/apollo/env/SDETools/bin:/apollo/env/BigBirdTools/bin"
  export PATH="$HOME:$PATH"
  export PATH="$HOME/bin:$PATH"
fi

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'
export SSH_AUTH_SOCK=$HOME/.ssh_auth_sock

alias doom='ssh dumanshu-2.desktop.amazon.com'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll="ls -al"
alias h="hostname"
alias l="ls -altrh"
alias c="clear"
alias ssh=ssh-nirvana
alias ssh2=ssh
alias f='find . -type f -follow -name '
alias g='find . -type f -follow | xargs grep'
alias ts='tail -f `ls -tr | grep serv | tail -1`'
alias szsh='source ~/.zshrc'
alias gs="git status"
alias gr="GIT_EDITOR=emacs git pull -r"

alias scssh='/apollo/env/MidwayClient/bin/ssh -I /usr/lib64/libeToken.so'
alias scssh-agent='/apollo/env/MidwayClient/bin/ssh-agent'
alias scssh-add='/apollo/env/MidwayClient/bin/ssh-add'
alias scpin='source ~/.ssh-agent-start'
alias screpin='killall ssh-agent; source ~/.ssh-agent-start'

alias bb="brazil-build"
alias bba="brazil-build apollo-pkg"
alias bbs="brazil-build server"
alias bbr="brazil-recursive-cmd-parallel -j 4 -- brazil-build"
alias bbg="brazil ws --sync -md && git pull -r"
btst() { brazil-build single-test -DtestClass="$1" }

alias cdrr='cd /apollo/env/BigBirdRequestRouterService/var/output/logs'
alias cdsr='cd /apollo/env/BigBirdStreamRouterService/var/output/logs'
alias cdsn='cd /apollo/env/BigBirdStorageNode/var/output/logs'

alias dumpActivePartitions='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName partitions | grep ACTIVE'
alias dumpActiveTables='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName tables | grep ACTIVE'
alias dumpActiveIndexes='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName indexes | grep ACTIVE'
alias dumpFrozenPartitions='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName partitions | grep FROZEN'
alias dumpFrozenTables='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName tables | grep FROZEN'
 
alias dumpPartitions='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName partitions'
alias dumpTables='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName tables'
alias dumpReplicas='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName replicas'
alias dumpExNodesBb='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName extended-nodes --dataSource BIGBIRD'
alias dumpExNodesAlf='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName extended-nodes --dataSource ALF'
alias dumpNodesAlf='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName nodes --dataSource ALF'
alias dumpSubscribers='/apollo/env/BigBirdTools/bin/tableDumper --subscriberId BigBird --tableName subscribers'
 
alias heyReplication='/apollo/env/BigBirdTools/bin/messageBusTool --componentName OpsToolsMsgHandler --operation REQUEST'

#local _myhosts
_myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*' hosts $_myhosts

setupIfOnlyOneApolloEnv() {
    if [ `ls -1 /apollo/env 2>/dev/null | wc -l` = "1" ]; then
        apolloEnv `ls -1 /apollo/env`
    fi
}
setupIfOnlyOneApolloEnv

function review-board-patch { sed -e 's/ \([ab]\)\/pkg\/[^:]\+\:/ \1/g' "$1" | patch -p1; }
export -f review-board-patch > /dev/null

awsToEmail()
{
    for i in $*; do awsSingleToEmail $i; done
}
awsSingleToEmail() {
    perl -e ' my $html = `kcurl -s --negotiate -u : -k "https://aws-tools.amazon.com/servicetools/search.aws?searchType=ACCOUNT\&query=$ARGV[0]"`; 
    my ($email) = $html =~ / ([^ ]+\@[^ ]+) /;
    print "$email\n";' $1
}

function scrub_env {
  local ENVNAME="$1"
  [ -n "$ENVNAME" ] && sudo rm -vrf \
     "/apollo/env/$ENVNAME" \
     "/apollo/_env/$ENVNAME"* \ 
     "/apollo/var/env/$ENVNAME";
}

selectEnv() {
         if [ -d /apollo/env ]; then
            echo
            echo -------
            ls -1 /apollo/env |nl
            echo -------
            echo
            echo "Enter environment number to select"
            read envNum
            apolloEnv `ls -1 /apollo/env |sed -n $envNum'p'`
        fi
}

# -------------------------------------------------------------------
# compressed file expander 
# (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# -------------------------------------------------------------------
ex() {
    if [[ -f $1 ]]; then
        case $1 in
          *.tar.bz2) tar xvjf $1;;
          *.tar.gz) tar xvzf $1;;
          *.tar.xz) tar xvJf $1;;
          *.tar.lzma) tar --lzma xvf $1;;
          *.bz2) bunzip $1;;
          *.rar) unrar $1;;
          *.gz) gunzip $1;;
          *.tar) tar xvf $1;;
          *.tbz2) tar xvjf $1;;
          *.tgz) tar xvzf $1;;
          *.zip) unzip $1;;
          *.Z) uncompress $1;;
          *.7z) 7z x $1;;
          *.dmg) hdiutul mount $1;; # mount OS X disk images
          *) echo "'$1' cannot be extracted via >ex<";;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -------------------------------------------------------------------
# any function from http://onethingwell.org/post/14669173541/any
# search for running processes
# -------------------------------------------------------------------
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}