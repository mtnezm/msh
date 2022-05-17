#! /usr/bin/env bash

# Load plugins defined in .mshrc
for PLUGIN in ${plugins[@]}; do
  [ -f ${MSH_PLUGINS}/${PLUGIN}.plugin ] && \
  source ${MSH_PLUGINS}/${PLUGIN}.plugin || \
  echo -e "\nWARNING: Plugin \"${PLUGIN}\" is enabled but no matching file was found.\n"
done
