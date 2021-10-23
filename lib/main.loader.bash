#!/usr/bin/env bash

#
# Inject active aliases into our shell
#

for ALIAS in ${aliases[@]}; do
  if [ -f ${MSH_ALIASES}/${ALIAS}.alias ]; then
    source ${MSH_ALIASES}/${ALIAS}.alias
  else
    echo -e "\nWARNING: Alias \"${ALIAS}\" is enabled but no matching file was found.\n"
  fi
done

#
# Inject active completions into our shell
#

for COMPLETION in ${completions[@]}; do
  if [ -f ${MSH_COMPLETIONS}/${COMPLETION}.completion ]; then
    source ${MSH_COMPLETIONS}/${COMPLETION}.completion
  else
    echo -e "\nWARNING: Completion \"${COMPLETION}\" is enabled but no matching file was found.\n"
  fi
done

#
# Inject active plugins into our shell
#

for PLUGIN in ${plugins[@]}; do
  if [ -f ${MSH_PLUGINS}/${PLUGIN}.plugin ]; then
    source ${MSH_PLUGINS}/${PLUGIN}.plugin
  else
    echo -e "\nWARNING: Plugin \"${PLUGIN}\" is enabled but no matching file was found.\n"
  fi
done

#
# Load the defined shell theme
#

if [ ${MSH_THEME} ]; then
  source "${MSH_THEMES}/${MSH_THEME}/${MSH_THEME}.theme.sh"
fi
