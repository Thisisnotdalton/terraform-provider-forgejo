#!/bin/bash
set -e
FORGEJO_USER="git"
FORGEJO_DIR="/data/gitea"
FORGEJO_CONFIG_DIR="${FORGEJO_DIR}/conf"
mkdir -p "$FORGEJO_CONFIG_DIR"
FORGEJO_CONFIG_FILE_PATH="${FORGEJO_CONFIG_DIR}/app.ini"
if [ ! -f "$FORGEJO_CONFIG_FILE_PATH" ]; then
  cp /initial_config/app.ini "$FORGEJO_CONFIG_FILE_PATH"
  chown -R "$FORGEJO_USER" "$FORGEJO_DIR"
  echo "Attempting to migrate databases."
  su -c "forgejo migrate" $FORGEJO_USER
  su -c "forgejo admin user create --admin --email ${ADMIN_EMAIL} --username ${ADMIN_USER} --password ${ADMIN_PASSWORD}" $FORGEJO_USER
  TOKEN_NAME="admin_token"
  TOKEN_FILE_PATH="/access_tokens/env.${TOKEN_NAME}"
  TOKEN=$(su -c "forgejo admin user generate-access-token --raw --username ${ADMIN_USER} --token-name ${TOKEN_NAME}" $FORGEJO_USER)
  echo "FORGEJO_API_TOKEN=${TOKEN}" > $TOKEN_FILE_PATH
fi