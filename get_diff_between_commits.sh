#!/bin/bash
#
# 2019 (c) Andre Paul Grandsire | (https://github.com/andrepg)
#   Hi! I'm Andre Paul. Born in Brazil, developer of original version of this tool.
# 
# My problem was getting a list of changed files between my last build in Jenkins 
# and the latest commit in a certain branch. The files are copied to a certain folder
# to use CI/CD and upload to FTP server. 
# 
# Our first application that use this script relies on a private repository and inside a folder
# called 'application'. So, there well be some references to this path, and you can fork and remove it.
#
# This is an OpenSource code, in first time. You can copy, change, use it and distribute as you want. 
# But you can be a gentleman keeping copyright or making a mention to the SuperCow repository 
# hosted on GitHub (https://github.com/andrepg/SuperCow)
# 
# 
# Get filename without application/ preffix
# echo ${file#"application/"}

function show_help() {
    echo -e 
    echo -e 'Help of FTP deploy script'
    echo -e
    echo -e 'Usage :: run script with parameters and using BASH. All parameters are mandatory! '
    echo -e 'All of them have fixed position. Do not change the order...'
    echo -e
    echo -e 'Command '
    echo -e '  ~$: bash /script.sh [ workspace source target ] '
    echo -e 
    echo -e 'Parameters'
    echo -e '  workspace : Workspace path where source code are located ( and git repo too! ) '
    echo -e '  source    : Source commit of repo to check against target and get changelist '
    echo -e '  target    : Target commit of repo used as reference of last stable modification '
    echo -e 
    echo -e
}

function get_changelist() {
    echo -e 'Getting changelist of repository'
    cd -e $pWorkspace
    git diff --name-only $pCommitSource $pCommitTarget | grep 'application/' >> changelist.file
    sort -u changelist.file -o changelist.file
}

function copy_files_to_deploy() {
    # Deleting and copying again to ensure that files are clean
    rm -rf "$pWorkspace/files_to_deploy"
    mkdir "$pWorkspace/files_to_deploy"

    echo -e ""
    echo -e "~~ List of changed files ..: "
    echo -e ""

    pFileCounter=0
    while read file; do
        if [ $file != *"/.gitignore" ]; then
            echo "Copying $file"
            cd -e $pWorkspace
            cp -R --parents "$file" "$pWorkspace/files_to_deploy"
        fi
    done <"$pWorkspace/changelist.file"

    echo ""
    echo "Copy of files done !"
}


####### Main execution of script
if [ $# -gt 0 ]; then
    clear

    # In first time we'll only check variants of HELP command. 
    # All other commands will be threated as positional parameters    
    if [ $1 == '--help' ]; then
        show_help
        exit 0
    fi

    # Getting parameters from command line 
    pWorkspace=$1
    pCommitSource=$2
    pCommitTarget=$3

    get_changelist
    copy_files_to_deploy
else
    echo -e "~ RUNTIME ERROR ~"
    echo -e "Your command line contains no arguments. Run it with --help to see more."
fi
