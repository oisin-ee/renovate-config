#!/usr/bin/env bash
set -euo pipefail

readonly package_settings_url='https://github.com/orgs/oisin-ee/packages/container/charts%2Fmomokaya-chart/settings'

if [[ "$(uname -s)" != 'Darwin' ]]; then
  printf 'This helper currently supports macOS only.\n' >&2
  exit 1
fi

printf '%s\n' \
  'Opening the momokaya-chart GHCR package settings in your default personal browser.' \
  '' \
  'In GitHub:' \
  '  1. Under Repository source, connect the package to oisin-ee/momokaya-chart.' \
  '  2. Under Manage access, enable "Inherit access from repository".' \
  '  3. Confirm that the package remains Private.' \
  '' \
  'This grants oisin-bot package read access through its existing repository permission.' \
  'Return to the agent after GitHub confirms the changes.'

open "$package_settings_url"
