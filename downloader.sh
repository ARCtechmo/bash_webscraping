#!/bin/bash
# This is a simple script to download content from the web

# verify installation of xclip and lynx
function install_xclip_lynx(){
  echo "checking to see if xclip and lynx are installed..."
  sleep 2
  apt=$(sudo apt-cache policy $1 | awk '/none/ {print $2}')
  if [ "${apt}" == '(none)' ]; then
    echo "yes"
  else
    echo "no"
  fi
}
install_xclip_lynx 'xclip'
