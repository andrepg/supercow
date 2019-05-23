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

function show_help() {
    echo 'Help of FTP deploy script'
    echo 
    echo 'Usage :: run script with parameters. All parameters are mandatory! '
    echo 'All of them have fixed position. Do not change the order...'
    echo 
    echo './script.sh [ FTP_CONNECTION FTP_USER FTP_PASSWORD FTP_PORT CHANGELIST COMMIT_SOURCE COMMIT_TARGET ]'
}


####### Main execution of script 
TITLE="Deploy to FTP Server"

if [ $# -gt 0 ]; then
    
    
    clear
    # Getting parameters from command line (positional at first moment)
    FTP_CONNECTION=$1
    FTP_USER=$2
    FTP_PASSWORD=$3
    FTP_PORT=$4
    CHANGELIST=$5
    COMMIT_SOURCE=$6
    COMMIT_TARGET=$7

    echo 
    echo ">> Script configured to connect on $FTP_CONNECTION with $FTP_USER"
    echo ">> Using changelist files located at $CHANGELIST"
    echo ">> Changelist file was based on diff between initial commit $COMMIT_SOURCE and last commit $COMMIT_TARGET"
    echo 
else
    echo "RUNTIME ERROR"
    echo "Your command line contains no argument. Run it with --help to see more."
fi
