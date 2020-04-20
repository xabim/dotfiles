# Mac
alias out="dot package outdated"
alias up="dot package update_all"

# Brew
alias brwe="brew"
alias bsl="brew services list"

# Others
alias c='pbcopy'
alias dc='dot docker connect'
alias ping='prettyping --nolegend'

alias k='kill -9'
alias t="dot filesystem navigate_and_preview_flatten_files"
alias i.='(idea $PWD &>/dev/null &)'
alias o.='open .'

# Files being opened
alias files.open='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep|grep open'
# Files used, anywhere on the filesystem
alias files.usage='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep'
# Files in use in the Users directory
alias files.usage.user='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep|grep Users'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

alias lookbusy="cat /dev/urandom | hexdump -C | grep \"34 32\""

# Always enable colored `grep` output
alias grep='grep --color=auto '

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# vhosts
alias hosts='sudo vim /etc/hosts'

# copy file interactive
alias cp='cp -i'

# move file interactive
alias mv='mv -i'
# untar
alias untar='tar xvf'

