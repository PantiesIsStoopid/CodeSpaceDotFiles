#!/bin/bash

# -----------------------------------------------------
# INIT
# -----------------------------------------------------

# Exit if any command fails
set -e

# -----------------------------------------------------
# Install dependencies
# -----------------------------------------------------
echo "Installing dependencies..."

# Update package lists
sudo apt update

# Install required packages (make sure to add any other dependencies if needed)
sudo apt install -y \
  git \
  curl \
  neovim \
  zoxide \
  jq \
  speedtest-cli \
  ccache \
  openssl \
  build-essential \
  fastfetch \
  terminal-icons \
  psreadline

# -----------------------------------------------------
# Setup .bashrc
# -----------------------------------------------------

# Backup the existing .bashrc
echo "Backing up the existing .bashrc..."
cp ~/.bashrc ~/.bashrc.backup

# Apply the provided .bashrc content
echo "Setting up the .bashrc profile..."

cat << 'EOF' >> ~/.bashrc
# -----------------------------------------------------
# INIT
# -----------------------------------------------------

# -----------------------------------------------------
# Exports
# -----------------------------------------------------
export EDITOR=nvim
export PATH="/usr/lib/ccache/bin/:$PATH"

# -----------------------------------------------------
# Initial GitHub.com connectivity check with 1 second timeout
if ping -c 1 -W 1 github.com &> /dev/null; then
  CanConnectToGitHub=true
else
  CanConnectToGitHub=false
fi

# Aliases
alias Vim='nvim'
alias Docs='cd ~/Documents'
alias Dtop='cd ~/Desktop'
alias Dloads='cd ~/Downloads'
alias La='ls -la'
alias Ll='ls -la'
alias SysInfo='uname -a'
alias FlushDNS='sudo systemd-resolve --flush-caches && echo "DNS has been flushed"'
alias DelCmdHistory='history -c && rm ~/.bash_history && echo "Command history has been cleared"'
alias GetPubIP='curl ifconfig.me'
alias GetPrivIP='hostname -I'
alias Speedtest='speedtest-cli'
alias Fe='xdg-open .'
alias Home='cd ~'
alias Root='cd /'
alias Update='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y'
alias LinUtil='curl -fsSL https://christitus.com/linux | sh'
alias ReloadProfile='source ~/.bash_profile'
alias SystemScan='sudo apt-get install -y debsums && sudo debsums -s'
alias ClearRAM='sync; echo 3 > /proc/sys/vm/drop_caches'
alias ReinstallWinget='sudo apt-get remove --purge winget && sudo apt-get install -y winget'
alias EmptyBin='rm -rf ~/.local/share/Trash/*'
alias CalcPi='echo "scale=100; 4*a(1)" | bc -l'
alias Shutdown='sudo shutdown now'
alias RPassword='openssl rand -base64 $1'
alias RandomFact='curl -s https://uselessfacts.jsph.pl/random.json?language=en | jq -r .text'
alias ClearCache='sudo apt-get clean && sudo apt-get autoclean && sudo apt-get autoremove -y'
alias Gl='git log'
alias Gs='git status'
alias Ga='git add .'
alias Gc='git commit -m "$1"'
alias Gp='git push'
alias G='zoxide z github'
alias Gcl='git clone "$1"'
alias Gcom='git add . && git commit -m "$1"'
alias LazyG='git add . && git commit -m "$1" && git push'
alias LazyInit='git init && git add . && git commit -m "first commit" && git branch -M master && git remote add origin "$1" && git push -u origin master'

# CheatSheet
CheatSheet() {
  cat << EOF
PowerShell Cheatsheet
=====================

Basic Commands:
- Get-Command: Lists all cmdlets, functions, workflows, aliases installed.
- Get-Process: Retrieves a list of running processes.
- Start-Process: Starts a process.
- Stop-Process: Stops a process.
- Get-Service: Lists all services.
- Start-Service: Starts a service.
- Stop-Service: Stops a service.
- Restart-Service: Restarts a service.

File and Directory Management:
- Get-ChildItem: Lists items in a directory (alias: ls, dir).
- Set-Location: Changes the current directory (alias: cd).
- Copy-Item: Copies an item from one location to another.
- Move-Item: Moves an item from one location to another.
- Remove-Item: Deletes an item.
- New-Item: Creates a new item (file, directory, etc.).
- Get-Content: Reads content of a file.
- Set-Content: Writes or replaces content in a file.
- Add-Content: Appends content to a file.

System Information:
- Get-Location: Displays the current directory.
EOF
}

# Help Function
ShowHelp() {
  cat << EOF
PowerShell Profile Help
=======================

Directory Navigation:
- Docs: Changes the current directory to the user's Documents folder.
- Dtop: Changes the current directory to the user's Desktop folder.
- Dloads: Changes the current directory to the user's Downloads folder.
- Home: Changes directories to the user's home.
- Root: Changes directories to the C: drive.

File and System Information:
- La: Lists all files in the current directory with detailed formatting.
- Ll: Lists all files, including hidden, in the current directory with detailed formatting.
- SysInfo: Displays detailed system information.
- GetPrivIP: Retrieves the private IP address of the machine.
- GetPubIP: Retrieves the public IP address of the machine.
- Speedtest: Runs a speedtest for your internet.

System Maintenance:
- FlushDNS: Clears the DNS cache.
- DelCmdHistory: Deletes the command history.
- SystemScan: Runs a DISM and SFC scan.
- Update: Updates all known apps.
- EmptyBin: Empties the Recycling bin.
- ClearCache: Clears Windows caches.

Utility Functions:
- Fe: Opens File Explorer in your current directory.
- LinUtil: Runs the Chris Titus Tech Linux utility.
- ReloadProfile: Reloads the terminal profile.
- ClearRAM: Cleans up the standby memory in RAM.
- ReinstallWinget: Uninstalls Winget and reinstalls it.
- CalcPi: Calculates pi to 100 digits.
- Shutdown: Shutdown PC (-Force to force shutdown).
- RPassword <Length>: Makes a random password.
- RandomFact: Prints a random fun fact.

Git Function:
- Gl: Shortcut for 'git log'.
- Gs: Shortcut for 'git status'.
- Ga: Shortcut for 'git add .' .
- Gc <message>: Shortcut for 'git commit -m'.
- Gp: Shortcut for 'git push'.
- G: Changes to the GitHub directory.
- Gcom <message>: Adds all changes and commits with the specified message.
- LazyG <message>: Adds all changes, commits with the specified message, and pushes to the remote repository.
- LazyInit <URL>: Adds all steps for the init of a repo and can add remote url.

- CheatSheet: Displays a list of all the most common commands.

Use 'ShowHelp' to display this help message.
EOF
}

# -----------------------------------------------------
# CUSTOMIZATION
# -----------------------------------------------------

# Initialize zoxide
eval "$(zoxide init bash)"

# Initialize Oh My Posh config
if [[ $0 != *"oh-my-posh"* ]]; then
  eval "$(oh-my-posh init bash --config https://raw.githubusercontent.com/PantiesIsStoopid/PowerShell/refs/heads/main/DraculaGit.omp.json)"
fi

# -----------------------------------------------------
# AUTOSTART
# -----------------------------------------------------

# Fastfetch
if [[ $(tty) == *"pts"* ]]; then
else
    echo
    if [ -f /bin/qtile ]; then
        echo "Start Qtile X11 with command Qtile"
    fi
    if [ -f /bin/hyprctl ]; then
        echo "Start Hyprland with command Hyprland"
    fi
fi

# Autostart

# Clear the console
clear

# Run Fastfetch only if not in Visual Studio Code Terminal
if [ "$TERM_PROGRAM" != "vscode" ]; then
  fastfetch --config "$(dirname "$(dirname "$0")")/fastfetch/fastconfig.jsonc"
fi

EOF

# Reload the updated .bashrc
source ~/.bashrc

echo "Installation and .bashrc setup complete!"