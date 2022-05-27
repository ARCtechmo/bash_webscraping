#! /bin/bash

### UNDER DEVELOPMENT ###
# ensure the output is decoded from UTF8 / ASCII to Unicode string format
function decode_UTF8()
{
  local html_file="$1" # parameter 1 is the .html file from the scraped website
  local html_text_file="$2" # parameter 2 is the .txt file that contains the html string / text

  # get the data type for the downloaded material and assign it to a variable
  # use awk and the file command to grab the second column that contains the data types
  website_format=$(file -i "${1}") # file use  awk; file -i use awk and sed
  echo "${website_format}"

  from_encoding=$(echo ${website_format} | awk '{print $3}' | awk -F "=" '{print $2}')
  echo "encoding: ${from_encoding}"

  if [ "${from_encoding}" == "ASCII" -o "${from_encoding}" == "ascii" ]; then
    echo "The scraped data type is "${from_encoding}". No further formatting is necessary"

  # elif [ "${from_encoding}" == "US-ASCII" -o "${from_encoding}" == "us-ascii" ]; then
  #   echo "The scraped data type is "${from_encoding}". No further formatting is necessary"

  else
    echo -e "Converting encoding into local charset format...\n"
    sleep 1

    ### BUG TO FIX ###
    # error: 'iconv: conversion from `binary//TRANSLIT' is not supported'
    # convert the encoding (e.g. utf8) to the local encoding on your machine
    # I still get the binary error even when I create a .txt file
    convert=$(iconv -f ${from_encoding}//TRANSLIT -t US-ASCII//TRANSLIT -o ${html_file} ${html_text_file})
    exit_status=$(echo $?)
    if [ ! ${exit_status} -eq 0 ]; then
      echo -e "\nuse 'iconv -l' command to ensure the 'data_type' variable is correct\n"

    # pipe the final output into a file called html_text.txt.
    else
      echo "displaying ${html_text_file} file encoding..."
      sleep 1
      file -i ${html_text_file}
    fi
  fi
}
# input in the command line: "scrape.sh" [filename with dowloaded data] [filename with converted data]
decode_UTF8 "${1}" "${2}"
