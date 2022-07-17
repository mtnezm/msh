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
# Enable SSH multi-profile configuration merging
#

[ -f ${HOME}/.ssh/config ] && >| ${HOME}/.ssh/config

pkill ssh-agent       # Avoid duplicate SSH agent processes after each reload() usage

# Add custom SSH settings, if present, to the default SSH config file
for ACTIVE_PROFILE in ${profiles[@]}; do
  [ -f ${MSH_PROFILES}/${ACTIVE_PROFILE}/ssh/config ] && \
  cat ${MSH_PROFILES}/${ACTIVE_PROFILE}/ssh/config >> ${HOME}/.ssh/config
done


#
# Enable GIT multi-profile configuration merging
#

[ -f ${HOME}/.config/git/config ] && >| ${HOME}/.config/git/config

# Enable default GIT settings

cat ${MSH_PROFILES}/default/files/gitconfig-default >> ${HOME}/.config/git/config

# Enable GIT conditional settings feature
for ACTIVE_PROFILE in ${profiles[@]}; do
  [ -f ${MSH_PROFILES}/${ACTIVE_PROFILE}/files/gitconfig ] && \
  echo -e "[includeIf \"gitdir:$(head -1 ${MSH_PROFILES}/${ACTIVE_PROFILE}/files/gitconfig | awk -F':' '{ print $2}')\"]\npath = ${MSH_PROFILES}/${ACTIVE_PROFILE}/files/gitconfig\n" >> ${HOME}/.config/git/config
done


#
# Unload contents from inactive profiles
#

for INACTIVE_PROFILE in ${inactive_profiles}; do
  [ ! -f ${MSH_PROFILES}/${INACTIVE_PROFILE}/.disabled ] && \
  source ${MSH_PROFILES}/${INACTIVE_PROFILE}/disable.bash
  profile_${INACTIVE_PROFILE}_off
done

unset inactive_profiles
