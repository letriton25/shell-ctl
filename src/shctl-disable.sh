# args must be exactly 2
if [ $# -ne 2 ]; then
    echo >&2 "Error: Exactly two arguments required."
    return 1
fi

# load arguments
script_path="$1"
actives_dir="$2"
script_filename=$(basename "$script_path")
script_name="${script_filename%.sh}"

# remove symlink in actives directory if it exists
if [ ! -e "${actives_dir}/${script_filename}" ]; then
    echo "Script '${script_name}' is not enabled."
else
    rm "${actives_dir}/${script_filename}"
    echo "Script '${script_name}' disabled."
fi

# unset variables
unset script_path
unset actives_dir
unset script_filename
unset script_name
