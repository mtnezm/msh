#!/usr/bin/env bash

#
# Multi-profile feature is enabled by default thanks to this
# configuration file. Things should work fine out of the box.
#

#
# Wipe default SSH config file on each session to load only active profiles' settings
#

if [ $(ls ${MSH_PROFILES} |wc -l) -gt 0 ]; then
  if [ -f ${HOME}/.ssh/config ]; then
    >| ${HOME}/.ssh/config
  fi
else
  echo -e "\n Warning: no profiles found!\n"
  return 1
fi

#
# Avoid duplicate SSH agent processes after each reload() usage
#

pkill ssh-agent

#
# Load custom configurations from active profiles
#

for ACTIVE_PROFILE in ${profiles[@]}; do
  if [ -f ${MSH_PROFILES}/${ACTIVE_PROFILE}/main.bash ]; then
    source ${MSH_PROFILES}/${ACTIVE_PROFILE}/main.bash
  fi

  # Add custom SSH settings, if present, to the default SSH config file
  if [ -f ${MSH_PROFILES}/${ACTIVE_PROFILE}/ssh/config ]; then
    cat ${MSH_PROFILES}/${ACTIVE_PROFILE}/ssh/config >> ${HOME}/.ssh/config
  fi
done

#
# Ensure inactive profiles are disabled properly
#

for PROFILE in $(find ${MSH_PROFILES} -maxdepth 1 -mindepth 1 -not -type f -not -name ".gitkeep" -printf '%f\n'); do
  if ! [[ "${profiles[@]}" =~ "${PROFILE}" ]]; then
    inactive_profiles+=" ${PROFILE}"
  fi
  # Avoid duplicate values in array after issuing reload() multiple times
  inactive_profiles=$(echo ${inactive_profiles} | awk '{for (i=1;i<=NF;i++) if (!a[$i]++) printf("%s%s",$i,FS)}{printf("\n")}')
done

#
# Unload contents from inactive profiles
#

for INACTIVE_PROFILE in ${inactive_profiles}; do
  if [ ! -f ${MSH_PROFILES}/${INACTIVE_PROFILE}/.disabled ]; then
    source ${MSH_PROFILES}/${INACTIVE_PROFILE}/disable.bash
    profile_${INACTIVE_PROFILE}_off
  fi
done

unset inactive_profiles
