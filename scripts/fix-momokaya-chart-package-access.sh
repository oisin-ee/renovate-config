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
  '  1. Under Manage Actions access, choose Add Repository and add momokaya-chart.' \
  '  2. Under Manage access, choose Invite teams or people and add oisin-bot.' \
  '  3. Set oisin-bot to the Read role.' \
  '  4. Leave Codespaces access and package visibility unchanged.' \
  '' \
  'The first step restores the publisher workflow access that was removed.' \
  'The second and third steps directly grant the Mend credential owner package read access.' \
  'Return to the agent after GitHub confirms both changes.'

open "$package_settings_url"
