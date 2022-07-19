#!/usr/bin/env bash

set -e
[ -n "$NODENV_DEBUG" ] && set -x

if declare -Ff after_install > /dev/null; then
  after_install run_after_install
else
  echo "nodenv: nodenv-yarn-pnpm-install plugin requires node-build" >&2
fi

run_after_install() {
  local node_version
  local yarn_status
  local yarn_version
  local pnpm_status
  local pnpm_version

  # Only if successfully installed Node.
  [ "$STATUS" = "0" ] || return 0
  echo "Installing Yarn & Pnpm..."

  node_version=$(NODENV_VERSION="$DEFINITION" nodenv-exec node -v)
  if [[ "$node_version" =~ ^v[0-3]\. ]]; then
    echo "Node version ${node_version/v/} is not supported, please use Node.js 4.0 or higher." >&2
    return 0
  fi

  yarn_status=0
  pnpm_status=0
  NODENV_VERSION="$DEFINITION" nodenv-exec npm install yarn -g --silent || yarn_status="$?"
  NODENV_VERSION="$DEFINITION" nodenv-exec npm install pnpm -g --silent || pnpm_status="$?"

  if [ "$yarn_status" == "0" ]; then
    yarn_version=$(NODENV_VERSION="$DEFINITION" nodenv-exec yarn --version)
    echo "Installed Yarn $yarn_version"
  fi

  if [ "$pnpm_status" == "0" ]; then
    pnpm_version=$(NODENV_VERSION="$DEFINITION" nodenv-exec pnpm --version)
    echo "Installed Pnpm $pnpm_version"
  fi
}

