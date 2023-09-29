#!/bin/bash

DANGERFILE="$1";
DEBUG_MODE="$2";
GITHUB_TOKEN="$3";

echo "DangerJS Github Action";
echo "---";

if [ -n "${DANGERFILE}" ]; 
  then
    echo "Dangerfile: ${DANGERFILE}";
  else
    echo "No dangerfile specified. Exiting with error...";
    exit 1;
fi

if [ -n "${DEBUG_MODE}" ] && [ "${DEBUG_MODE}" = "true" ]; 
  then
    echo "Contents of working directory:";
    echo "---";
    ls -la;
    echo "---";
    echo;

    echo "Contents of the container action directory:";
    echo "---";
    ls -la /github/workspace;
    echo "---";
fi