@echo off

echo.
echo. ~~ Setting environment variables
echo.

echo. -- Setting Delphi root path (os_DELPHI_ROOT^)
SET os_DELPHI_ROOT="C:\Program Files (x86)\Borland\Delphi7\"

echo. -- Setting DCC configuration file (os_DCC^)
SET os_DCC_FILE="Path/To/DCC/File"

echo. -- Setting BPL output path (os_BPL_OUT^)
SET os_BPL_OUT="Drive:\CompiledJobs\BPL"

echo. -- Setting DCP output path (os_DCP_OUT^)
SET os_DCP_OUT="Drive:\CompiledJobs\DCP"

echo. -- Setting DCU output path (os_DCU_OUT^)
SET os_DCU_OUT="Drive:\CompiledJobs\DCU"

echo. -- Setting packages to compile file (os_PACKAGES)
SET os_PACKAGES="Path/To/Packages/Files"

call "Core.bat"