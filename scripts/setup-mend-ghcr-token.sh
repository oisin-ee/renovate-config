#!/usr/bin/env bash
set -euo pipefail

readonly github_token_url='https://github.com/settings/tokens/new?scopes=read%3Apackages'
readonly mend_url='https://developer.mend.io/'

if [[ "$(uname -s)" != 'Darwin' ]]; then
  printf 'This helper currently supports macOS only.\n' >&2
  exit 1
fi

printf '%s\n' \
  'Opening the GitHub token page and Mend Developer Platform in your default personal browser.' \
  '' \
  'In GitHub:' \
  '  1. Switch to the oisin-bot account if necessary.' \
  '  2. Name the classic token "Mend Renovate GHCR read-only".' \
  '  3. Keep only the preselected read:packages scope.' \
  '  4. Generate and copy the token.' \
  '' \
  'In Mend:' \
  '  1. Sign in with GitHub and open the oisin-ee organization settings.' \
  '  2. Open Credentials and choose Add Secret.' \
  '  3. Set the secret name to GHCR_TOKEN.' \
  '  4. Paste the plaintext token and save it.' \
  '' \
  'Return to the agent after Mend confirms that the secret was stored.'

open "$github_token_url"
open "$mend_url"
