#!/bin/bash

# Check if port is provided
if [ -z "$1" ]; then
  echo "Usage: ./kill-port.sh <port>"
  exit 1
fi

PORT=$1

# Find the process using the port (Windows-style)
PID=$(netstat -ano | grep ":$PORT" | findstr LISTENING | awk '{print $NF}' | head -n 1)

if [ -n "$PID" ]; then
  echo "Killing process on port $PORT (PID: $PID)"
  taskkill //PID $PID //F
else
  echo "No process is listening on port $PORT"
fi
