#!/bin/bash
echo "Hello Anubhav this is your first script"
##
# echo "Please Enter your name"
# read user_name
# echo "Hello $user_name, how are you ?"

#####- Command Substitution $(). -->> Command substitution lets you capture the output of a command into a variable.
current_time=$(date)
echo "The current time is: $current_time"
echo "Files in current directory: $(ls | wc -l)"


# Exit Codes ($?) and Error Handling
# Every command in Linux returns an exit code:
# 0 → Success
# Non-zero → Error
ls /etc/passwd
echo $?   # Should return 0 (success)

ls /file/does/not/exist
echo $?   # Should return 2 (No such file)
