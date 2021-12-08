#!/bin/bash

##### INCOMPLETE - WORK IN PROGRESS ######
# this is a simple webscraping utility

# get user input to name the url
echo "This is simple webscraping utility."
echo "The filepath for this script: $0"
read -p "Enter the url: " url

# a function to scrape a webpage
function scrape_html_text()
{
  echo "scraping url content: $1" && sleep 2
  local url="$1" # parameter 1 passed to the function is the url
  local html_file="$2" # parameter 2 is the .html file from the scraped website

  # grab the html and pipe the html output to the html2text function
  # curl ${url} | html2text -utf8 > ${html_file} # output in UTF-8 / ASCII
  curl ${url} | html2text -ascii > ${html_file} # output in ASCII
  echo -e "\ndisplaying file type..." && file ${html_file} && file -i ${html_file}
}

# options to direct the web content to an existing file or create the file
echo -e "\nNext, pass the web content to an existing file or create a new file."
read -p "Type [1] for an existing file or type [2] to create a new file: " choice
case ${choice} in
  1)
    echo -e "You chose to pass the web content to an existing file.\n"
    read -p "Enter the filename: " filename

    #  removes .ext if the user types filename.ext with an extension
    filename=$(echo "${filename}" | awk -F "." '{print $1}')

    ### START HERE NEXT ###
    ### BUG TO FIX ###
    # if the user does not enter an ext (just hits return) there will be...
    # two files that are exactly the same when prompted to direct the output
    read -p "Enter file type (.csv,.html,.jpeg,.json,.txt,.xls,.xml,etc...): " ext


    # check if there are two files with the same name but different extensions
    if [ -f "${filename}${ext}" -a -f "${filename}" ]; then
      echo -e "There is more than one file with the same name.\n"
      read -p "Send output to "${filename}${ext}" or ${filename}?: " ans1

      # user chooses filename.ext
      if [ "${ans1}" ==  "${filename}${ext}" ]; then
        read -p "Confirm redirect content to "${filename}${ext}" (y/n): " ans2
        if [ "${ans2}" == "Y" -o "${ans2}" == "y" -o \
          "${ans2}" == "Yes" -o "${ans2}" == "yes"  ]; then
          echo -e "dowloading content...\n"
          sleep 1

          # pass the url and filename to the function
          scrape_html_text "${url}" "${filename}${ext}"
        else
          echo -e "\nexiting the program...."
          exit
        fi

      # user chooses filename (no extension)
      elif [ "${ans1}" ==  "${filename}" ]; then
        read -p "Confirm redirect content to "${filename}" (y/n): " ans2
        if [ "${ans2}" == "Y" -o "${ans2}" == "y" -o \
          "${ans2}" == "Yes" -o "${ans2}" == "yes"  ]; then
          echo -e "dowloading content...\n"
          sleep 1

          # pass the url and filename to the function
          scrape_html_text "${url}" "${filename}"
        else
          echo -e "\nexiting the program...."
          exit
        fi
      fi

    # check if there is only one existing file that matches the user input
    # prompt user to ensure they want to overwrite existing content
    elif [ -f "${filename}" ]; then
      count_lines_in_file=$(wc -l ${filename} | awk '{print $1}')
      if [ ${count_lines_in_file} -gt 0 ]; then
        echo "The file has existing content."
        read -p "Overwrite existing content?: (y/n): " ans3
        if [ "${ans3}" == "Y" -o "${ans3}" == "y" -o \
          "${ans3}" == "Yes" -o "${ans3}" == "yes"  ]; then
          echo -e "dowloading content...\n"
          sleep 1

          # pass the url and filename to the function
          scrape_html_text "${url}" "${filename}"
        fi

      else
        echo -e "\n${filename}${ext} is not in the directory."
        echo -e "...exiting the program"
        exit
      fi

    # exit program if user input does not match an existing file in the directory
    else
      echo -e "\nThe file ${filename} is not in the directory."
    fi
    exit
    ;;

  2)
    echo -e "You chose to create a new file."
    read -p "Enter file type (.csv,.html,.jpeg,.json,.txt,.xls,.xml,etc...): " ext
    if [ "${ext}" == "csv" -o "${ext}" == "html" -o "${ext}" == "json"\
         -o "${ext}" == "txt" -o "${ext}" == "xml" ]; then
### bug fix - text for double extensions in the output .ext.ext ###
      formatted_ext=".${ext}"
      echo "The file extension is ${formatted_ext}"
      read -p "Enter the name of the file to direct the web content: " filename
      echo "The filename: ${filename}${formatted_ext}"
      echo -e "creating the file in the current working directory..."
      sleep 1 && touch "${filename}${formatted_ext}"
      echo -e "\nDownlading and redirecting content to "${filename}"..."
      sleep 1

      # pass the url and filename to the function
      scrape_html_text "${url}" "${filename}"

### bug fix - text for double extensions in the output .ext.ext ###

    elif [ "${ext}" == ".csv" -o "${ext}" == ".html" -o "${ext}" == ".json"\
         -o "${ext}" == ".txt" -o "${ext}" == ".xml" ]; then

      echo "The file extension is ${ext}"
      read -p "Enter the name of the file to direct the web content: " filename
      echo "The filename: ${filename}${ext}"
      echo -e "creating the file in the current working directory..."
      sleep 1 && touch ./"${filename}${ext}"
      echo -e "\nDownloading and redirecting content to "${filename}
      # pass the url and filename to the function
      scrape_html_text "${url}" "${filename}"

    else
        echo "Invalid format. Use lowercase only."
        exit

    fi
    ;;

  *)
    echo "You made no choice."
    exit
    ;;

  esac

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
