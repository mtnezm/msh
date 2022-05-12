#!/usr/bin/env bash

MSH="~/.msh"
MSH_TEMPLATES="~/.msh/tools/templates"
MSH_PROFILES="~/.msh/include/profiles"

function install_msh() {
  cd $(dirname "$0")                              # Load MSH environment variables

  if [ -d ${MSH} ]; then                          # Check for previous MSH installations
    echo -e "\n WARNING: MSH installation path already exists. To re-install it, please uninstall first.\n"
    exit 1
  fi

  mv ${PWD%/*} ${MSH}                             # Relocate MSH rootdir

  cp -f ${MSH_TEMPLATES}/mshrc ${HOME}/.mshrc     # Install new .mshrc file
  echo "source ~/.mshrc" >> ~/.bashrc             # Enable MSH

  # Enable an empty example profile by default
  cp -r ${MSH_TEMPLATES}/example-profile ${MSH_PROFILES}/default
  sed -i "s/EXAMPLE_PROFILE/default/g" ${MSH_PROFILES}/default/*.bash

  cd ${HOME} # Get back to $HOME directory
}

#
# Ask for manual confirmation before proceeding
#

echo -e "\n You are about to install MSH on your system!\n"
read -n 1 -p " Proceed? (y/n): " CONFIRMATION

case ${CONFIRMATION} in

  y)  echo -e "\n\n OK! Installing MSH...\n"
      install_msh && (echo -e "\n MSH has been successfully installed. Please restart your terminal or run 'source ~/.bashrc' to start using it.\n" ; exit 0) \
      || (echo -e "\n Something went wrong, could not install MSH.\n" ; exit 1)
  ;;

  n)  echo -e "\n\n MSH was not installed. Exiting.\n"
      exit 0
  ;;

  *)  echo -e "\n\n Invalid option. Please use 'y' or 'n'.\n"
      exit 1
  ;;

esac
