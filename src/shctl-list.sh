# args must be exactly 2
if [ $# -ne 2 ]; then
    echo >&2 "Error: Exactly two arguments required."
    return 1
fi

# load arguments
scripts_dir="$1"
actives_dir="$2"

# list all scripts and their status and enabled in bold green, disabled in red
for script in "${scripts_dir}"/*.sh; do
    script_filename=$(basename "$script")
    script_name="${script_filename%.sh}"
    if [ -e "${actives_dir}/${script_filename}" ]; then
        echo -e "\e[32menabled\e[0m   \e[1m${script_name}\e[0m"
    else
        echo -e "\e[31mdisabled\e[0m  ${script_name}"
    fi
done
unset script

# unset variables
unset scripts_dir
unset actives_dir
unset script_filename
unset script_name
