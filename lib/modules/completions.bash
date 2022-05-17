#! /usr/bin/env bash

# Load completions defined in .mshrc
for COMPLETION in ${completions[@]}; do
  [ -f ${MSH_COMPLETIONS}/${COMPLETION}.completion ] && \
  source ${MSH_COMPLETIONS}/${COMPLETION}.completion || \
  echo -e "\nWARNING: Completion \"${COMPLETION}\" is enabled but no matching file was found.\n"
done
