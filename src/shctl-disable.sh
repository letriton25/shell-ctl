# args must be exactly 3
if [ $# -ne 3 ]; then
    echo >&2 "Error: Exactly three arguments required."
    return 1
fi

# remove symlink in actives directory if it exists
if [ ! -e "$2" ] || [ ! -h "$2" ]; then
    echo "'$3' is not enabled"
else
    rm "$2"
fi
