@echo off
rem First check if all needed commands are available
where /Q curl
IF %ERRORLEVEL%==0 (
  echo Download Dotwebstack
  cd resources
  curl -L https://github.com/dotwebstack/dotwebstack-theatre-legacy/releases/download/v0.0.36/dotwebstack-theatre-legacy-0.0.36.jar -o dotwebstack.jar
) ELSE (
  echo curl not found
)
pause
