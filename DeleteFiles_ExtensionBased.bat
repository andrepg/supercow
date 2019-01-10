@ECHO OFF
CLS
:: Setting variables to be local only and get input from user (for now accepting just one extension per running)
SETLOCAL EnableExtensions EnableDelayedExpansion
chcp 65001
echo.
SET /p SearchPath=Type path for search..: 
SET /p ExtensionToSearch=Type the extension that you're searching to [just extension, without dot and asterisk]..: 

IF EXIST %SearchPath% (
    echo.
    echo ~ Changing to %SearchPath% and searching for *.%ExtensionToSearch%
    cd /d "%SearchPath%"

    echo.
    echo ~ Searching files and saving result in a temporary file
    
    dir /s /b %SearchPath%\*.%ExtensionToSearch% > "%~dp0temporary_file"

    echo.
    echo ~ Retrieving results and starting to remove files ...
    echo.

    FOR /F "usebackq tokens=* eol=#" %%G in ("%~dp0temporary_file") do ( 
        echo Deleting file ~^> %%G
        del /f "%%G"
    )

    echo.
    echo ~ Changing back to our initial path
    
    
) ELSE (
    echo.
    echo.
    echo ***** ERROR !!! 
    echo.
    echo Provided path not found. Check if path exists and try again ;
)
GOTO:EOF
ENDLOCAL
