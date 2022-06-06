#!/bin/bash
# simple script to query the existance of specific Oracle jdk executable, if installed.
#
# @return: JSON string : { "found": true/false, "not_found": true/false }
#

PACKAGE="\"$1\""

line=$(java -version 2>&1  | grep $PACKAGE | wc -l)
#echo $line


if [[ $line =~ 0 ]]; then
  echo 'false'

else
  echo 'true'

fi
