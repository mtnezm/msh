#!/usr/bin/env bash

#
# Multi-profile feature is enabled by default thanks to this
# configuration file. Things should work fine out of the box.
#

#
# Load custom configurations from active profiles
#

for ACTIVE_PROFILE in ${profiles[@]}; do
  [ -f ${MSH_PROFILES}/${ACTIVE_PROFILE}/main.bash ] && \
  source ${MSH_PROFILES}/${ACTIVE_PROFILE}/main.bash
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
# Enable submodule for SSH multi-profile configuration merging
#

source ${MSH_LIB_MODULES}/profiles-ssh-submodule.bash

#
# Unload contents from inactive profiles
#

for INACTIVE_PROFILE in ${inactive_profiles}; do
  [ ! -f ${MSH_PROFILES}/${INACTIVE_PROFILE}/.disabled ] && \
  source ${MSH_PROFILES}/${INACTIVE_PROFILE}/disable.bash
  profile_${INACTIVE_PROFILE}_off
done

unset inactive_profiles
