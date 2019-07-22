#!/usr/bin/env bash
# First check if all needed commands are available
if hash curl 2>/dev/null; then
  echo Download Dotwebstack
  cd resources
  curl -L https://github.com/dotwebstack/dotwebstack-theatre-legacy/releases/download/v0.0.36/dotwebstack-theatre-legacy-0.0.36.jar -o dotwebstack.jar
else
  echo "Error: curl not found"
fi
