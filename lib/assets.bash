#!/usr/bin/env bash

#
# This file contains a bunch of shell functions and variables
# widely used beside the rest of the MSH elements
#

# Check whether a command exists
_command_exists() {
  [ "$(type -P "$1")" ]
}

# Manage shell components from the terminal
msh() {

  if [ -z "$1" ]; then
    echo -e "\n msh - Manage your terminal behavior with ease.\n\n Commands:\n\n edit\tModify the different components to your like\n reload\tApply changes to your current shell session\n show\tList the available/active items for the different components\n\n Copyright (C) 2020-2021 Miguel Martínez <mtnezm@linux.com>\n Distributed under terms of the MIT license.\n"
    return 0
  fi

  case "$1" in

    "-h"|"--help")
      echo -e "\n Manage your terminal behavior with ease.\n\n Usage:\n\n  $ msh reload\n\n  $ msh show -h\n  $ msh edit -h\n\n Copyright (C) 2020-2021 Miguel Martínez <mtnezm@linux.com>\n Distributed under terms of the MIT license.\n"
      return 0
    ;;

    reload)
      if [ "$#" -gt 1 ]; then
        echo -e "\n Usage: $ msh reload\n"
      else
        source ~/.bashrc
      fi
    ;;

    show)
      if [ -z "$2" ]; then
        echo -e "\n Tell me what to show! For further details, run:\n\n  $ msh show -h\n"
        return 0
      elif [ "$#" -eq 2 ]; then
        case "$2" in
          -h|--help) echo -e "\n Options available are:\n\n  - aliases\n  - completions\n  - plugins\n  - profiles\n  - all\n\n To show all the available elements from a component, i.e. plugins, run:\n\n  $ msh show plugins available\n" ;;
          aliases) echo ${aliases[@]} |tr " " \\n |sort ;;
          completions) echo ${completions[@]} |tr " " \\n |sort ;;
          plugins) echo ${plugins[@]} |tr " " \\n |sort ;;
          profiles) echo ${profiles[@]} |tr " " \\n |sort ;;
          all) echo -e "\n->.Active.aliases:\n\n${aliases[@]}\n\n->.Active.completions:\n\n${completions[@]}\n\n->.Active.plugins:\n\n${plugins[@]}\n\n->.Active.profiles:\n\n${profiles[@]}\n" |tr " " \\n |tr \. ' ' ;;
          *) echo -e "\n Error: \"$2\" is unknown. Options available are:\n\n  - aliases\n  - completions\n  - plugins\n  - profiles\n  - all\n" ; return 1 ;;
        esac
      elif [ "$#" -eq 3 ]; then
        case "$3" in
          available)
            (sed "s/\.[^.]*$//" <<<$(\ls -1 "${MSH}/main/$2/" || \ls -1 "${MSH}/include/$2/" | grep -v bash || \
            echo -e "\n Error: \"$2\" is unknown. Options available are:\n\n  - aliases\n  - completions\n  - hosts\n  - plugins\n  - profiles\n  - themes\n")) 2>/dev/null
          ;;

          *)
            (cat "${MSH}/main/"$2"/"$3"\.*" || \
            echo -e "\n Error: \"$3\" is not an element of type \"$2\". Try running:\n\n  $ msh show aliases|completions|plugins|profiles|all\n") 2>/dev/null
          ;;
        esac
      elif [ "$#" -gt 3 ]; then
        echo -e "\n Too many arguments!\n"
        return 1
      else
        echo -e "\n Error. Options available are:\n\n  - aliases\n  - completions\n  - plugins\n  - profiles\n  - all\n\n There is also the option:\n\n  $ msh show <component> available\n\n to list all the exiting resorces of type <component>"
        return 1
      fi
    ;;

    edit)
      if [ -z "$2" ]; then
        echo -e "\n Tell me what to edit! For further details, run:\n\n  $ msh edit -h\n"
        return 0
      elif [ "$#" -gt 3 ]; then
        echo -e "\n Too many arguments!\n"
        return 1
      else
        case "$2" in
          -h|--help)
            echo -e "\n Try running:\n\n  $ msh edit aliases|completion|plugin|profile <component_name>\n\n Or edit the current theme with:\n\n  $ msh edit theme\n\n Or edit the active components by running:\n\n  $ msh edit components\n"
            return 0
          ;;
          aliases)
            if [ "$#" -gt 3 ]; then
              echo -e "\n Too many arguments!\n"
              return 1
            elif [ "$#" -ne 3 ]; then
              echo -e "\n Error: Two arguments needed. Options available are: aliases|completion|plugin|profile <component_name>\n\n Example:\n  $ msh edit alias ansible\n"
              return 1
            else
              if [ -f "${MSH_ALIASES}/$3.alias" ]; then
                ${EDITOR} "${MSH_ALIASES}/$3.alias"
              else
                echo -e "\n Error: $2 for \"$3\" do not exist.\n"
                return 1
              fi
            fi
          ;;
          completions)
            if [ "$#" -gt 3 ]; then
              echo -e "\n Too many arguments!\n"
              return 1
            elif [ "$#" -ne 3 ]; then
              echo -e "\n Error: Two arguments needed. Options available are: alias|completion|plugin|profile <component_name>\n\n Example:\n  $ msh edit completion kubectl\n"
              return 1
            else
              if [ -f "${MSH_COMPLETIONS}/$3.completion" ]; then
                ${EDITOR} "${MSH_COMPLETIONS}/$3.completion"
              else
                echo -e "\n Error: $2 for \"$3\" do not exist.\n"
                return 1
              fi
            fi
          ;;
          components)
            ${EDITOR} "${MSH_CORE}/components.msh"
            source ~/.bashrc
          ;;
          plugin)
            if [ "$#" -gt 3 ]; then
              echo -e "\n Too many arguments!\n"
              return 1
            elif [ "$#" -ne 3 ]; then
              echo -e "\n Error: Two arguments needed. Options available are: alias|completion|plugin|profile <component_name>\n\n Example:\n  $ msh edit plugin git-prompt\n"
              return 1
            else
              if [ -f "${MSH_PLUGINS}/$3.plugin" ]; then
                ${EDITOR} "${MSH_PLUGINS}/$3.plugin"
              else
                echo -e "\n Error: $2 \"$3\" does not exist.\n"
                return 1
              fi
            fi
          ;;
          profile)
            if [ "$#" -gt 3 ]; then
              echo -e "\n Too many arguments!\n"
              return 1
            elif [ "$#" -ne 3 ]; then
              echo -e "\n Error: Two arguments needed. Options available are: alias|completion|plugin|profile <component_name>\n\n Example:\n  $ msh edit profile main\n"
              return 1
            elif [ -f "${MSH_PROFILES}/$3/main.bash" ]; then
              ${EDITOR} "${MSH_PROFILES}/$3/main.bash" && source ~/.bashrc || echo -e "\n Profile "$3" does not exist. Check \"${MSH_PROFILES}\" directory.\n"
            else
              echo -e "\n Error: profile \"$3\" does not exist.\n"
            fi
          ;;
          theme)
            if [ -f "${MSH_THEMES}/${MSH_THEME}/${MSH_THEME}.theme.sh" ]; then
              ${EDITOR} "${MSH_THEMES}/${MSH_THEME}/${MSH_THEME}.theme.sh"
              source ~/.bashrc
            else
              echo -e "\n Error: Configuration file not found for theme \"${MSH_THEME}\".\n"
              return 1
            fi
          ;;
          *)
            echo -e "\n Error: Unknown option.\n"
            return 1
          ;;
        esac
      fi
    ;;
    *) echo -e "\n Error: unrecognized command.\n\n Usage:\n\n  $ msh show -h\n  $ msh edit -h\n" ;;
  esac

}


####
# Theme related variables and functions
##

# Variables

black="\[\e[0;30m\]"
red="\[\e[0;31m\]"
green="\[\e[0;32m\]"
yellow="\[\e[0;33m\]"
blue="\[\e[0;34m\]"
purple="\[\e[0;35m\]"
cyan="\[\e[0;36m\]"
white="\[\e[0;37m\]"
orange="\[\e[0;91m\]"

bold_black="\[\e[30;1m\]"
bold_red="\[\e[31;1m\]"
bold_green="\[\e[32;1m\]"
bold_yellow="\[\e[33;1m\]"
bold_blue="\[\e[34;1m\]"
bold_purple="\[\e[35;1m\]"
bold_cyan="\[\e[36;1m\]"
bold_white="\[\e[37;1m\]"
bold_orange="\[\e[91;1m\]"

underline_black="\[\e[30;4m\]"
underline_red="\[\e[31;4m\]"
underline_green="\[\e[32;4m\]"
underline_yellow="\[\e[33;4m\]"
underline_blue="\[\e[34;4m\]"
underline_purple="\[\e[35;4m\]"
underline_cyan="\[\e[36;4m\]"
underline_white="\[\e[37;4m\]"
underline_orange="\[\e[91;4m\]"

background_black="\[\e[40m\]"
background_red="\[\e[41m\]"
background_green="\[\e[42m\]"
background_yellow="\[\e[43m\]"
background_blue="\[\e[44m\]"
background_purple="\[\e[45m\]"
background_cyan="\[\e[46m\]"
background_white="\[\e[47;1m\]"
background_orange="\[\e[101m\]"

normal="\[\e[0m\]"
reset_color="\[\e[39m\]"

# These colors are meant to be used with `echo -e`
echo_black="\033[0;30m"
echo_red="\033[0;31m"
echo_green="\033[0;32m"
echo_yellow="\033[0;33m"
echo_blue="\033[0;34m"
echo_purple="\033[0;35m"
echo_cyan="\033[0;36m"
echo_white="\033[0;37;1m"
echo_orange="\033[0;91m"

echo_bold_black="\033[30;1m"
echo_bold_red="\033[31;1m"
echo_bold_green="\033[32;1m"
echo_bold_yellow="\033[33;1m"
echo_bold_blue="\033[34;1m"
echo_bold_purple="\033[35;1m"
echo_bold_cyan="\033[36;1m"
echo_bold_white="\033[37;1m"
echo_bold_orange="\033[91;1m"

echo_underline_black="\033[30;4m"
echo_underline_red="\033[31;4m"
echo_underline_green="\033[32;4m"
echo_underline_yellow="\033[33;4m"
echo_underline_blue="\033[34;4m"
echo_underline_purple="\033[35;4m"
echo_underline_cyan="\033[36;4m"
echo_underline_white="\033[37;4m"
echo_underline_orange="\033[91;4m"

echo_background_black="\033[40m"
echo_background_red="\033[41m"
echo_background_green="\033[42m"
echo_background_yellow="\033[43m"
echo_background_blue="\033[44m"
echo_background_purple="\033[45m"
echo_background_cyan="\033[46m"
echo_background_white="\033[47;1m"
echo_background_orange="\033[101m"

echo_normal="\033[0m"
echo_reset_color="\033[39m"

CLOCK_CHAR_THEME_PROMPT_PREFIX=''
CLOCK_CHAR_THEME_PROMPT_SUFFIX=''
CLOCK_THEME_PROMPT_PREFIX=''
CLOCK_THEME_PROMPT_SUFFIX=''

THEME_PROMPT_HOST='\H'

SCM_CHECK=${SCM_CHECK:=true}

SCM_THEME_PROMPT_DIRTY=' ✗'
SCM_THEME_PROMPT_CLEAN=' ✓'
SCM_THEME_PROMPT_PREFIX=' |'
SCM_THEME_PROMPT_SUFFIX='|'
SCM_THEME_BRANCH_PREFIX=''
SCM_THEME_TAG_PREFIX='tag:'
SCM_THEME_DETACHED_PREFIX='detached:'
SCM_THEME_BRANCH_TRACK_PREFIX=' → '
SCM_THEME_BRANCH_GONE_PREFIX=' ⇢ '
SCM_THEME_CURRENT_USER_PREFFIX=' ☺︎ '
SCM_THEME_CURRENT_USER_SUFFIX=''
SCM_THEME_CHAR_PREFIX=''
SCM_THEME_CHAR_SUFFIX=''

THEME_BATTERY_PERCENTAGE_CHECK=${THEME_BATTERY_PERCENTAGE_CHECK:=true}

SCM_GIT_SHOW_DETAILS=${SCM_GIT_SHOW_DETAILS:=true}
SCM_GIT_SHOW_REMOTE_INFO=${SCM_GIT_SHOW_REMOTE_INFO:=auto}
SCM_GIT_IGNORE_UNTRACKED=${SCM_GIT_IGNORE_UNTRACKED:=false}
SCM_GIT_SHOW_CURRENT_USER=${SCM_GIT_SHOW_CURRENT_USER:=false}
SCM_GIT_SHOW_MINIMAL_INFO=${SCM_GIT_SHOW_MINIMAL_INFO:=false}

SCM_GIT='git'
SCM_GIT_CHAR='±'
SCM_GIT_DETACHED_CHAR='⌿'
SCM_GIT_AHEAD_CHAR="↑"
SCM_GIT_BEHIND_CHAR="↓"
SCM_GIT_UNTRACKED_CHAR="?:"
SCM_GIT_UNSTAGED_CHAR="U:"
SCM_GIT_STAGED_CHAR="S:"

SCM_HG='hg'
SCM_HG_CHAR='☿'

SCM_SVN='svn'
SCM_SVN_CHAR='⑆'

SCM_NONE='NONE'
SCM_NONE_CHAR='○'

RVM_THEME_PROMPT_PREFIX=' |'
RVM_THEME_PROMPT_SUFFIX='|'

THEME_SHOW_USER_HOST=${THEME_SHOW_USER_HOST:=false}
USER_HOST_THEME_PROMPT_PREFIX=''
USER_HOST_THEME_PROMPT_SUFFIX=''

VIRTUALENV_THEME_PROMPT_PREFIX=' |'
VIRTUALENV_THEME_PROMPT_SUFFIX='|'

RBENV_THEME_PROMPT_PREFIX=' |'
RBENV_THEME_PROMPT_SUFFIX='|'

RBFU_THEME_PROMPT_PREFIX=' |'
RBFU_THEME_PROMPT_SUFFIX='|'


# Functions

function __ {
	  echo "$@"
  }

function __make_ansi {
	  next=$1; shift
	    echo "\[\e[$(__$next $@)m\]"
    }

function __make_echo {
	  next=$1; shift
	    echo "\033[$(__$next $@)m"
    }

function __reset {
	  next=$1; shift
	    out="$(__$next $@)"
	      echo "0${out:+;${out}}"
      }

function __bold {
	  next=$1; shift
	    out="$(__$next $@)"
	      echo "${out:+${out};}1"
      }

function __faint {
	  next=$1; shift
	    out="$(__$next $@)"
	      echo "${out:+${out};}2"
      }

function __italic {
	  next=$1; shift
	    out="$(__$next $@)"
	      echo "${out:+${out};}3"
      }

function __underline {
	  next=$1; shift
	    out="$(__$next $@)"
	      echo "${out:+${out};}4"
      }

function __negative {
	  next=$1; shift
	    out="$(__$next $@)"
	      echo "${out:+${out};}7"
      }

function __crossed {
	  next=$1; shift
	    out="$(__$next $@)"
	      echo "${out:+${out};}8"
      }

function __color_normal_fg {
	  echo "3$1"
  }

function __color_normal_bg {
	  echo "4$1"
  }

function __color_bright_fg {
	  echo "9$1"
  }

function __color_bright_bg {
	  echo "10$1"
  }

function __color_black   {
	  echo "0"
  }

function __color_red   {
	  echo "1"
  }

function __color_green   {
	  echo "2"
  }

function __color_yellow  {
	  echo "3"
  }

function __color_blue  {
	  echo "4"
  }

function __color_magenta {
	  echo "5"
  }

function __color_cyan  {
	  echo "6"
  }

function __color_white   {
	  echo "7"
  }

function __color_rgb {
	  r=$1 && g=$2 && b=$3
	    [[ r == g && g == b ]] && echo $(( $r / 11 + 232 )) && return # gray range above 232
	      echo "8;5;$(( ($r * 36  + $b * 6 + $g) / 51 + 16 ))"
      }

function __color {
	  color=$1; shift
	    case "$1" in
		        fg|bg) side="$1"; shift ;;
			    *) side=fg;;
			      esac
			        case "$1" in
					    normal|bright) mode="$1"; shift;;
					        *) mode=normal;;
						  esac
						    [[ $color == "rgb" ]] && rgb="$1 $2 $3"; shift 3

						      next=$1; shift
						        out="$(__$next $@)"
							  echo "$(__color_${mode}_${side} $(__color_${color} $rgb))${out:+;${out}}"
						  }


					  function __black   {
						    echo "$(__color black $@)"
					    }

				    function __red   {
					      echo "$(__color red $@)"
				      }

			      function __green   {
				        echo "$(__color green $@)"
				}

			function __yellow  {
				  echo "$(__color yellow $@)"
			  }

		  function __blue  {
			    echo "$(__color blue $@)"
		    }

	    function __magenta {
		      echo "$(__color magenta $@)"
	      }

      function __cyan  {
	        echo "$(__color cyan $@)"
	}

function __white   {
	  echo "$(__color white $@)"
  }

function __rgb {
	  echo "$(__color rgb $@)"
  }


function __color_parse {
	  next=$1; shift
	    echo "$(__$next $@)"
    }

function color {
	  echo "$(__color_parse make_ansi $@)"
  }

function echo_color {
	  echo "$(__color_parse make_echo $@)"
  }

function scm {
  if [[ "$SCM_CHECK" = false ]]; then
    SCM=$SCM_NONE
  elif [[ -f .git/HEAD ]]; then
    SCM=$SCM_GIT
  elif which git &> /dev/null && [[ -n "$(git rev-parse --is-inside-work-tree 2> /dev/null)" ]]; then
    SCM=$SCM_GIT
  elif [[ -d .hg ]]; then
    SCM=$SCM_HG
  elif which hg &> /dev/null && [[ -n "$(hg root 2> /dev/null)" ]]; then
    SCM=$SCM_HG
  elif [[ -d .svn ]]; then
    SCM=$SCM_SVN
  else
    SCM=$SCM_NONE
  fi
}

function scm_prompt_char {
  if [[ -z $SCM ]]; then
    scm
  fi

  if [[ $SCM == $SCM_GIT ]]; then
    SCM_CHAR=$SCM_GIT_CHAR
  elif [[ $SCM == $SCM_HG ]]; then
    SCM_CHAR=$SCM_HG_CHAR
  elif [[ $SCM == $SCM_SVN ]]; then
    SCM_CHAR=$SCM_SVN_CHAR
  else
    SCM_CHAR=$SCM_NONE_CHAR
  fi
}

function scm_prompt_vars {
  scm
  scm_prompt_char
  SCM_DIRTY=0
  SCM_STATE=''
  [[ $SCM == $SCM_GIT ]] && git_prompt_vars && return
  [[ $SCM == $SCM_HG ]] && hg_prompt_vars && return
  [[ $SCM == $SCM_SVN ]] && svn_prompt_vars && return
}

function scm_prompt_info {
  scm
  scm_prompt_char
  scm_prompt_info_common
}

function scm_prompt_char_info {
  scm_prompt_char
  echo -ne "${SCM_THEME_CHAR_PREFIX}${SCM_CHAR}${SCM_THEME_CHAR_SUFFIX}"
  scm_prompt_info_common
}

function scm_prompt_info_common {
  SCM_DIRTY=0
  SCM_STATE=''
  if [[ ${SCM} == ${SCM_GIT} ]]; then
    if [[ ${SCM_GIT_SHOW_MINIMAL_INFO} == true ]]; then
      # user requests minimal git status information
      git_prompt_minimal_info
    else
      # more detailed git status
      git_prompt_info
    fi
    return
  fi

}

# This is added to address bash shell interpolation vulnerability described
# here: https://github.com/njhartwell/pw3nage
function git_clean_branch {
  local unsafe_ref=$(command git symbolic-ref -q HEAD 2> /dev/null)
  local stripped_ref=${unsafe_ref##refs/heads/}
  local clean_ref=${stripped_ref//[^a-zA-Z0-9\/]/-}
  echo $clean_ref
}

function git_prompt_minimal_info {
  local ref
  local status
  local git_status_flags=('--porcelain')
  SCM_STATE=${SCM_THEME_PROMPT_CLEAN}

  if [[ "$(command git config --get bash-it.hide-status)" != "1" ]]; then
    # Get the branch reference
    ref=$(git_clean_branch) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    SCM_BRANCH=${SCM_THEME_BRANCH_PREFIX}${ref}

    # Get the status
    [[ "${SCM_GIT_IGNORE_UNTRACKED}" = "true" ]] && git_status_flags+='-untracked-files=no'
    status=$(command git status ${git_status_flags} 2> /dev/null | tail -n1)

    if [[ -n ${status} ]]; then
      SCM_DIRTY=1
      SCM_STATE=${SCM_THEME_PROMPT_DIRTY}
    fi

    # Output the git prompt
    SCM_PREFIX=${SCM_THEME_PROMPT_PREFIX}
    SCM_SUFFIX=${SCM_THEME_PROMPT_SUFFIX}
    echo -e "${SCM_PREFIX}${SCM_BRANCH}${SCM_STATE}${SCM_SUFFIX}"
  fi
}

function git_status_summary {
awk '
  BEGIN {
    untracked=0;
    unstaged=0;
    staged=0;
  }
  {
    if (!after_first && $0 ~ /^##.+/) {
      print $0
      seen_header = 1
    } else if ($0 ~ /^\?\? .+/) {
      untracked += 1
    } else {
    if ($0 ~ /^.[^ ] .+/) {
      unstaged += 1
    }
    if ($0 ~ /^[^ ]. .+/) {
      staged += 1
      }
    }
  after_first = 1
  }
  END {
    if (!seen_header) {
      print
    }
  print untracked "\t" unstaged "\t" staged
  }'
}

function git_prompt_vars {
  local details=''
  SCM_STATE=${GIT_THEME_PROMPT_CLEAN:-$SCM_THEME_PROMPT_CLEAN}
  if [[ "$(git config --get bash-it.hide-status)" != "1" ]]; then
    [[ "${SCM_GIT_IGNORE_UNTRACKED}" = "true" ]] && local git_status_flags='-uno'
    local status_lines=$((git status --porcelain ${git_status_flags} -b 2> /dev/null ||
    git status --porcelain ${git_status_flags}    2> /dev/null) | git_status_summary)
    local status=$(awk 'NR==1' <<< "$status_lines")
    local counts=$(awk 'NR==2' <<< "$status_lines")
    IFS=$'\t' read untracked_count unstaged_count staged_count <<< "$counts"
    if [[ "${untracked_count}" -gt 0 || "${unstaged_count}" -gt 0 || "${staged_count}" -gt 0 ]]; then
      SCM_DIRTY=1
      if [[ "${SCM_GIT_SHOW_DETAILS}" = "true" ]]; then
        [[ "${staged_count}" -gt 0 ]] && details+=" ${SCM_GIT_STAGED_CHAR}${staged_count}" && SCM_DIRTY=3
        [[ "${unstaged_count}" -gt 0 ]] && details+=" ${SCM_GIT_UNSTAGED_CHAR}${unstaged_count}" && SCM_DIRTY=2
        [[ "${untracked_count}" -gt 0 ]] && details+=" ${SCM_GIT_UNTRACKED_CHAR}${untracked_count}" && SCM_DIRTY=1
      fi
    SCM_STATE=${GIT_THEME_PROMPT_DIRTY:-$SCM_THEME_PROMPT_DIRTY}
    fi
  fi

  [[ "${SCM_GIT_SHOW_CURRENT_USER}" == "true" ]] && details+="$(git_user_info)"

  SCM_CHANGE=$(git rev-parse --short HEAD 2>/dev/null)

  local ref=$(git_clean_branch)

  if [[ -n "$ref" ]]; then
    SCM_BRANCH="${SCM_THEME_BRANCH_PREFIX}${ref}"
    local tracking_info="$(grep -- "${SCM_BRANCH}\.\.\." <<< "${status}")"
    if [[ -n "${tracking_info}" ]]; then
      [[ "${tracking_info}" =~ .+\[gone\]$ ]] && local branch_gone="true"
      tracking_info=${tracking_info#\#\# ${SCM_BRANCH}...}
      tracking_info=${tracking_info% [*}
      local remote_name=${tracking_info%%/*}
      local remote_branch=${tracking_info#${remote_name}/}
      local remote_info=""
      local num_remotes=$(git remote | wc -l 2> /dev/null)
      [[ "${SCM_BRANCH}" = "${remote_branch}" ]] && local same_branch_name=true
      if ([[ "${SCM_GIT_SHOW_REMOTE_INFO}" = "auto" ]] && [[ "${num_remotes}" -ge 2 ]]) ||
          [[ "${SCM_GIT_SHOW_REMOTE_INFO}" = "true" ]]; then
        remote_info="${remote_name}"
        [[ "${same_branch_name}" != "true" ]] && remote_info+="/${remote_branch}"
      elif [[ ${same_branch_name} != "true" ]]; then
        remote_info="${remote_branch}"
      fi
      if [[ -n "${remote_info}" ]];then
        if [[ "${branch_gone}" = "true" ]]; then
          SCM_BRANCH+="${SCM_THEME_BRANCH_GONE_PREFIX}${remote_info}"
        else
          SCM_BRANCH+="${SCM_THEME_BRANCH_TRACK_PREFIX}${remote_info}"
        fi
      fi
    fi
    SCM_GIT_DETACHED="false"
  else
    local detached_prefix=""
    ref=$(git describe --tags --exact-match 2> /dev/null)
    if [[ -n "$ref" ]]; then
      detached_prefix=${SCM_THEME_TAG_PREFIX}
    else
      ref=$(git describe --contains --all HEAD 2> /dev/null)
      ref=${ref#remotes/}
      [[ -z "$ref" ]] && ref=${SCM_CHANGE}
      detached_prefix=${SCM_THEME_DETACHED_PREFIX}
    fi
    SCM_BRANCH=${detached_prefix}${ref}
    SCM_GIT_DETACHED="true"
  fi

  local ahead_re='.+ahead ([0-9]+).+'
  local behind_re='.+behind ([0-9]+).+'
  [[ "${status}" =~ ${ahead_re} ]] && SCM_BRANCH+=" ${SCM_GIT_AHEAD_CHAR}${BASH_REMATCH[1]}"
  [[ "${status}" =~ ${behind_re} ]] && SCM_BRANCH+=" ${SCM_GIT_BEHIND_CHAR}${BASH_REMATCH[1]}"

  local stash_count="$(git stash list 2> /dev/null | wc -l | tr -d ' ')"
  [[ "${stash_count}" -gt 0 ]] && SCM_BRANCH+=" {${stash_count}}"

  SCM_BRANCH+=${details}

  SCM_PREFIX=${GIT_THEME_PROMPT_PREFIX:-$SCM_THEME_PROMPT_PREFIX}
  SCM_SUFFIX=${GIT_THEME_PROMPT_SUFFIX:-$SCM_THEME_PROMPT_SUFFIX}
}

function svn_prompt_vars {
  if [[ -n $(svn status 2> /dev/null) ]]; then
    SCM_DIRTY=1
    SCM_STATE=${SVN_THEME_PROMPT_DIRTY:-$SCM_THEME_PROMPT_DIRTY}
  else
    SCM_DIRTY=0
    SCM_STATE=${SVN_THEME_PROMPT_CLEAN:-$SCM_THEME_PROMPT_CLEAN}
  fi
  SCM_PREFIX=${SVN_THEME_PROMPT_PREFIX:-$SCM_THEME_PROMPT_PREFIX}
  SCM_SUFFIX=${SVN_THEME_PROMPT_SUFFIX:-$SCM_THEME_PROMPT_SUFFIX}
  SCM_BRANCH=$(svn info 2> /dev/null | awk -F/ '/^URL:/ { for (i=0; i<=NF; i++) { if ($i == "branches" || $i == "tags" ) { print $(i+1); break }; if ($i == "trunk") { print $i; break } } }') || return
  SCM_CHANGE=$(svn info 2> /dev/null | sed -ne 's#^Revision: ##p' )
}

# this functions returns absolute location of .hg directory if one exists
# It starts in the current directory and moves its way up until it hits /.
# If we get to / then no Mercurial repository was found.
# Example:
# - lets say we cd into ~/Projects/Foo/Bar
# - .hg is located in ~/Projects/Foo/.hg
# - get_hg_root starts at ~/Projects/Foo/Bar and sees that there is no .hg directory, so then it goes into ~/Projects/Foo
function get_hg_root {
    local CURRENT_DIR=$(pwd)

    while [ "$CURRENT_DIR" != "/" ]; do
        if [ -d "$CURRENT_DIR/.hg" ]; then
            echo "$CURRENT_DIR/.hg"
            return
        fi

        CURRENT_DIR=$(dirname $CURRENT_DIR)
    done
}

function hg_prompt_vars {
    if [[ -n $(hg status 2> /dev/null) ]]; then
      SCM_DIRTY=1
        SCM_STATE=${HG_THEME_PROMPT_DIRTY:-$SCM_THEME_PROMPT_DIRTY}
    else
      SCM_DIRTY=0
        SCM_STATE=${HG_THEME_PROMPT_CLEAN:-$SCM_THEME_PROMPT_CLEAN}
    fi
    SCM_PREFIX=${HG_THEME_PROMPT_PREFIX:-$SCM_THEME_PROMPT_PREFIX}
    SCM_SUFFIX=${HG_THEME_PROMPT_SUFFIX:-$SCM_THEME_PROMPT_SUFFIX}

    HG_ROOT=$(get_hg_root)

    if [ -f "$HG_ROOT/branch" ]; then
        # Mercurial holds it's current branch in .hg/branch file
        SCM_BRANCH=$(cat "$HG_ROOT/branch")
    else
        SCM_BRANCH=$(hg summary 2> /dev/null | grep branch: | awk '{print $2}')
    fi

    if [ -f "$HG_ROOT/dirstate" ]; then
        # Mercurial holds various information about the working directory in .hg/dirstate file. More on http://mercurial.selenic.com/wiki/DirState
        SCM_CHANGE=$(hexdump -n 10 -e '1/1 "%02x"' "$HG_ROOT/dirstate" | cut -c-12)
    else
        SCM_CHANGE=$(hg summary 2> /dev/null | grep parent: | awk '{print $2}')
    fi
}

function rvm_version_prompt {
  if which rvm &> /dev/null; then
    rvm=$(rvm-prompt) || return
    if [ -n "$rvm" ]; then
      echo -e "$RVM_THEME_PROMPT_PREFIX$rvm$RVM_THEME_PROMPT_SUFFIX"
    fi
  fi
}

function rbenv_version_prompt {
  if which rbenv &> /dev/null; then
    rbenv=$(rbenv version-name) || return
    $(rbenv commands | grep -q gemset) && gemset=$(rbenv gemset active 2> /dev/null) && rbenv="$rbenv@${gemset%% *}"
    if [ $rbenv != "system" ]; then
      echo -e "$RBENV_THEME_PROMPT_PREFIX$rbenv$RBENV_THEME_PROMPT_SUFFIX"
    fi
  fi
}

function rbfu_version_prompt {
  if [[ $RBFU_RUBY_VERSION ]]; then
    echo -e "${RBFU_THEME_PROMPT_PREFIX}${RBFU_RUBY_VERSION}${RBFU_THEME_PROMPT_SUFFIX}"
  fi
}

function chruby_version_prompt {
  if declare -f -F chruby &> /dev/null; then
    if declare -f -F chruby_auto &> /dev/null; then
      chruby_auto
    fi

    ruby_version=$(ruby --version | awk '{print $1, $2;}') || return

    if [[ ! $(chruby | grep '*') ]]; then
      ruby_version="${ruby_version} (system)"
    fi
    echo -e "${CHRUBY_THEME_PROMPT_PREFIX}${ruby_version}${CHRUBY_THEME_PROMPT_SUFFIX}"
  fi
}

function ruby_version_prompt {
  echo -e "$(rbfu_version_prompt)$(rbenv_version_prompt)$(rvm_version_prompt)$(chruby_version_prompt)"
}

function virtualenv_prompt {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    virtualenv=`basename "$VIRTUAL_ENV"`
    echo -e "$VIRTUALENV_THEME_PROMPT_PREFIX$virtualenv$VIRTUALENV_THEME_PROMPT_SUFFIX"
  fi
}

function condaenv_prompt {
  if [[ $CONDA_DEFAULT_ENV ]]; then
    echo -e "${CONDAENV_THEME_PROMPT_PREFIX}${CONDA_DEFAULT_ENV}${CONDAENV_THEME_PROMPT_SUFFIX}"
  fi
}

function py_interp_prompt {
  py_version=$(python --version 2>&1 | awk '{print "py-"$2;}') || return
  echo -e "${PYTHON_THEME_PROMPT_PREFIX}${py_version}${PYTHON_THEME_PROMPT_SUFFIX}"
}

function python_version_prompt {
  echo -e "$(virtualenv_prompt)$(condaenv_prompt)$(py_interp_prompt)"
}

function git_user_info {
  # support two or more initials, set by 'git pair' plugin
  SCM_CURRENT_USER=$(git config user.initials | sed 's% %+%')
  # if `user.initials` weren't set, attempt to extract initials from `user.name`
  [[ -z "${SCM_CURRENT_USER}" ]] && SCM_CURRENT_USER=$(printf "%s" $(for word in $(git config user.name | tr 'A-Z' 'a-z'); do printf "%1.1s" $word; done))
  [[ -n "${SCM_CURRENT_USER}" ]] && printf "%s" "$SCM_THEME_CURRENT_USER_PREFFIX$SCM_CURRENT_USER$SCM_THEME_CURRENT_USER_SUFFIX"
}

function clock_char {
  CLOCK_CHAR=${THEME_CLOCK_CHAR:-"⌚"}
  CLOCK_CHAR_COLOR=${THEME_CLOCK_CHAR_COLOR:-"$normal"}
  SHOW_CLOCK_CHAR=${THEME_SHOW_CLOCK_CHAR:-"true"}

  if [[ "${SHOW_CLOCK_CHAR}" = "true" ]]; then
    echo -e "${CLOCK_CHAR_COLOR}${CLOCK_CHAR_THEME_PROMPT_PREFIX}${CLOCK_CHAR}${CLOCK_CHAR_THEME_PROMPT_SUFFIX}"
  fi
}

function clock_prompt {
  CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$normal"}
  CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%H:%M:%S"}
  [ -z $THEME_SHOW_CLOCK ] && THEME_SHOW_CLOCK=${THEME_CLOCK_CHECK:-"true"}
  SHOW_CLOCK=$THEME_SHOW_CLOCK

  if [[ "${SHOW_CLOCK}" = "true" ]]; then
    CLOCK_STRING=$(date +"${CLOCK_FORMAT}")
    echo -e "${CLOCK_COLOR}${CLOCK_THEME_PROMPT_PREFIX}${CLOCK_STRING}${CLOCK_THEME_PROMPT_SUFFIX}"
  fi
}

function user_host_prompt {
  if [[ "${THEME_SHOW_USER_HOST}" = "true" ]]; then
      echo -e "${USER_HOST_THEME_PROMPT_PREFIX}\u@\h${USER_HOST_THEME_PROMPT_SUFFIX}"
  fi
}

# backwards-compatibility
function git_prompt_info {
  git_prompt_vars
  echo -e "${SCM_PREFIX}${SCM_BRANCH}${SCM_STATE}${SCM_SUFFIX}"
}

function svn_prompt_info {
  svn_prompt_vars
  echo -e "${SCM_PREFIX}${SCM_BRANCH}${SCM_STATE}${SCM_SUFFIX}"
}

function hg_prompt_info() {
  hg_prompt_vars
  echo -e "${SCM_PREFIX}${SCM_BRANCH}:${SCM_CHANGE#*:}${SCM_STATE}${SCM_SUFFIX}"
}

function scm_char {
  scm_prompt_char
  echo -e "${SCM_THEME_CHAR_PREFIX}${SCM_CHAR}${SCM_THEME_CHAR_SUFFIX}"
}

function prompt_char {
    scm_char
}

function battery_char {
    if [[ "${THEME_BATTERY_PERCENTAGE_CHECK}" = true ]]; then
        echo -e "${bold_red}$(battery_percentage)%"
    fi
}

if ! _command_exists 'battery_charge' ; then
    # if user has installed battery plugin, skip this...
    function battery_charge (){
        # no op
        echo -n
    }
fi

# The battery_char function depends on the presence of the battery_percentage function.
# If battery_percentage is not defined, then define battery_char as a no-op.
if ! _command_exists 'battery_percentage' ; then
    function battery_char (){
      # no op
      echo -n
    }
fi

# Returns true if $1 is a shell function.
fn_exists() {
  type $1 | grep -q 'shell function'
}

function safe_append_prompt_command {
    local prompt_re

    # Set OS dependent exact match regular expression
    if [[ ${OSTYPE} == darwin* ]]; then
      # macOS
      prompt_re="[[:<:]]${1}[[:>:]]"
    else
      # Linux, FreeBSD, etc.
      prompt_re="\<${1}\>"
    fi

    # See if we need to use the overriden version
    if [[ $(fn_exists function append_prompt_command_override) ]]; then
       append_prompt_command_override $1
       return
    fi

    if [[ ${PROMPT_COMMAND} =~ ${prompt_re} ]]; then
      return
    elif [[ -z ${PROMPT_COMMAND} ]]; then
      PROMPT_COMMAND="${1}"
    else
      PROMPT_COMMAND="${1};${PROMPT_COMMAND}"
    fi
}
