#!/bin/bash

#Print the first three and the las three lines of an input file

head -n 3 "$1"
echo "..."
tail -n 3 "$1"
