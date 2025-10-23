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

# get status of script and display it
if [ -e "${actives_dir}/${script_filename}" ]; then
    echo -e "${script_name}: \e[32menabled\e[0m"
else
    echo -e "${script_name}: \e[31mdisabled\e[0m"
fi

# unset variables
unset script_path
unset actives_dir
unset script_filename
unset script_name
