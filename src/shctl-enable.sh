# args must be exactly 3
if [ $# -ne 3 ]; then
    echo >&2 "Error: Exactly three arguments required."
    return 1
fi

# create symlink in actives directory if it doesn't already exist
if [ -e "$2" ] && [ -h "$2" ]; then
    echo "'$3' already enabled"
else
    ln -s "$1" "$2"
fi
