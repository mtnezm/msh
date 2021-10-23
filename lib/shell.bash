#!/usr/bin/env bash

#
# Specific terminal behavior parameters are stored
# in this file. Customize to your liking.
#

####
# History
##

shopt -s histappend  # Append to the history file, don't overwrite it
shopt -s cmdhist     # Save multi-line commands as one command
shopt -s histreedit  # use readline on history
shopt -s histverify  # load history line onto readline buffer for editing
shopt -s lithist     # save history with newlines instead of ; where possible

HIST_STAMPS="yyyy-mm-dd"            # Time stamps. Available formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HISTSIZE=500000                     # Huge history. Doesn't appear to slow
HISTFILESIZE=100000                 #   things down, so why not?
HISTCONTROL="erasedups:ignoreboth"  # Avoid duplicate entries
HISTIGNORE="&:[ ]*:exit:history:q"  # Don't record some commands
HISTTIMEFORMAT='%F %T '             # Use standard ISO 8601 timestamp. %F equals to %Y-%m-%d, %T to %H:%M:%S (24h format)

bind '"\e[A": history-search-backward'  #
bind '"\e[B": history-search-forward'   # Enable incremental history search with up/down arrows (also Readline goodness)
bind '"\e[C": forward-char'             # Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-hi
bind '"\e[D": backward-char'            #


####
# Shell
##

set -o noclobber                          # Prevent file overwrite on stdout redirection ('>'). Use '>|' to force redirection to an existing file

shopt -s direxpand                        # Don't escape variables on tab
shopt -s checkwinsize                     # Update window size after every command
shopt -s globstar 2> /dev/null            # Turn on recursive globbing (enables ** to recurse all directories)
shopt -s nocaseglob                       # Case-insensitive globbing (used in pathname expansion)
shopt -s interactive_comments             # Recognize comments
shopt -s autocd 2> /dev/null              # Prepend cd to directory names automatically
shopt -s dirspell 2> /dev/null            # Correct spelling errors during tab-completion
shopt -s cdspell 2> /dev/null             # Correct spelling errors in arguments supplied to cd
shopt -s cdable_vars                      # This allows you to bookmark your favorite places across the file system

bind Space:magic-space                    # Enable history expansion with space. E.g. typing !!<space> will replace !! with your last command
bind "set completion-ignore-case on"      # Perform file completion in a case insensitive fashion
bind "set completion-map-case on"         # Treat hyphens and underscores as equivalent
bind "set show-all-if-ambiguous on"       # Display matches for ambiguous patterns at first tab press
bind "set mark-symlinked-directories on"  # Immediately add a trailing slash when autocompleting symlinks to directories

export LANG=en_US.UTF-8                   # Manually set language environment
export ARCHFLAGS="-arch x86_64"           # Compilation flags

CASE_SENSITIVE="false"                    # Enable/disable case-sensitive completion.
DISABLE_AUTO_TITLE="true"                 # Enable/disable auto-setting terminal title.
ENABLE_CORRECTION="true"                  # Enable/disable command auto-correction.
COMPLETION_WAITING_DOTS="true"            # Enable/disable to display red dots whilst waiting for completion.
DISABLE_UNTRACKED_FILES_DIRTY="false"     # Enable/disable marking untracked files under VCS as dirty. This makes repo status check for large repositories much faster.
PROMPT_DIRTRIM=2                          # Automatically trim long paths in the prompt (requires Bash 4.x)
CDPATH="."                                # This defines where cd looks for targets. Add the directories you want to have fast access to, separated by colon
                                          # Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects

####
# Editors
##

if [[ -n ${SSH_CONNECTION} ]]; then                                                   #
  export EDITOR="$((which nvim || which vim || which vi || which nano)2>/dev/null)"   # Set the preferred editor for local and remote sessions
else                                                                                  # (pick the first one available)
  export EDITOR="$((which nvim || which vim || which vi || which nano)2>/dev/null)"   #
fi                                                                                    #


####
# LANG
##

if [[ -z "${LC_CTYPE}" && -z "${LC_ALL}" ]]; then #
  export LC_CTYPE=${LANG%%:*}                     # Only define LC_CTYPE if undefined (pick the first entry from LANG)
fi                                                #


####
# Man
##

export MANPATH="/usr/share/man:${MANPATH}"        # Declare default MANPATH variable

if [ -n "${MANPATH}" ]; then                      # Avoid adding duplicate entries to ${MANPATH} each time reload() is run
  PREV_MANPATH=${MANPATH}:; MANPATH=
  while [ -n "${PREV_MANPATH}" ]; do
    x=${PREV_MANPATH%%:*}                         # the first remaining entry
    case ${MANPATH}: in
      *:"${x}":*) ;;                              # already there
      *) MANPATH=${MANPATH}:${x};;                # not there yet
    esac
    PREV_MANPATH=${PREV_MANPATH#*:}
  done
  MANPATH=${MANPATH#:}
  unset PREV_MANPATH x
fi
