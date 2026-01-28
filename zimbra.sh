#!/bin/bash

# Define the handler function for cleanup
_term() {
  echo "Caught SIGTERM signal! Cleaning up..."
  # Perform cleanup tasks here
  exit 0
}

# Trap SIGTERM and call the _term function
trap _term SIGTERM

echo "Script running. Waiting for SIGTERM..."

# Run a background process and wait for it, or just wait
sleep infinity &
wait $!
