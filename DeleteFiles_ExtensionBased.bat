@ECHO OFF
CLS
:: Setting variables to be local only and get input from user (for now accepting just one extension per running)
SETLOCAL EnableExtensions EnableDelayedExpansion
chcp 65001 1>nul

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

SET /p SearchPath=Type path for search..: 
SET /p ExtensionToSearch=Type the extension that you're searching to [just extension, without dot and asterisk]..: 

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
    echo ~ Changing to %SearchPath% and searching for *.%ExtensionToSearch%
    cd /d "%SearchPath%"

    echo.
    echo ~ Searching files and saving result in a temporary file
    echo.
    
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

    FOR /F "usebackq tokens=* eol=#" %%G in ("%~dp0temporary_file") do ( 
        echo        Deleting file ~^> %%G        
        
        del /f "%%G"
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
