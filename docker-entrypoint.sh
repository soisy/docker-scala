#!/bin/sh
# Get standard cli USER_ID variable
USER_ID=${HOST_USER_ID:-1000}
GROUP_ID=${HOST_GROUP_ID:-1000}
# Change 'me' uid to host user's uid
echo "Running as ${GROUP_ID}:${USER_ID}"

if [ ! -z "$USER_ID" ] && [ "$(id -u me)" != "$USER_ID" ]; then
    # Create the user group if it does not exist
    groupadd --non-unique -g "$GROUP_ID" me
    # Set the user's uid and gid
    usermod --non-unique --uid "$USER_ID" --gid "$GROUP_ID" me
fi

# Setting permissions on docker.sock

# zsh shell
su-exec me $@
