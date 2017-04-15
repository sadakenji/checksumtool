@echo off

rem FileName: ckmd5.bat
rem http://norastep.hatenablog.com/entry/2016/10/05/002304

if "%~1" == "" (
  echo Usage: %~n0 FILE...
  exit /b 0
)

setlocal
set CmdName=CertUtil
set HashMethod=MD5

set ERROR_OCCUR=0
for /f "tokens=1,2" %%i in (%~1) do call :CheckFileHash "%%~i" "%%~j"
if %ERROR_OCCUR% == 1 (
	echo 比較に失敗しました。
) else (
	echo 比較に成功しました。
)
exit /b 0

:CheckFileHash
set Hash=
for /f "usebackq delims=" %%h in (`%CmdName% -hashfile "%~2" %HashMethod% ^| find /v "%HashMethod%" ^| find /v "%CmdName%:"`) do set Hash=%%h
if "%Hash%" == "" if "%~z1" == "0" (
	set Hash=d41d8cd98f00b204e9800998ecf8427e
) else (
	exit /b 0
)
set Hash=%Hash: =%
if not "%Hash%" == "%~1" (
	echo ERROR %~2 "%Hash%" [MUST BE: %~1]
	set ERROR_OCCUR=1
)
exit /b 0
