#! /usr/bin/env bash

# Load aliases defined in .mshrc
for ALIAS in ${aliases[@]}; do
  [ -f ${MSH_ALIASES}/${ALIAS}.alias ] && \
  source ${MSH_ALIASES}/${ALIAS}.alias || \
  echo -e "\nWARNING: Alias \"${ALIAS}\" is enabled but no matching file was found.\n"
done

