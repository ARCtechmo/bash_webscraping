#!/bin/bash

##### INCOMPLETE - WORK IN PROGRESS ######
# this is a simple webscraping utility

#### START HERE NEXT####
# get user input to grab content with the url and direct the input to files

echo "This is simple webscraping utility"
read -p "Enter the url:" url
read -p "Enter the name of the file to direct the scraped content: " filename
# this is where you will insert the scrape_html_text() function

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
scrape_html_text "${1}" "${2}"

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

  elif [ "${from_encoding}" == "US-ASCII" -o ${from_encoding} == "us-ascii" ]; then
    echo "The scraped data type is "${from_encoding}". No further formatting is necessary"

  else
    echo -e "Converting encoding into local charset format...\n"
    sleep 1

    # convert the encoding (e.g. utf8) to the local encoding on your machine
    convert=$(iconv -f ${from_encoding}//TRANSLIT -t US-ASCII//TRANSLIT ${html_file} -o ${html_text_file})
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
# input the url and <filename> into the command line: "scrape.sh" [url] [filename]
decode_UTF8 "${1}" "${2}"
