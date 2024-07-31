@echo off
title Universal FFMPEG Converter
setlocal
chcp 65001 >nul

set "FFMPEG_PATH=C:\ffmpeg\bin\ffmpeg.exe"
set "YOUTUBE_DL_PATH=C:\youtube-dl\youtube-dl.exe"  rem imma make the source open source to allow ppl to change this
rem click or drag check
if "%~1"=="" (
    echo Please drag an audio/media file to continue the process!
    echo Ignore the bad code :(
    echo Written by @humbleness on Discord
    pause
    exit /b 1
)

:menu
cls
echo ======================================================
echo              Universal FFMPEG Converter
echo ======================================================
echo 1. Convert local files to OPUS
echo 2. Download MP3 from YouTube [BROKEN ATM]
echo ======================================================
set /p "CHOICE=Please enter your choice (1 or 2): "

if "%CHOICE%"=="1" goto :local_files
if "%CHOICE%"=="2" goto :youtube_dl

echo Invalid choice. Please enter 1 or 2.
pause
goto :menu

:local_files
cls
if "%~1"=="" (
    echo ======================================================
    echo Please drag and drop audio/video files onto this script.
    echo ======================================================
    pause
    exit /b 1
)

echo ======================================================
echo You selected to convert local files to OPUS.
echo ======================================================
set /p "EXPORT_DIR=Enter the output directory (default is Desktop\export): "

rem set default export dir
if "%EXPORT_DIR%"=="" (
    set "EXPORT_DIR=%USERPROFILE%\Desktop\export"
)

if not exist "%FFMPEG_PATH%" (
    echo ffmpeg not found at "%FFMPEG_PATH%"
    pause
    exit /b 1
)

if not exist "%EXPORT_DIR%" (
    mkdir "%EXPORT_DIR%"
)

set "LOG_FILE=%EXPORT_DIR%\log.txt"
set "ERROR_LOG=%EXPORT_DIR%\error_log.txt"
(
    echo /**************************************************/
    echo /*                Conversion Log                  */
    echo /*------------------------------------------------*/
    echo /*      Created By @humbleness On Discord         */
    echo /**************************************************/
    echo ====================LOGS BELOW======================
    echo.
    echo.
    echo Check The "error_log.txt" For More Details About The Conversion
) > "%LOG_FILE%"
echo Errors: > "%ERROR_LOG%"

:loop
if "%~1"=="" goto :endloop

set "input_file=%~1"
set "filename=%~n1"
set "extension=%~x1"

set "output_file=%EXPORT_DIR%\%filename%.opus"

"%FFMPEG_PATH%" -i "%input_file%" -c:a libopus "%output_file%" >> "%LOG_FILE%" 2>> "%ERROR_LOG%"

if %ERRORLEVEL% EQU 0 (
    echo Conversion successful: "%output_file%" >> "%LOG_FILE%"
) else (
    echo Conversion failed for: "%input_file%" >> "%ERROR_LOG%"
)

shift
goto loop

:endloop
echo ======================================================
echo Conversion completed. Check the log file for details: "%LOG_FILE%"
echo Errors (if any) are logged in: "%ERROR_LOG%"
echo ======================================================
pause
endlocal
exit /b 0

:youtube_dl
cls
echo ======================================================
echo You selected to download MP3 from YouTube.
echo ======================================================
set /p "YOUTUBE_URL=Enter the YouTube URL to download MP3 from: "
set /p "EXPORT_DIR=Enter the output directory (default is Desktop\export): "

rem sets default download dir if provided
if "%EXPORT_DIR%"=="" (
    set "EXPORT_DIR=%USERPROFILE%\Desktop\export\(ext)s.%(ext)s"
)

if not exist "%YOUTUBE_DL_PATH%" (
    echo youtube-dl not found at "%YOUTUBE_DL_PATH%"
    pause
    exit /b 1
)

if not exist "%EXPORT_DIR%" (
    mkdir "%EXPORT_DIR%"
)

set "LOG_FILE=%EXPORT_DIR%\log.txt"
set "ERROR_LOG=%EXPORT_DIR%\error_log.txt"
(
    echo /**************************************************/
    echo /*                Download Log                    */
    echo /*------------------------------------------------*/
    echo /*      Created By @humbleness On Discord         */
    echo /**************************************************/
    echo ====================LOGS BELOW======================
    echo.
) > "%LOG_FILE%"
echo Errors: > "%ERROR_LOG%"

rem downloader function is BROKEN. i need to fix this
"%YOUTUBE_DL_PATH%" -x --audio-format mp3 -o "%EXPORT_DIR%\%(title)s.%(ext)s" "%YOUTUBE_URL%" >> "%LOG_FILE%" 2>> "%ERROR_LOG%" 

if %ERRORLEVEL% EQU 0 (
    echo Download successful: "%YOUTUBE_URL%" >> "%LOG_FILE%"
) else (
    echo Download failed for: "%YOUTUBE_URL%" >> "%ERROR_LOG%"
)

echo ======================================================
echo Download and conversion completed. Check the log file for details: "%LOG_FILE%"
echo Errors (if any) are logged in: "%ERROR_LOG%"
echo ======================================================
pause
endlocal
exit /b 0