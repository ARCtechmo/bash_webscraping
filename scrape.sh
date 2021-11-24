#!/bin/bash

##### INCOMPLETE - WORK IN PROGRESS ######
# this is a simple webscraping utility

# create a function to scrape a webpage
function scrape_html_text()
{
  echo "scraping website url: $1" && sleep 2
  local url="$1" # parameter 1 passed to the function is the url
  local html_file="$2" # parameter 2 is the .html file from the scraped website

  # grab the html and pipe the html output to the html2text function
  # curl ${url} | html2text -utf8 > ${html_file} # output in UTF-8 / ASCII
  curl ${url} | html2text -ascii > ${html_file} # output in ASCII
  echo -e "\ndisplaying file type..." && file ${html_file} && file -i ${html_file}
}
# input the url and <filename> into the command line: "scrape.sh" [url] [filename]
# scrape_html_text "${1}" "${2}"

# ensure the output is decoded from UTF8 / ASCII to Unicode string format
function decode_UTF8()
{
  local html_file="$1" # parameter 1 is the .html file from the scraped website
  local html_text_file="$2" # parameter 2 is the .txt file that contains the html string / text

  # get the data type for the downloaded material and assign it to a variable
  # use awk and the file command to grab the second column that contains the data types
  website_format=$(file -i "${1}") # file use  awk; file -i use awk and sed
  echo "${website_format}"

  data_type=$(echo ${website_format} | awk '{print $3}' | awk -F "=" '{print $2}')
  echo "encoding: ${data_type}"

  if [ "${data_type}" == "ASCII" -o "${data_type}" == "ascii" ]; then
    echo "The scraped data type is "${data_type}". No further formatting is necessary"
  elif [ "${data_type}" == "US-ASCII" -o ${data_type} == "us-ascii" ]; then
    echo "The scraped data type is "${data_type}". No further formatting is necessary"

  else
    echo -e "\n-------TEST PRINT OF FALSE CONDITION AND CHARSET: ${data_type}------"
    echo -e "Converting encoding into local charset format...\n"
    sleep 1
    
    # convert the encoding (e.g. utf8) to the local encoding on your machine
    # use an exit status to test the outtput of the 'convert' variable
    convert=$(iconv -f ${data_type}//TRANSLIT -t us-ascii/TRANSLIT ${html_file})
    exit_status=$(echo $?)
  #   if [ ! ${exit_status} -eq 0 ]; then
  #     echo -e "\nuse 'iconv -l' command to ensure the 'data_type' variable is correct\n"
  #   fi
  #
  #   # pipe the final output into a file called html_text.txt.
  #   ${convert} -o ${html_text_file}
  #   echo "displaying file content..."
  #   file ${html_text_file}
  fi
}
# decode_UTF8 "website.html" "test.txt"
decode_UTF8 "webscraping.html" "test.txt"
