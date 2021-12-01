#!/bin/bash

##### INCOMPLETE - WORK IN PROGRESS ######
# this is a simple webscraping utility

# get user input to name the url
echo "This is simple webscraping utility."
echo "The filepath for this script: $0"
read -p "Enter the url: " url

# options to direct the web content to an existing file or create the file
### continue work on this section ####
echo -e "\nNext, pass the web content to an existing file or create a new file."
read -p "Type [1] for an existing file or type [2] to create a new file: " choice
case ${choice} in
  1)
    echo -e "\n------test CASE condition 1--------\n"
    echo -e "You chose to pass the web content to an existing file."
    read -p "Enter the name of the file to direct the web content: " filename
    if [ -f "${filename}" -o -f "${filename}.txt" -o -f "$filename.html" ]; then
      echo "The file "${filename}" is in the directory."
    else
      echo "The file ${filename} is not in the directory."
    fi
    ;;

  2)
    echo -e "\n------test CASE condition 2--------\n"
    echo -e "You chose to create a new file."
    read -p "Give the file an extension (csv,html,json,txt,xml): " ext
    if [ "${ext}" == ".csv" -o "${ext}" == "csv" ]; then
      echo -e "\n------test .txt extention type--------\n"
    elif [ "${ext}" == ".html" -o "${ext}" == "html" ]; then
      echo -e "\n------test .html extention type--------\n"
    elif [ "${ext}" == ".json" -o "${ext}" == "json" ]; then
      echo -e "\n------test .json extention type--------\n"
    elif [ "${ext}" == ".txt" -o "${ext}" == "txt" ]; then
      echo -e "\n------test .txt extention type--------\n"
    elif [ "${ext}" == ".xml" -o "${ext}" == "xml" ]; then
      echo -e "\n------test .xml extention type--------\n"
    else
      echo "Invalid format. Use lowercase only."
      exit
    fi
    #### START HERE NEXT####
    # finish tetting the if statements and extenstions
    # finish the "case" section
    # format the file extension
    if [ "${ext}" != ".csv" -o "${ext}" != ".html" -o "${ext}" != ".json" -o "${ext}" != ".txt" -o "${ext}" != ".xml" ]; then
      echo "-------test to change the extention------------"
      formatted_ext=".${ext}"
      echo "The file extention is ${formatted_ext}."
      read -p "Enter the name of the file to direct the web content: " filename
      echo "The filename: ${filename}${formatted_ext}"

    else
      echo "The file extention is ${ext}."
      read -p "Enter the name of the file to direct the web content: " filename
      echo "The filename: ${filename}${ext}"

    fi
    echo -e "creating the file in the current working directory..."
    sleep 1
    # touch ./"${filename}${ext}"

    ;;
  *)
    echo "You made no choice."
    ;;

  esac

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
# decode_UTF8 "${1}" "${2}"
