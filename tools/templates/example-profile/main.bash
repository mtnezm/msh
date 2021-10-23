#! /usr/bin/env bash

# Copy this file into ${MSH_PROFILES}/EXAMPLE_PROFILE/main.bash
# Change EXAMPLE_PROFILE name accordingly

# Mark profile as active (don't delete this!)
if [ -f ${MSH_PROFILES}/EXAMPLE_PROFILE/.disabled ]; then
  rm ${MSH_PROFILES}/EXAMPLE_PROFILE/.disabled
fi

#
# Do your things here, i.e.:
#
# myfunct(){
# something to do
# }
#
# myvar=foo
#
# ln -s /path/to/some_file /path/to/destination
#
