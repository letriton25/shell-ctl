################
# CLI FUNCTION #
################

shctl ()
{
    # variables
    local shctl_dir=~/.bashrc.d
    local src_dir=${shctl_dir}/src
    local script_dir=${shctl_dir}/scripts
    local actives_dir=${shctl_dir}/actives

    local usage_path="${src_dir}/shctl-usage.sh"
    local version_path="${src_dir}/shctl-version.sh"

    # check arguments
    if [ $# -eq 0 ]; then
        . "${usage_path}"
        return 1
    fi
    local cmd="$1"
    local cmd_path="${src_dir}/shctl-${cmd}.sh"
    shift

    # command parsing
    case "$cmd" in
        run|enable|disable|status)
            if [ $# -ne 1 ]; then
                echo >&2 "Error: Script name required for '$cmd' command."
                . "${usage_path}"
                return 1
            fi
            local script_name="$1"
            local script_path="${script_dir}/${script_name}.sh"
            if [ ! -f "${script_path}" ]; then
                echo >&2 "Error: Script '${script_name}' not found."
                return 1
            fi
            . "${cmd_path}" "${script_path}" "${actives_dir}"
            ;;
        help|--help)
            . "${usage_path}"
            ;;
        --version)
            . "${version_path}"
            ;;
        *)
            echo >&2 "Error: Unknown command '$cmd'."
            . "${usage_path}"
            return 1
            ;;
    esac
    return 0
}

##################
# STARTUP SYSTEM #
##################

for active in ~/.bashrc.d/actives/*; do
    [ -h "$active" ] || continue
    . "$active"
done
