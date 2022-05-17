#! /usr/bin/env bash

#
# Wipe default SSH config file on each session to load only active profiles' settings
#

if [ $(ls ${MSH_PROFILES} |wc -l) -gt 1 ]; then
  [ -d ${HOME}/.ssh ] && [ -f ${HOME}/.ssh/config ] && >| ${HOME}/.ssh/config
fi

#
# Avoid duplicate SSH agent processes after each reload() usage
#

pkill ssh-agent

# Add custom SSH settings, if present, to the default SSH config file
for ACTIVE_PROFILE in ${profiles[@]}; do
  [ -f ${MSH_PROFILES}/${ACTIVE_PROFILE}/ssh/config ] && \
  cat ${MSH_PROFILES}/${ACTIVE_PROFILE}/ssh/config >> ${HOME}/.ssh/config
done
