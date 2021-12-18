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
read -p "Type [1] for an existing file or [2] to create a new file: " choice
case ${choice} in
  1)
    echo -e "You chose to pass the web content to an existing file.\n"
    read -p "Enter the filename: " filename
    echo -e "----------test print filename: ${filename}-------------------\n"

    # if the user enters a filename with an extension
    if [[ "${filename}" =~ (^[a-zA-Z0-9\_\-]+)([\.]+)([a-z0-9]+) ]]; then
      #  remove .ext if the user types filename.ext with an extension
      filename=$(echo "${filename}" | awk -F "." '{print $1}')
      echo -e "------------test regexp filename with ext match: ${filename}-------------"
      ext=${BASH_REMATCH[3]}
      echo -e "------------test regexp file ext: ${ext}-----------------------"

    ### START HERE NEXT ###
    # I restructred the code so modifications are necessary #
    # Basically, this is what I want:
    #   when the user enters a filename without an extension...
    #   then ask the user is there an extension, if yes then add the extension
    #   if the filename.ext exists and is empty then download; if not prompt
    #   to overwrite the file; if the filename has not extension do the same thing
    # if the user enters a filename without an extension
    elif [[  "${filename}" =~ (^[a-zA-Z0-9\_\-]+) ]]; then
      echo -e "Does the file have an extension?: (Y/N)" ans1
      if [ "${ans1}" == "Y" -o "${ans1}" == "y" -o \
        "${ans1}" == "Yes" -o "${ans1}" == "yes"  ]; then
          read -p "Enter file type (.csv,.html,.jpeg,.json,.txt,.xls,.xml,etc...): " ext
          echo -e "------------------test print extension: ${ext}-------------------\n"

          # user must enter .ext or ext; all other entries will exit the program
          if [[ ${ext} =~ (^\.)([a-z0-9]+) ]]; then
            ext=${BASH_REMATCH[2]}
            echo -e "------------------test regexp BASH_REMATCH[2]------------------"
            echo -e "-----------------extension test: ${ext}-----------------------\n"
          elif [[ ${ext} =~ (^[a-z0-9]+) ]]; then
            ext=${BASH_REMATCH[1]}
            echo -e "------------------test regexp BASH_REMATCH[1]------------------"
            echo -e "-----------------extension test: ${ext}-----------------------\n"
          else
            echo -e "\n------------test regexp nomatch------------------"
            echo -e "incorrect extension type...exiting program"
            exit
          fi




          # check if the file is NOT empty
          if [ -s "${filename}" ]; then
            echo "The file has existing content."
            read -p "Overwrite existing content?: (y/n): " ans2
            if [ "${ans2}" == "Y" -o "${ans2}" == "y" -o \
              "${ans2}" == "Yes" -o "${ans2}" == "yes"  ]; then
              echo -e "dowloading content...\n"
              sleep 1

              # pass the url and filename to the function
              scrape_html_text "${url}" "${filename}"

            else
              echo -e "cancelling download....."
              echo -e "exiting program..."
              exit
            fi

          # check if the file is empty
          elif [ ! -s  "${filename}" ]; then
            echo -e "The file is empty."
            echo -e "dowloading content...\n"
            sleep 1

            # pass the url and filename to the function
            scrape_html_text "${url}" "${filename}"



    else
      # exit if user does not enter a filename or ext
      echo -e "------------regexp filename ext non-match-------------"
      echo -e "incorrect filename and / or extension"
      echo -e "exiting the program..."
      exit
    fi
    echo -e "\n--------------test for correct filename and extension------------"
    echo -e "--------------filename: ${filename}------------------------------"
    echo -e "--------------extension: ${ext}----------------------------------"

    # check if there are two files with the same name but different extensions
    if [ -f "${filename}.${ext}" -a -f "${filename}" ]; then
      echo -e "There is more than one file with the same name.\n"
      read -p "Send output to "${filename}.${ext}" or ${filename}?: " ans1

      # user chooses filename.ext
      if [ "${ans1}" ==  "${filename}.${ext}" ]; then
        read -p "Confirm redirect content to "${filename}.${ext}" (y/n): " ans2
        if [ "${ans2}" == "Y" -o "${ans2}" == "y" -o \
          "${ans2}" == "Yes" -o "${ans2}" == "yes"  ]; then
          echo -e "dowloading content...\n"
          sleep 1

          # pass the url and filename to the function
          scrape_html_text "${url}" "${filename}.${ext}"
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

      # user does not make a selection
      else
        echo -e "User did not select a file"
        echo -e "exiting the program...."

      fi

    ### Moidify  section ##
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
        echo -e "\n"${filename}.${ext}" is not in the directory."
        echo -e "...exiting the program"
        exit
      fi

    # exit program if user input does not match an existing file in the directory
    else
      echo -e "\nThe file "${filename}" is not in the directory."
    fi
    exit
    ;;

  2)
    echo -e "You chose to create a new file."
    read -p "Enter file type (.csv,.html,.jpeg,.json,.txt,.xls,.xml,etc...): " ext
    if [ "${ext}" == "csv" -o "${ext}" == "html" -o "${ext}" == "json"\
         -o "${ext}" == "txt" -o "${ext}" == "xml" ]; then

### test with new ext fixed bug fix - text for double extensions in the output .ext.ext ###
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
