# args must be exactly 3
if [ $# -ne 3 ]; then
    echo >&2 "Error: Exactly three arguments required."
    return 1
fi

# remove script file (and its symlink if it exists)
if [ -e "$1" ]; then
    rm "$1"
    [ -h "$2" ] && rm "$2"
    echo -e "\e[31mremoved\e[0m   $3"
else
    echo "Script '$3' does not exist."
fi
