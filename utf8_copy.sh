#!/bin/bash

# split using read command
function split_read()
{
  url="$1"

  # print the contents of the file
  local content=$(file -i ${1})
  echo -e "${content}"
  echo -e "\nsplit the third field"
  for item in "${content}"; do
    echo "${item}" | awk '{print $3}'

    # split the encoding type from the third field
    echo -e "capturing the encoding type from field 3...\n"
    sleep 1

    # use a new internal field separator to split field 3 of the string
    OLD_IFS=$IFS
    IFS="=" # change the default internal field separator
    encoding_type=$(echo "${item}" | awk '{print $3}')

    # store each field into the array with a "here string redirect"
    read -ra my_array <<< "${encoding_type}"

    # method 1: print the second index of the array
    echo "${my_array[1]}"

    # method 2: print the second index of the array
    # '[@]' accesses all parameters in the array
    # '[1]' accesses the second parameter
    for field in "${my_array[1]}"; do
      echo ${field}
    done
  done
  # change the internal field separator back to default
  IFS=${OLD_IFS}
}
# pass the website url parameter in the command line
# split_read ${1}

function split_tr()
{
  url="$1"

  # print the contents of the file
  local content=$(file -i "${1}")
  echo -e "${content}"
  echo -e "\nsplit the third field"
  for item in "${content}"; do
    field_three=$(echo "${item}" | awk '{print $3}')
    echo "${field_three}"

    # split the encoding type from the third field
    echo -e "\ncapturing the encoding type from field 3..."
    my_array=($(echo "${field_three}" | tr "=" "\n"))
    sleep 1
    echo -e "The array elements: ${my_array[@]}\n"

    # loop over the array and print the specific index
    for index in ${my_array[1]}; do
      echo "index three: ${index}"
    done
  done
}
split_tr ${1}

function split_awk()
{
  url="${1}"

  # print the contents of the file
  local content=$(file -i "${1}")
  echo -e "${content}"
  echo -e "\nsplit the third field"

  # split the encoding type from the third field
  echo -e "\ncapturing the encoding type from field 3..."
  sleep 1
  for item in "${content}"; do
    field_three=$(echo "${item}" | awk '{print $3}' | awk -F "=" '{print $2}')
    echo "${field_three}"
  done
}
split_awk "${1}"
