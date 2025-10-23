# args must be exactly 3
if [ $# -ne 3 ]; then
    echo >&2 "Error: Exactly three arguments required."
    return 1
fi

# start script
. "$1"
