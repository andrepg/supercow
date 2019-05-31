#!/bin/bash
#
# 2019 (c) Andre Paul Grandsire | (https://github.com/andrepg)
#   Hi! I'm Andre Paul.
#   I'm from Brazil and wrote this tool.
#
#   My goal was "Get a changelist from git and upload it to a FTP server in a automated way"
#
#   With this goal we could have an easy deploy based only on what files changed
# since last Jenkins build. There's no plugin or tool that we've found and helped us
#   So, I decided to wrote this Bash script to run on a Linux Jenkins server and deploy
# to a secure FTP server all files that we really need.
#
#   It's based on Git and SCP Linux implementation. We used git to get files and save into
# a changelist on disk, copy these files to a new path, used only to deploy.
#   Then, connect to FTP and send the files.
#
# Variables used by script ( all given by Jenkins when calling script )
#   FTP_CONNECTION - Address of FTP server to connect
#   FTP_USER & FTP_PASSWORD - User and password used to connect
#   FTP_PORT - Port used by server to provide connection
#   CHANGELIST - File with a list of all changed files
#   COMMIT_SOURCE - Parameter that contains SHA1 of last checked commit
#   COMMIT_TARGET - Parameter with SHA1 of last commit in repo (more recent)
#
# This script is Open Source. At all. You can copy, fork, change, distribute and
# even use it with a production environment (if you have enough courage).
#
# Enjoy.
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
    echo -e '  ~$: bash /script.sh [ ftpcon ftpuser ftppass ftpport workspace source target ] '
    echo -e 
    echo -e 'Parameters'
    echo -e '  ftpcon    : FTP server address to connect '
    echo -e '  ftpuser   : FTP username to connect @ server '
    echo -e '  ftppass   : FTP password used by username @ server '
    echo -e '  ftpport   : FTP port used by server to provide connection '
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
    echo "Copy of files done!"
}

function open_ftp_connection() {
    echo -e ""
}

####### Main execution of script
TITLE="Deploy to FTP Server"

if [ $# -gt 0 ]; then
    clear

    # In first time we'll only check variants of HELP command. 
    # All other commands will be threated as positional parameters    
    if [ $1 == '--help' ]; then
        show_help
        exit 0
    fi

    # Getting parameters from command line (positional at first moment)
    pFtpConnection=$1
    pFtpUsername=$2
    pFtpPassword=$3
    pFtpPort=$4
    pWorkspace=$5
    pCommitSource=$6
    pCommitTarget=$7
    
    echo -e
    echo -e ">> Script configured to connect on $pFtpConnection with $pFtpUsername"
    echo -e ">> Using changelist files located at $pChangeList"
    echo -e ">> Changelist file was based on diff between initial commit" \
         "$pCommitSource and last commit $pCommitTarget"
    echo -e

    get_changelist
    copy_files_to_deploy
else
    echo -e "RUNTIME ERROR"
    echo -e "Your command line contains no arguments. Run it with --help to see more."
fi
