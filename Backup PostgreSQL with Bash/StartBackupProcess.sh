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
echo "|    "
echo "|         There's a few variables to configure inside this file, "
echo "|   but's not that so hard to do. It's a few things like hostname,"
echo "|   server port, username and path where backup will be saved. "
echo "|    "
echo "|         It's easy to understand, a lot! "
echo "|    "
echo "|    "

current_data=$(date +%Y%m%d)
hostname="localhost"
user="alterdata"
port=5432
base_path=/backup
database_array=$(cat $base_path/database_list.txt)

for sDatabase in $database_array
do
	## Gettin our file name (DDMMYYYY-database.sql)
	## our file path (/backup/some/place/database)
	## and our log file (/backup/some/place/log/database)
	file_name=$current_data-$sDatabase.sql
	file_path=$base_path/$sDatabase
	log_path=$base_path/log/$sDatabase

	echo "starting backup of database " $sDatabase
	echo " at path " $file_path
	echo " and name " $file_name

	## Generate our path if they don't exists
	mkdir -p $file_path && mkdir -p $log_path

	## Starting our PostgreSQL dumping process (the backup itself) and catching log of this at $log_path
	pg_dump -i -v -h $hostname -p $port -U $user $sDatabase > $file_path/$file_name 2> $log_path/$current_data.log

	## Also, besides zipping our file, we're deleting our old .sql file that tar process leaves at folder
	echo "zipping our sql generated file..."
	cd $file_path && tar -cf $file_name.tar $file_name && xz -z -9 --force $file_name.tar && rm $file_name

	## Deleting files older than 30 days to not consume hard disk storage
  find /backup/$d  -ctime +15 -exec rm -r {} \;	
done
