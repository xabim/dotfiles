# -----------------
# Zsh configuration
# -----------------
#

# Uncomment for debug with `zprof`
# zmodload zsh/zprof

export DOTFILES_PATH=$HOME/.dotfiles
export DOTFILES_WORK_PATH=$HOME/.dotfiles_work
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# ZSH Ops
## History
#
# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FCNTL_LOCK
# setopt autopushd

# git
#
# Set a custom prefix for the generated aliases. The default prefix is 'G'.
zstyle ':zim:git' aliases-prefix 'g'

# Start zim
source ${ZIM_HOME}/init.zsh

# Async mode for autocompletion
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_MAXLENGTH=300

source $DOTFILES_PATH/terminal/init.sh

fpath=("$DOTFILES_PATH/terminal/zsh/themes" "$DOTFILES_PATH/terminal/zsh/completions" $fpath)

autoload -Uz promptinit && promptinit

source $DOTFILES_PATH/terminal/zsh/key-bindings.zsh

# Add fuck command
eval $(thefuck --alias)

# Add asdf
source /opt/homebrew/opt/asdf/libexec/asdf.sh
source <(aws-okta completion zsh)

export no_proxy="*"

# Add work source if exists
[ -d $DOTFILES_WORK_PATH ] && source $DOTFILES_PATH/terminal/init_work.sh

