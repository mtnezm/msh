
# Copy this file into ${MSH_PROFILES}/EXAMPLE_PROFILE/disable.bash
# Change "EXAMPLE_PROFILE" name accordingly

# Profile deactivation method (don't delete this!)
profile_EXAMPLE_PROFILE_off(){
  # Mark your stuff to be disabled once profile becomes inactive, i.e:
  # unset -f myfunct
  # unset myvar
  # unlink /path/to/destination

  # Mark profile as inactive:
  touch ${MSH_PROFILES}/EXAMPLE_PROFILE/.disabled
}
