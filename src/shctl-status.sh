# args must be exactly 3
if [ $# -ne 3 ]; then
    echo >&2 "Error: Exactly three arguments required."
    return 1
fi

# get status of script and display it
if [ -e "$2" ]; then
    echo -e "\e[32menabled\e[0m   $3"
else
    echo -e "\e[31mdisabled\e[0m  $3"
fi
