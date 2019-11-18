@echo off
CLS

:: First, we set some variables, parameters for input, collation and some characters. 
:: Then ask user for some input (such as path to search and extension desired). If user don't
:: provide one of these parameters, script will fail indicating what is missing and forcing
:: user to run the script again and provide new informations
SETLOCAL EnableExtensions EnableDelayedExpansion

chcp 65001 1>nul

:: Get some information from user. Such as path to search and extension of file to delete
:: When typing path, isn't mandatory to use the last backslash at the end of string ( \ )
:: in same way the dot ( . ) when tipyng extension of files
SET /p SearchPath=Type path for search..: 
SET /p ExtensionToSearch=Type the extension that you're searching to [just extension, without dot and/or asterisk]..: 
SET ExecutionPath=%~dp0

echo.
echo ~ OK. We'll search for files with %ExtensionToSearch% extension 
echo   into %SearchPath% and his subfolders. 
echo.
echo ~ Searching files and saving result in a temporary file
echo   at %ExecutionPath%
echo.

:: 1> redirects standard output of command to file named files_found.list ( i.e. the result of DIR command )
:: 2> redirects error output of command to nul ( don't display errors in console )
dir /s/b "%SearchPath%\*.%ExtensionToSearch%" 1>"%ExecutionPath%\files_found.list" 2>nul

echo.
echo ~ Retrieving results and starting to remove files ...

:: For each line in files_found.list, we'll display a message with a deletion message, the full path and file name
:: Also, we'll forcing delete and increase a count to display how many files were deleted.
FOR /F "usebackq tokens=* eol=#" %%G in ("%ExecutionPath%\files_found.list") do ( 
    echo    +-- Deleting ~^> %%G
    del /f/s/q "%%G" 1>nul
    SET /A DeletedFilesCounter+=1
)

echo.
echo ~ !DeletedFilesCounter! files deleted at this execution
echo.
echo ~ Removing temporary file created by script  

:: Finally, deletes file created by script to save path of found files by DIR command
del /f/s/q "%ExecutionPath%\files_found.list" 1>nul

echo ~ Changing back to our initial path
echo.
echo. 

:END_SCRIPT
    ENDLOCAL
    echo ~   ENDING SCRIPT
