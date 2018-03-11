#!/bin/bash

# log()
# {
#     while read message
#     do
#         echo $message
#         echo "$(date '+%Y-%m-%d %H:%M:%S')    $0    [message]$message" >>installer.log
#     done
# }

# exec 2> >(log ${BASH_LINENO[0]})

exec 2> >(tee -a "installer.log")