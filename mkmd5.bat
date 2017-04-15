@echo off
rem FileName: mkmd5.bat
rem based on:
rem http://norastep.hatenablog.com/entry/2016/10/05/002304

if "%~1" == "" (
  echo Usage: %~n0 PATH
  exit /b 0
)

setlocal
pushd "%~1"
set CmdName=CertUtil
set HashMethod=MD5

call :countPathLevel %cd%

for /f "delims=\ tokens=%level%*" %%i in ('dir /S /B /A-D') do call :PrintFileHash "%%~j"
exit /b 0

:PrintFileHash
set Hash=
for /f "usebackq delims=" %%h in (`%CmdName% -hashfile "%~1" %HashMethod% ^| find /v "%HashMethod%" ^| find /v "%CmdName%:"`) do set Hash=%%h
if "%Hash%" == "" if "%~z1" == "0" (
	set Hash=d41d8cd98f00b204e9800998ecf8427e
) else (
	exit /b 0
)
set Hash=%Hash: =%
echo %Hash% %~1
exit /b 0

:countPathLevel
set level=0
call :countPathLevel0 %1
exit /B

:countPathLevel0
if "%1"=="" exit /B
for /f "delims=\ tokens=1*" %%i in ("%1") do (
	set /A level=%level%+1
	call :countPathLevel0 %%j
)
exit /B
