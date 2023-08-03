#!/bin/bash

# Color message print
function color() {
    case $1 in
        red)     echo -e "\033[31m$2\033[0m" ;;
        green)   echo -e "\033[32m$2\033[0m" ;;
        yellow)  echo -e "\033[33m$2\033[0m" ;;
        blue)    echo -e "\033[34m$2\033[0m" ;;
        none)    echo "$2" ;;
    esac
}

# Check whether the parameter is empty
function check_param() {
    if [ ! -n "$1" ]; then
        color red "Please specify parameter $2."
        exit 1
    fi
}

# Check the result of the last function execution
function check_result() {
    if [[ $? != 0 ]]; then
        color red $1
        exit 1
    fi
}

