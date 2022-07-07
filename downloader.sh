#!/bin/bash
# This is a simple script to download content from the web

# verify installation of xclip
function install_xclip(){
  echo "-----------TEST: install_xclip(){} func---------------"
  echo "checking to see if xclip is installed..."
  sleep 2
  apt=$(sudo apt-cache policy $1 | awk '/none/ {print $2}')
  if [ "${apt}" == '(none)' ]; then
    echo "$1 is not installed"
    read -p "Would you like to install $1? (Y/N) " ans

    case "${ans}" in
      "Y" | "y" | "Yes" | "YES" | "yes")
      echo "------------TEST: YES-------------------"
      echo "installing $1...."
      sleep 2
      INSTALL=$(sudo apt install $1)
      echo ${INSTALL}
      ;;

      "N" | "n" | "No" | "NO" | "no")
      echo "You need to install $1 to continue."
      echo "exiting..."
      sleep 2
      exit
      ;;

      *)
      echo "------------TEST: invalid input---------------"
      echo "exiting..."
      sleep 2
      exit
      ;;
    esac
  else
    install_path=$(which $1)
    echo "$1 is installed in: ${install_path}"

  fi
}
# install_xclip 'xclip'

# verify installation of lynx
function install_lynx(){
  echo "-----------TEST: install_lynx(){} func---------------"
  echo "checking to see if lynx is installed..."
  sleep 2
  apt=$(sudo apt-cache policy $1 | awk '/none/ {print $2}')
  if [ ${apt} == '(none)' ]; then
    echo "$1 is not installed."
    read -p "Would you like to install $1? (Y/N) " ans

    case "${ans}" in
      "Y" | "y" | "Yes" | "YES" | "yes")
      echo "------------TEST: YES-------------------"
      echo "installing $1...."
      sleep 2
      INSTALL=$(sudo apt install $1)
      echo ${INSTALL}
      ;;

      "N" | "n" | "No" | "NO" | "no")
      echo "You need to install $1 to continue."
      echo "exiting..."
      sleep 2
      exit
      ;;

      *)
      echo "------------TEST: invalid input---------------"
      echo "exiting..."
      sleep 2
      exit
      ;;
    esac

  else
    install_path=$(which $1)
    echo "$1 is installed in: ${install_path}"
  fi
}
install_lynx 'lynx'
