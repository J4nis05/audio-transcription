#!/bin/bash

# Redirect logs to stdout and stderr for Docker log capture
python worker.py > >(tee /proc/1/fd/1) 2> >(tee /proc/1/fd/2) &
WORKER_PID=$!

python main.py > >(tee /proc/1/fd/1) 2> >(tee /proc/1/fd/2) &
MAIN_PID=$!

# Wait for any process to exit
wait -n

# Exit with the status of the process that exited first
if wait $WORKER_PID; then
  exit $?
else
  wait $MAIN_PID
  exit $?
fi
