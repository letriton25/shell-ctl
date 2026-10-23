# SHELL-CTL

`shctl` is a minimal shell startup manager. It lets you split your shell configuration into small, self-contained scripts and choose which ones run every time you open a shell, through a simple systemd-like command line: `enable`, `disable`, `status`, `list`.

Instead of one ever-growing `.bashrc`, you keep one script per feature (aliases, environment variables, prompt, completions, tool initializers, ...) and enable only the ones you want.

## Requirements

- Bash
- A Unix-like system with a `~/.bashrc` (Linux, BSD, macOS with Bash as the default shell)

## Installation

```bash
# 1. Clone the repository into ~/.bashrc.d
git clone https://github.com/letriton25/shell-ctl.git ~/.bashrc.d

# 2. Create the scripts and actives directories.
#    They are listed in .gitignore, so the clone does not contain them:
#    you have to create them manually.
mkdir ~/.bashrc.d/scripts ~/.bashrc.d/actives
```

Then add this line to your `~/.bashrc` to load shctl when a shell starts:

```bash
# launch shctl if available to manage rc shell scripts
[ -e ~/.bashrc.d/shctl ] && [ -x ~/.bashrc.d/shctl ] && source ~/.bashrc.d/shctl
```

The file is loaded only if it exists and is executable, so a missing or broken installation never breaks your shell.

Restart your shell, or run `. ~/.bashrc`. You can check that shctl is available with:

```bash
shctl --version
```

## Writing scripts

A script is any Bash file in `~/.bashrc.d/scripts/`, named `<name>.sh`. Put in it whatever you would normally write in your `.bashrc`:

```bash
# ~/.bashrc.d/scripts/aliases.sh
alias ll='ls -lh'
alias gs='git status'
```

## Usage

```
Usage: shctl {run|enable|disable|status|list|remove|help} [service_name]
       shctl --help
       shctl --version
```


| Command                | Description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| `shctl run <name>`     | Run the script now, in the current shell                     |
| `shctl enable <name>`  | Enable the script: it will run at every shell startup        |
| `shctl disable <name>` | Disable the script: it stops running at startup, but is kept |
| `shctl status <name>`  | Show whether a script is enabled or disabled                 |
| `shctl list`           | List all scripts with their status                           |
| `shctl remove <name>`  | Delete the script and its startup entry                      |
| `shctl help`           | Print the usage                                              |
| `shctl --version`      | Print the version                                            |


`<name>` is the script file name without the `.sh` extension.

Example session:

```bash
$ shctl list
disabled  aliases
disabled  prompt

$ shctl enable aliases
$ shctl status aliases
enabled   aliases

# try a script right now, without enabling it
$ shctl run prompt

$ shctl disable aliases
$ shctl remove aliases
removed   aliases
```

## Technical details

You do not need this section to use shctl; it explains how it works under the hood.

### Not an application, a shell function

shctl is not really an application. The `shctl` file, once sourced, defines a `shctl` function in your interactive shell, and typing a command simply calls that function. The command implementations live in `src/`: the function sources `src/shctl-<command>.sh` to perform the requested command.

This is a deliberate design choice. Because it is a function, shctl runs in the current shell and can source your scripts in the current shell too, instead of spawning a subshell. That is why `run` applies aliases, environment variables and functions immediately, and why enabled scripts can configure your shell at startup. A standalone executable could not do this: any change it made would be lost when its process exits.

### How startup works: the actives folder

A script is enabled by creating a symlink to it in `~/.bashrc.d/actives/`:

- `shctl enable <name>` creates the symlink `actives/<name>.sh`, pointing to `scripts/<name>.sh`.
- `shctl disable <name>` removes that symlink. The script itself is untouched, which is why disabling is always reversible.
- `shctl remove <name>` deletes both the script file and its symlink.

At the bottom of `shctl`, this loop runs at every shell startup:

```bash
for active in ~/.bashrc.d/actives/*; do
    [ -h "$active" ] || continue
    . "$active"
done
```

It sources every symlink found in `actives/`. Regular files are skipped (`-h`), so dropping a file directly into `actives/` has no effect: scripts must live in `scripts/` and be enabled with `shctl enable`.

### Directory layout

```
~/.bashrc.d/             # this repository, cloned in place
├── shctl                # the shctl function and the startup loop
├── src/                 # command implementations used by shctl
├── scripts/             # your startup scripts (created manually)
└── actives/             # symlinks to the enabled scripts (created manually)
```

## Uninstall

Remove the launch line from your `~/.bashrc`, then delete the directory:

```bash
rm -rf ~/.bashrc.d
```

## License

[MIT](LICENSE)
