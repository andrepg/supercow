:: Disable echo of commands and clean screen
@echo off & cls
echo. Starting script execution

:: Set variables to be only local (don't keep in path after execution)
:: Enable delayed expansion to work with in loops and others
SETLOCAL EnableExtensions EnableDelayedExpansion

:: Getting current execution path
echo. Setting execution path with value "%~dp0"
SET EXECUTION_PATH="%~dp0"

:: Calling main function of bat file    
:: Show some default characteres to fill screen
echo. Starting compilation process

:: Verify first argument to see if it's a "--help" or "-h" command
IF "%~1" EQU "--help" GOTO:SHOW_HELP_MESSAGE
IF "%~1" EQU "-h" GOTO:SHOW_HELP_MESSAGE

:: Try to check all configuration and exit if something went wrong
IF ["%os_DCC_FILE:"=%"]==[""] (
    echo. Path to DCC file not found in environment variables (os_DCC_FILE^)
    ENDLOCAL
    exit /b 1
)
IF [%os_DELPHI_ROOT%]==[] (
    echo. Path to Delphi root installation not found in environment variables (os_DELPHI_ROOT^)
    ENDLOCAL
    exit /b 1
)    
IF [%os_BPL_OUT%]==[] (
    echo. Output of compiled files not found in environment variables (os_BPL_OUT^)
    ENDLOCAL
    exit /b 1
)
IF [%os_DCP_OUT%]==[] (
    echo. Output of compiled files not found in environment variables (os_DCP_OUT^)
    ENDLOCAL
    exit /b 1
)
IF [%os_DCU_OUT%]==[] (
    echo. Output of compiled files not found in environment variables (os_DCU_OUT^)
    ENDLOCAL
    exit /b 1
)
IF [%os_PACKAGES%]==[] (
    echo. Output of compiled files not found in environment variables (os_PACKAGES^)
    ENDLOCAL
    exit /b 1
) 

:: Clean and re-create output folders
:: rd /s /q %fBPLOut% 2>nul
:: rd /s /q %fDCPOut% 2>nul
:: rd /s /q %fDCUOut% 2>nul
md "%os_BPL_OUT:"=%" 2>NUL
md "%os_DCP_OUT:"=%" 2>NUL
md "%os_DCU_OUT:"=%" 2>NUL

:: Call script to compile packages according with packages.txt
SET os_DELPHI_COMPILER="%os_DELPHI_ROOT:"=%Bin\dcc32.exe"
SET os_DELPHI_RESOURCER="%os_DELPHI_ROOT:"=%Bin\brcc32.exe"
echo. Using %os_DELPHI_COMPILER% and %os_DELPHI_RESOURCER%

echo. 
echo. ~~ Starting packages compilation
echo. 

FOR /F "usebackq tokens=* eol=#" %%F in ("%os_PACKAGES:"=%") do (   
    :: Starting dealing with packages and change to package directory
    call:GET_NAME PackageName "%WORKSPACE:"=%\%%F"
    call:GET_PATH PackagePath "%WORKSPACE:"=%\%%F"
            
    echo.
    echo. Dealing with package !PackageName!        
    echo. Changing to !PackagePath! directory
    cd /D "!PackagePath!" || EXIT /B 1
    
    :: Copy dcc32.cfg file to use with compiler
    echo. Copying dcc32.cfg from %os_DCC_FILE% to current path
    copy /Y "%os_DCC_FILE:"=%" "!PackagePath!!PackageName!.cfg"
    
    :: Starting efective compilation of package
    echo. Compiling package !PackageName!...       
    
    :: Compilation with Compiler. We use the dcc32.cfg file to include path to search, path of units and resource path. Also, DCP and DCU output folder are included to search path
    %os_DELPHI_COMPILER% -Q -B -I!os_DELPHI_SOURCE_PATH! -U!os_DELPHI_SOURCE_PATH! -I%os_DCP_OUT% -I%os_DCU_OUT% -U%os_DCP_OUT% -U%os_DCU_OUT% -LN%os_DCP_OUT% -LE%os_BPL_OUT% -N%os_DCU_OUT% "!PackageName!.dpk" || exit /b 1
) 

:: Ends script execution if all going well
ENDLOCAL
exit /b 0

:SHOW_HELP_MESSAGE
    echo.
    echo.~~                 SHOW_HELP_MESSAGE SCREEN                 ~~
    echo.  - Script execution at path "%EXECUTION_PATH%"
    exit /b 0
    
:GET_PATH
    SET %1=%~dp2
    GoTo:EOF

:GET_NAME
    SET %1=%~n2
    GoTo:EOF
