#!/usr/bin/env bash

# exit immediately when a command fails
set -e
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail
# error on unset variables
set -u


curl -sk --resolve "domain2.example.com:${PORT_PROXY}:127.0.0.1" \
   "https://domain2.example.com:${PORT_PROXY}"