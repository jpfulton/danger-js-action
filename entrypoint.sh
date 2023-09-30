#!/bin/bash

# Collect arguments from action input variables to local variables
DANGERFILE="$1";
DEBUG_MODE="$2";
GITHUB_TOKEN="$3";

# Set local constants
ACTION_WORKSPACE_DIR="/action/workspace";
GITHUB_WORKSPACE_DIR="/github/workspace";

echo "DangerJS Github Action";
echo "---";

if [ -n "${DEBUG_MODE}" ] && [ "${DEBUG_MODE}" = "true" ]; 
  then
    echo "DEBUG_MODE: ${DEBUG_MODE}";
    echo "GITHUB_TOKEN: ${GITHUB_TOKEN}";
    echo "---";
fi

if [ -n "${DANGERFILE}" ]; 
  then
    echo "Dangerfile: ${DANGERFILE}";

    # Ensure the dangerfile is a .ts file
    if [[ "${DANGERFILE}" != *.ts ]]; 
      then
        echo "Dangerfile is not a .ts file. Exiting with error...";
        exit 1;
    fi

    # Determine if the DANGERFILE is a local file or a remote file
    if [[ "${DANGERFILE}" == http* ]]; 
      then
        echo "Dangerfile is a remote URL.";
        echo "Downloading Dangerfile from remote URL...";

        # Download the Dangerfile from the remote URL to the action workspace directory
        # -s: silent, -S: show errors, -L: follow redirects
        curl -sSL "${DANGERFILE}" > "${ACTION_WORKSPACE_DIR}/dangerfile.ts";

        # Check if the download was successful
        if [ $? -eq 0 ]; 
          then
            echo "Dangerfile downloaded successfully.";
          else
            echo "Dangerfile download failed. Exiting with error...";
            exit 1;
        fi
      else
        echo "Dangerfile is a local file.";
        echo "Copying Dangerfile from local path...";
        cp "${DANGERFILE}" "${ACTION_WORKSPACE_DIR}/dangerfile.ts";
    fi
  else
    echo "No dangerfile specified. Exiting with error...";
    exit 1;
fi

if [ -n "${DEBUG_MODE}" ] && [ "${DEBUG_MODE}" = "true" ]; 
  then
    echo "Contents of current working directory:";
    echo "---";
    # Should be equal to /github/workspace ($GITHUB_WORKSPACE_DIR)
    # See documentation: https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions
    echo "PWD: $(pwd)";
    echo "---";
    ls -la;
    echo "---";
    echo;

    echo "Contents of the container action working directory:";
    echo "---";
    ls -la ${ACTION_WORKSPACE_DIR};
    echo "---";
fi

echo "Running DangerJS...";
echo "---";
cd ${ACTION_WORKSPACE_DIR};

# Set the GITHUB_TOKEN environment variable for DangerJS
export GITHUB_TOKEN=${GITHUB_TOKEN};

# Run DangerJS using the Dangerfile specified by action inputs
# --verbose: show verbose output
# --failOnErrors: fail if DangerJS reports errors
# --newComment: create a new comment on the PR
# --removePreviousComments: remove previous comments from DangerJS
yarn danger ci \
  --verbose \
  --failOnErrors \
  --newComment \
  --removePreviousComments;