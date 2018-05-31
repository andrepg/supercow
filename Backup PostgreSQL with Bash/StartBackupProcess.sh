#!/bin/bash
clear

echo "+----------------------------------------------------------------------------+ "
echo "|"
echo "|         Backup script tool, made in Bash "
echo "|         Copyleft (c) Andre Paul Grandsire "
echo "|"
echo "|         This is our first open source version of bash script "
echo "|   to make a backup of a PostgreSQL database, zip them and delete"
echo "|   older files to not fill up hard disk storage. "
echo "|"
echo "|         We develop two files that work together. An AppCore.sh file"
echo "|   and a StartBackupProcess.sh file. The first controls the backup, "
echo "|   and the second controls all the process, including a call for "
echo "|   AppCore.sh file. "
echo "|    "
echo "|         There's a few variables to configure inside AppCore.sh file, "
echo "|   but's not that so hard to do. It's a few things like hostname, port, "
echo "|   username and path where backup will be saved. "
echo "|    "
echo "|         It's easy to understand, a lot! "
echo "|    "
echo "|    "

sh /backup/AppCore.sh

# echo ""
# echo "- Iniciando sincronizacao com servidor remoto"
# echo "-- Abrindo conexao rSync"
# rsync -varzuP --human-readable -e 'ssh -p 22' /backup/* user@host.address.com:/home/backup/
