#!/bin/bash

#Script to print the numbers of lines of the input file,depending on if has zero,one or >1line.
#Example of input expected: bash countlines.sh name_ofthe_file.txt 

#First, verify the file.

if [[ -z "$1" ]]; then
  echo "Error: No se proporcionó ningún archivo."
  exit 1
fi

#Obtain the name and count the number of lines in the file.
filename="$1"
line_count=$(wc -l < "$filename")

#In this part choose the nummber of lines and show differents messages.
if [[ $line_count -eq 0 ]]; then
  echo "The file '$filename' its empty."
elif [[ $line_count -eq 1 ]]; then
  echo "The file '$filename' have 1 line."
else
  echo "The file '$filename' have $line_count lines."
fi
