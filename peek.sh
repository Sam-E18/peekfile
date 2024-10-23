#!/bin/bash

#Print the first and the last lines of an input file, with 3 dots in the middle of it.
#(You need to put the numeber of lines after the file).
#Ejm. bash peek.sh tables/target_prokaryotes.txt 3

head -n "$2" "$1"
echo "..."
tail -n "$2" "$1"

