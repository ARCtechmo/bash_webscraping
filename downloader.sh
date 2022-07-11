#!/bin/bash
# This is a simple script to download content from the web

# VERBOSE=true displays warning and error messages
# VERBOSE=false will not display the messages
VERBOSE=true

# warning messages
function warn(){
  if ${VERBOSE}; then
    echo "WARNING: ${1}"
  fi
}

# error messages
function err(){

  if ${VERBOSE}; then
    echo "ERROR: ${1}"
  fi
}

# create a variable for the Downloads Directory
download_directory=~/Downloads
echo "${download_directory}"

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
  if [ "${apt}" == '(none)' ]; then
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
# install_lynx 'lynx'

# assign filetypes and concatenate to compile more filetypes
function filetypes(){
  echo "listing the file types..."
  sleep 2
  filetypes=(jpg jpeg png tiff gif bmp swf svg)
  filetypes+=(mp4 mp3 mpg mpeg vob m2p ts mov avi wmf asf mkv webm 3pg flv)
  filetypes+=(gzip zip tar gz tar.gz 7zip)
  filetypes+=(pdf doc xlsx odt ods epub txt mobi azw azw3)
  filetypes+=(iso dmg exe deb rpm)
  filetypes+=(java kt py sh zsh)

  # print all the filetypes
  # echo "${filetypes}"

  for f in "${filetypes[@]}";
  do
    echo "${f}"
  done
  echo && echo "checking available space..."
  sleep 2
  # check available space
  free=$(df . | awk 'NR == 2{print $5}')
  echo "${free}"
}
# filetypes
