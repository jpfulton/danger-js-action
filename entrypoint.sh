#!/bin/bash

DANGERFILE="$1";

echo "DangerJS Github Action";
echo "---";

if [ -n "${DANGERFILE}" ]; 
  then
    echo "Dangerfile: ${DANGERFILE}";
  else
    echo "No dangerfile specified. Exiting with error...";
    exit 1;
fi

echo "Contents of working directory:";
echo "---";
ls -la;
echo "---";