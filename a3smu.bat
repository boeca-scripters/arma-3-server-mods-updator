:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Please do not edit this script if you don't know what your doing !!
@echo off
@setlocal enableextensions enabledelayedexpansion


:: Setting variables
for %%a in (%*) do (
  if "%%a" == "--help" (
    call set "%%~1=1"
  ) else (
    call set "%%~1=%%~2"
  )
  shift
)


cls
echo     _,                       __     __,
echo    / ^|                         ^)   (
echo   /--^|  _   _ _ _   __,      -/     `.  _  _   _  ,__  _
echo _/   ^|_/ (_/ / / /_(_/(_  ___/    (___^)(/_/ (_/ ^|/ (/_/ (_
echo.
echo.
echo _ _ _              __   ,
echo ( / ^) ^)      /     ( /  /         /     _/_
echo  / / / __ __/ (     /  /  ,_   __/ __,  /  __ _
echo / / (_(_^)(_/_/_^)_  (_,/__/^|_^)_(_/_(_/(_(__(_^)/ (_
echo                          /^|
echo                         (/

echo.
echo.

echo This Will Install/Update Arma3 Server Mods.
echo.
echo Start with --help to show the help messages.
echo.

if "%--help%" == "1" goto :help


echo.
echo Configure the Required Paths to Continue:

if "%--mods%" == "" (
  set /p "--mods=Path of the mods list: "
  echo.
)
if "%--steam%" == "" (
  set /p "--steam=Path of the steam cmd folder: "
  echo.
)
if "%--server%" == "" (
  set /p "--server=Path of the arma 3 server folder: "
  echo.
)

echo.
echo Done.

echo.
echo Configure the Steam Account to Continue:

echo "%--pass%"

if "%--user%" == "" (
  set /p "--user=Username: "
  echo.
)
if "%--pass%" == "" (
  set /p "--pass=Pass: "
  echo.
)

echo.
echo Done


echo.
echo Loading mods from list

if not exist %--mods% (
  echo.
  echo Could not find mods list file in '%--mods%'!
  echo.
  pause
  goto :eof
) 

set "i=0"
for /f %%A in (%--mods%) do (
  set "_id=%%A"
  if not "!_id:~0,2!" == "--" (
::  echo !_id!
    set "Mods[!i!]=!_id!"
    set /a "i+=1"
  )
)

echo.
echo Done


echo.
echo Downloading and Updating Mods
echo.

set "i=0"
:SteamLoop
if defined Mods[%i%] (
  set "list=%list% +workshop_download_item 107410 !Mods[%i%]! validate"
    set /a "i+=1"
    goto :SteamLoop
)

%--steam%\steamcmd.exe +login "%--user%" "%--pass%" %list% +exit

echo.
echo Done


echo.
echo Linking Mods and Keys to SERVER Directory
echo.

set "modDir=%--steam%\steamapps\workshop\content\107410"

:: list of allowed characters to convert the mod name
:: to folder name (yep space is allowed)
set "_ALLOWED=ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789-"
:: replace them with - (why just don't do =-)
set "_REPLWITH=%_ALLOWED:~-1%"

set "i=0"
:LinkLoop
if defined Mods[%i%] (
  for /f usebackq^ tokens^=2^ delims^=^" %%A in (`findstr /C:name "%modDir%\!Mods[%i%]!\meta.cpp"`) do (
    set "_modname=%%~nA"
    call :convrt foldername _modname
    MKLINK /J "%--server%\@!foldername!" "%modDir%\!Mods[%i%]!"
    for %%B IN ("%modDir%\!Mods[%i%]!\keys\*.bikey") DO (
      MKLINK "%--server%\keys\%%~nxB" "%%~B"
    )
  )
  set /a "i+=1"
  goto :LinkLoop
)

echo.
echo Done


echo ========================================================================
echo UPDATED MODS SUSSEFULLY

echo.
echo.
echo.
echo.
echo Author: Jogufe
echo Credits: Joew, tinboye
goto :eof


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: :convrt subroutine to remove a list of not allowed characters and replace
:: them with another character.
::
:: Parameters (passed by reference):
::   %1 (output) variable name
::   %2 (input)  variable name
:: Returns:
::  - any `~` tilde character unchanged ("it's not a bug, it's a feature")
::  - wrong result for any `%` percent sign present in a file name (it's a bug)
:convrt
SETLOCAL enableextensions disabledelayedexpansion
set "__auxAll=%~2"
call set "__auxAll=%%%~2%%"
::echo sub %~2 "%__auxAll%"
set "__result="
:ConvrtLoop
  if "%__auxAll%"=="" goto :EndConvrt
  set "__auxOne=%__auxAll:~0,1%"
  set "__auxAll=%__auxAll:~1%"
  call set "__changed=%%_ALLOWED:%__auxOne%=%%"
  if not "%__changed%"=="%_ALLOWED%" (
    set "__result=%__result%%__auxOne%"
  ) else (
    set "__result=%__result%%_REPLWITH%"
  )
goto :ConvrtLoop

:EndConvrt
::echo sub %~1 "%__result%"
ENDLOCAL&call set "%~1=%__result%"
goto :eof


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: :help subroutine
:help
echo.
echo You can set the following arguments:
echo --user            : Steam username.
echo --pass            : Steam password.
echo --mods            : Path to the text file containing the mods list.
echo --steamcmd        : Path to the folder where steam cmd is installed.
echo --server          : Path to the folder whare Arma 3 Server is installed.
echo.
echo If any of the arguments passed by these parameters contains spaces or any
echo windows spetials characters such as '^^' the argument must be quoted.
echo.
echo.
echo The mods file list txt must contain only one mod ID per line
echo and no extra line or extra space.
echo To Skip a line the line must start with '--'.
echo.
echo Exemple:
echo.
echo modlist.txt
echo --CUP
echo 12345671
echo --Generic weapon mod
echo --125412
echo --I love this mod
echo 69696969
echo.
echo.
pause
goto :eof
