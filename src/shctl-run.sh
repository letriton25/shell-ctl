# args must be exactly 2
if [ $# -ne 2 ]; then
    echo >&2 "Error: Exactly two arguments required."
    return 1
fi

# start script
. "$1"
