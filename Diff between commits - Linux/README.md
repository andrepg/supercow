# README

## Overview

The script was wrote to avoid deploy an entire application under Git. We check the differences between two commits, put the files inside a **changelist.file** and copy to a **files_to_deploy** path to be deployed by Continuous Integration.

## Usage

If you run the script with a `--help` argument youll see the following:

```text
Help of FTP deploy script

Usage :: run script with parameters and using BASH. All parameters are mandatory!

All of them have fixed position. Do not change the order...

Command usage
~$: bash /script.sh [ workspace source target ]

Parameters
- workspace : Workspace path where source code are located ( and git repo too! )
- source : Source commit of repo to check against target and get changelist
- target : Target commit of repo used as reference of last stable modification
```

You provide as arguments:

- **at first**: the absolute path to repository
- **at second**: the hex of source commit to compare.
- **at third**: the hex of target commit to diff

After the script run, you can point your Continuos Integration to deploy only files inside `files_to_deploy` folder under root repository.
