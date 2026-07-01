# oisin-ee/renovate-config

Shared [Renovate](https://docs.renovatebot.com/) preset for every oisin-ee TypeScript repo.

It exists so all repos stay on **one identical toolchain** — the same TS7 + ultracite/oxc
stack, at the same pinned versions — without hand-syncing `package.json` across repos.

## The standardized stack

| package | role |
| --- | --- |
| `@typescript/native-preview` | TypeScript 7 native compiler (tsgo) |
| `typescript` | JS `tsc` (RC) — kept alongside tsgo during the preview |
| `ultracite` | zero-config linter/formatter presets driving oxlint + oxfmt |
| `oxlint` | linter |
| `oxfmt` | formatter |
| `oxlint-tsgolint` | type-aware oxlint plugin |

## What the preset does

- **Pins exact versions** (`rangeStrategy: pin`) — no floating `^` or `rc` tag drift.
- **Groups the whole toolchain into one PR** (`groupName: oisin-ee toolchain`) so the six
  packages always move in lockstep; a repo is never half-upgraded.
- **Allows prerelease bumps** for the pre-stable members (`typescript` rc, tsgo dev builds,
  `oxfmt` beta) so the group can track the preview forward and flip to GA when it lands.
- Runs on a weekly schedule (`before 6am on monday`).

## Usage

Add a `renovate.json` at the root of each consuming repo:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["github>oisin-ee/renovate-config"]
}
```

Renovate resolves `github>oisin-ee/renovate-config` to this repo's root `default.json`.

## Prerequisite

The **Renovate GitHub App** must be installed on the `oisin-ee` org (or self-hosted Renovate
pointed at it) for any of this to run. Installing the app is a one-time org-admin action:
<https://github.com/apps/renovate>.
