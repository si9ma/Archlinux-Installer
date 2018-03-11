#!/bin/bash

if [ "$(whoami)" = "root" ]
then
    echo
    echo
    echo "you should not run this script as root"
    echo
    echo
    exit 0;
fi
