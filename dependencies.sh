#!/bin/bash

# Update the package manager's list of available packages
sudo apt-get update

# Install bash, awk, and samtools
sudo apt-get install bash awk samtools

# Check if the dependencies were installed successfully
if [ $? -eq 0 ]; then
  # Dependencies were installed successfully
  echo "Dependencies were installed successfully."
else
  # An error occurred while installing the dependencies
  echo "An error occurred while installing the dependencies."
fi
