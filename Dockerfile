FROM ghcr.io/jpfulton/danger-js-action/base:latest

# Set maintainer
LABEL maintainer="J. Patrick Fulton"

# Set labels for GHCR
LABEL "com.github.actions.name"="danger-js-action"
LABEL "com.github.actions.description"="Runs JavaScript/TypeScript Dangerfiles with a collection of plugins."
LABEL "com.github.actions.icon"="green-square"
LABEL "com.github.actions.color"="green"

ENTRYPOINT [ "bash", "/action/workspace/entrypoint.sh"]