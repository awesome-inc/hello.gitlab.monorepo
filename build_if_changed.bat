@echo off
setlocal
set folder=%1

call changes.bat %folder%
if "%ERRORLEVEL%"=="1" (
  echo Skipping build for '%folder%'.
  exit /B 0
)

echo.
echo Building '%folder%'...
for /f "tokens=1,* delims= " %%a in ("%*") do set command=%%b
echo Executing '%command%'...
echo.
pushd %folder%
call %command%
set exitCode=%ERRORLEVEL%
popd

exit /B %exitCode%
endlocal
