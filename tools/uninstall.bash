#!/usr/bin/env bash

function uninstall_msh() {
  cd $(dirname "$0")                            # Start from script's location, just in case
  rm -f "${HOME}/.mshrc"                        # Delete ~/.mshrc file
  rm -rf "${PWD%/*}"                            # Delete entire MSH rootdir
  cd "${HOME}"                                  # Return to ${HOME} directory
}

# Ask for manual confirmation before proceeding
echo -e "\n Careful! You are about to uninstall MSH from your system!\n"
read -n 1 -p " Are you sure? (y/n): " CONFIRMATION

case ${CONFIRMATION} in
  y)  echo -e "\n\n OK. Removing MSH...\n"
      uninstall_msh && (echo -e "\n MSH has been successfully uninstalled. Please restart your terminal session to finish applying changes.\n" ; exit 0) \
      || (echo -e "\n Something went wrong. Please remove MSH files manually.\n" ; exit 1)
  ;;
  n)  echo -e "\n\n MSH was not removed. Exiting.\n"
      exit 0
  ;;
  *)  echo -e "\n\n Invalid option. Please use 'y' or 'n'.\n"
      exit 1
  ;;
esac
