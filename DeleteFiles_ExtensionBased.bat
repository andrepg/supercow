@ECHO OFF
CLS

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.

:: First, we set some variables, parameters for input, collation and some characters. 
:: Then ask user for some input (such as path to search and extension desired). If user don't
:: provide one of these parameters, script will fail indicating what is missing and forcing
:: user to run the script again and provide new informations
SETLOCAL EnableExtensions EnableDelayedExpansion
chcp 65001 1>nul
SET /p SearchPath=Type path for search..: 
SET /p ExtensionToSearch=Type the extension that you're searching to [just extension, without dot and/or asterisk]..: 

IF [%SearchPath%]==[] (
    echo.
    echo *
    echo *                   
    echo *     ERROR !!!     
    echo *                   
    echo *
    echo *
    echo *     Search path was not provided. Try again...
    echo *
    echo *
    echo.
    GOTO:END_SCRIPT
)

IF [%ExtensionToSearch%]==[] (
    echo.
    echo *
    echo *                   
    echo *     ERROR !!!     
    echo *                   
    echo *
    echo *
    echo *     You don't provide an extension to search. Try again...
    echo *
    echo *
    echo.
    GOTO:END_SCRIPT
)


IF EXIST %SearchPath% (
    echo.
    echo ~ OK. We'll search for files with %ExtensionToSearch% extension into 
    echo     %SearchPath% and his subfolders. 
    echo.
    echo ~ Searching files and saving result in a temporary file
    echo.
    
    :: If no files was found with DIR command, then ERRORLEVEL will be not equal 0
    :: by a default system behavior. We check this error level and the script will fail
    :: when we can find any file into given folder/subfolders with given extension
    dir /s /b %SearchPath%\*.%ExtensionToSearch% 1>"%~dp0temporary_file" 2>nul
    IF !ERRORLEVEL! NEQ 0 (
        echo.
        echo *
        echo *                   
        echo *     ERROR !!!     
        echo *                   
        echo *
        echo *
        echo *     No files was found with given parameters ;
        echo *
        echo *
        echo.
        GOTO:END_SCRIPT
    )

    echo.
    echo ~ Retrieving results and starting to remove files ...
    echo.

    :: For each file saved into temporary_file we'll run the DEL command and 
    :: provide an output to console telling what file was deleted
    FOR /F "usebackq tokens=* eol=#" %%G in ("%~dp0temporary_file") do ( 
        echo        Deleting file ~^> %%G        
        
        del /f "%%G"

        :: Increase counter of deleted files to show after the script execution
        SET /A "DeletedFilesCounter+=1"
    )

    echo.
    echo ~ !DeletedFilesCounter! files deleted at this execution
    echo.
    echo.
    echo ~ Removing temporary file created by script

    del /f/q "%~dp0temporary_file"

    echo ~ Changing back to our initial path
    echo.
    echo. 
    
    
) ELSE (
    echo.
    echo *
    echo *                   
    echo *     ERROR !!!     
    echo *                   
    echo *
    echo *
    echo *     Provided path not found. Check if path exists and try again ;
    echo *
    echo *
    echo.
)

:END_SCRIPT
    ENDLOCAL
    echo ~   ENDING SCRIPT
