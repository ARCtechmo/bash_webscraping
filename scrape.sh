#!/bin/bash
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


    # if the user enters a filename without an extension
    if [[  "${filename}" =~ (^[a-zA-Z0-9\_\-]+) ]]; then
      read -p "Does the file have an extension?: (Y/N) " ans1

      # ask user for an extension and answer is "yes"
      if [ "${ans1}" == "Y" -o "${ans1}" == "y" -o \
        "${ans1}" == "Yes" -o "${ans1}" == "yes"  ]; then
          read -p "Enter file type (.csv,.html,.jpeg,.json,.txt,.xls,.xml,etc...): " ext
          echo -e "------------------test print extension: ${ext}-------------------\n"

          # user must enter .ext or ext; all other entries will exit the program
          if [[ ${ext} =~ (^\.)([a-z0-9]+) ]]; then
            ext=${BASH_REMATCH[2]}
            echo -e "------------------test regexp ${BASH_REMATCH[2]}------------------"
            echo -e "-----------------extension test: ${ext}-----------------------\n"
          elif [[ ${ext} =~ (^[a-z0-9]+) ]]; then
            ext=${BASH_REMATCH[1]}
            echo -e "------------------test regexp ${BASH_REMATCH[1]}------------------"
            echo -e "-----------------extension test: ${ext}-----------------------\n"
          else
            echo -e "\n------------test regexp nomatch------------------"
            echo -e "incorrect extension type...exiting program"
            exit
          fi

      # ask user for an extension and answer is "no"
      elif [ "${ans1}" == "N" -o "${ans1}" == "n" -o \
            "${ans1}" == "No" -o "${ans1}" == "no"  ]; then
              echo -e "The filename is: ${filename}."

      # user enters incorrect input so the program exits
      else
        echo -e "You did not enter 'yes' or 'no' or incorrect input."
        echo -e "exiting the program..."
        exit

      fi

    # the purpose of this section of if-elif statements is to get the filename and ext
    # if the user enters a filename with an extension
    elif [[ "${filename}" =~ (^[a-zA-Z0-9\_\-]+)([\.]+)([a-z0-9]+) ]]; then
      #  remove .ext if the user types filename.ext with an extension
      filename=$(echo "${filename}" | awk -F "." '{print $1}')
      echo -e "------------test regexp filename with ext match: ${filename}-------------"
      ext=${BASH_REMATCH[3]}
      echo -e "------------test regexp file ext: ${ext}-----------------------"

    # exit if user does not enter a filename or extension
    else
      echo -e "------------regexp filename ext non-match-------------"
      echo -e "incorrect filename and / or extension"
      echo -e "exiting the program..."
      exit

    fi

    # at this point the user has input a filename with or without an extension
    # The user has typed filename.ext or typed filename
    # test for correct filename and extension
    echo -e "\n--------------test for correct filename and extension------------"
    echo -e "--------------filename: ${filename}------------------------------"
    echo -e "--------------extension: ${ext}----------------------------------"

    # check if there are two files with the same name but different extensions
    if [ -f "${filename}.${ext}" -a -f "${filename}" ]; then
      echo -e "There is more than one file with the same name.\n"
      read -p "Send output to "${filename}.${ext}" or ${filename}?: " ans2

      # user chooses to direct content to filename.ext
      if [ "${ans2}" ==  "${filename}.${ext}" ]; then
        read -p "Confirm redirect content to "${filename}.${ext}" (Y/N): " ans3

        if [ "${ans3}" == "Y" -o "${ans3}" == "y" -o \
          "${ans3}" == "Yes" -o "${ans3}" == "yes"  ]; then

            # check if the file is NOT empty
            if [ -s "${filename}.${ext}" ]; then
              echo "The file has existing content."
              read -p "Overwrite existing content?: (Y/N): " ans4
              if [ "${ans4}" == "Y" -o "${ans4}" == "y" -o \
                "${ans4}" == "Yes" -o "${ans4}" == "yes"  ]; then
                echo -e "dowloading content...\n"
                sleep 1

                # pass the url and filename to the function
                scrape_html_text "${url}" "${filename}.${ext}"

              else
                echo -e "cancelling download....."
                echo -e "exiting program..."
                exit
              fi

            # download the content if the file is empty
            elif [ ! -s  "${filename}.${ext}" ]; then
              echo -e "The file is empty."
              echo -e "dowloading content...\n"
              sleep 1

              # pass the url and filename to the function
              scrape_html_text "${url}" "${filename}"

            fi

        else
          echo -e "user seleccted 'no' or invalid input"
          echo -e "exiting program..."
          exit
        fi

      # user chooses to direct content to filename (no extension)
      elif [ "${ans2}" ==  "${filename}" ]; then
        read -p "Confirm redirect content to "${filename}" (Y/N): " ans5

        if [ "${ans5}" == "Y" -o "${ans5}" == "y" -o \
          "${ans5}" == "Yes" -o "${ans5}" == "yes"  ]; then

            # check if the file is NOT empty
            if [ -s "${filename}" ]; then
              echo "The file has existing content."
              read -p "Overwrite existing content?: (Y/N): " ans6
              if [ "${ans6}" == "Y" -o "${ans6}" == "y" -o \
                "${ans6}" == "Yes" -o "${ans6}" == "yes"  ]; then
                  echo -e "dowloading content...\n"
                  sleep 1
                  # pass the url and filename to the function
                  scrape_html_text "${url}" "${filename}"
              else
                echo -e "cancelling download....."
                echo -e "exiting program..."
                exit
              fi

            # download the content if the file is empty
            elif [ ! -s  "${filename}" ]; then
              echo -e "The file is empty."
              echo -e "dowloading content...\n"
              sleep 1

              # pass the url and filename to the function
              scrape_html_text "${url}" "${filename}"

            fi

        else
          echo -e "user seleccted 'no' or invalid input"
          echo -e "exiting program..."
          exit
        fi

      # exit if user does not make a selection to direct the content
      else
        echo -e "User did not select a file"
        echo -e "exiting the program...."
        exit

      fi

    # check if there is only one existing file that matches the user input
    # prompt user to ensure they want to overwrite existing content
    elif [ -f "${filename}" ]; then

      # check if the file is NOT empty
      if [ -s "${filename}" ]; then
        echo "The file has existing content."
        read -p "Overwrite existing content?: (Y/N): " ans7
        if [ "${ans7}" == "Y" -o "${ans7}" == "y" -o \
          "${ans7}" == "Yes" -o "${ans7}" == "yes"  ]; then
          echo -e "dowloading content...\n"
          sleep 1

          # pass the url and filename to the function
          scrape_html_text "${url}" "${filename}"

        else
          echo -e "cancelling download....."
          echo -e "exiting program..."
          exit
        fi

      # download the content if the file is empty
      elif [ ! -s  "${filename}" ]; then
        echo -e "The file is empty."
        echo -e "dowloading content...\n"
        sleep 1

        # pass the url and filename to the function
        scrape_html_text "${url}" "${filename}"

      fi

    # exit program if user input does not match an existing file in the directory
    else
      echo -e "\nThe file "${filename}" is not in the directory."
    fi
    exit
    ;;

  2)
    echo -e "You chose to create a new file."
    read -p "Enter the filename: " filename
    echo -e "----------test print filename: ${filename}-------------------\n"

    # if the user enters a filename without an extension
    if [[ "${filename}" =~ (^[a-zA-Z0-9\_\-]+)([\.]+)([a-z0-9]+) ]]; then
      touch ${filename} && echo "creating file..."
      sleep 1
      echo -e "dowloading content...\n"
      sleep 1

    elif [[  "${filename}" =~ (^[a-zA-Z0-9\_\-]+) ]]; then
      read -p "Does the file have an extension?: (Y/N) " ans8

      # ask user for an extension and answer is "yes"
      if [ "${ans8}" == "Y" -o "${ans8}" == "y" -o \
        "${ans8}" == "Yes" -o "${ans8}" == "yes"  ]; then
          read -p "Enter file type (.csv,.html,.jpeg,.json,.txt,.xls,.xml,etc...): " ext
          echo -e "------------------test print extension: ${ext}-------------------\n"

          # user must enter .ext or ext; all other entries will exit the program
          if [[ ${ext} =~ (^\.)([a-z0-9]+) ]]; then
            ext=${BASH_REMATCH[2]}
            echo -e "------------------test regexp ${BASH_REMATCH[2]}------------------"
            echo -e "-----------------extension test: ${ext}-----------------------\n"
            filename=${filename}.${ext}
            echo -e "----------------test filename with extension:${filename}-------------------\n"
            touch ${filename} && echo "creating file..."
            sleep 1
            echo -e "----------------test filename with extension:${filename}-------------------\n"
            echo -e "dowloading content...\n"
            sleep 1

            # pass the url and filename to the function
            scrape_html_text "${url}" "${filename}"

          elif [[ ${ext} =~ (^[a-z0-9]+) ]]; then
            ext=${BASH_REMATCH[1]}
            echo -e "------------------test regexp ${BASH_REMATCH[1]}------------------"
            echo -e "-----------------extension test: ${ext}-----------------------\n"
            filename=${filename}.${ext}
            echo -e "----------------test filename with extension:${filename}-------------------\n"
            touch ${filename} && echo "creating file..."
            sleep 1
            echo -e "----------------test filename with extension:${filename}-------------------\n"
            echo -e "dowloading content...\n"
            sleep 1

            # pass the url and filename to the function
            scrape_html_text "${url}" "${filename}"

          else
            echo -e "\n------------test regexp nomatch------------------"
            echo -e "incorrect extension type...exiting program"
            exit

          fi

      # ask user for an extension and answer is "no"
      elif [ "${ans8}" == "N" -o "${ans8}" == "n" -o \
            "${ans8}" == "No" -o "${ans8}" == "no"  ]; then
              touch ${filename} && echo "creating file..."
              sleep 1
              echo -e "----------------test filename with extension:${filename}-------------------\n"
              echo -e "dowloading content...\n"
              sleep 1

              # pass the url and filename to the function
              scrape_html_text "${url}" "${filename}"

      # user enters incorrect input so the program exits
      else
        echo -e "You did not enter 'yes' or 'no' or incorrect input."
        echo -e "exiting the program..."
        exit

      fi

    else
        echo -e "Invalid file format."
        echo -e "exiting the program...."
        exit

    fi
    ;;

  *)
    echo "You made no choice."
    exit
    ;;

  esac
