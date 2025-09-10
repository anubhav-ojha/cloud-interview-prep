#!/bin/bash
file="/etc/passwd"

if [ -f "$file" ]; then
    echo "File $file exists."
elif [ -d "$file" ]; then
    echo "$file is a directory."
else
    echo "$file does not exist."
fi

file2="/var/log/syslog"

if [ -f "$file2" ]; then
   echo "Fiel $file2 Exits"
else
   echo "file $file2 does not exist"   
fi   