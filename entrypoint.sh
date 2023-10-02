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
    echo "---";
fi

# Check if the GITHUB_TOKEN environment variable is set
# and is not an empty string
if [ -z "${GITHUB_TOKEN}" ] || [ "${GITHUB_TOKEN}" = "" ]; 
  then
    echo "GITHUB_TOKEN environment variable is not set. Exiting with error...";
    exit 1;
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
cd ${GITHUB_WORKSPACE_DIR};

# Run DangerJS
if [ -n "${DEBUG_MODE}" ] && [ "${DEBUG_MODE}" = "true" ];
  then
    echo "Running DangerJS in DEBUG mode...";
    # Set the DEBUG environment variable to * to show all debug output
    # Use the --verbose flag to show verbose output
    DEBUG="*" \
    GITHUB_TOKEN=$GITHUB_TOKEN \
    danger ci \
      --verbose \
      --failOnErrors \
      --useGithubChecks \
      --dangerfile ${ACTION_WORKSPACE_DIR}/dangerfile.ts;
  else
    # Run without DangerJS DEBUG output and without verbose output flag
    GITHUB_TOKEN=$GITHUB_TOKEN \
    danger ci \
      --failOnErrors \
      --useGithubChecks \
      --dangerfile ${ACTION_WORKSPACE_DIR}/dangerfile.ts;
fi