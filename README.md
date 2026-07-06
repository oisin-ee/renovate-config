# oisin-ee/renovate-config

Shared [Renovate](https://docs.renovatebot.com/) preset for every oisin-ee TypeScript repo.

It exists so all repos use the same dependency update policy for the TS7 + ultracite/oxc stack,
without hand-syncing `package.json` across repos.

## The standardized stack

| package | role |
| --- | --- |
| `@typescript/native-preview` | TypeScript 7 native compiler (tsgo) |
| `typescript` | JS `tsc` (RC) — kept alongside tsgo during the preview |
| `ultracite` | zero-config linter/formatter presets driving oxlint + oxfmt |
| `@oisin-ee/oxlint-config` | shared strict type-aware oxlint preset layered on ultracite |
| `@oisin-ee/momokaya-contract` | versioned Momokaya environment/runtime contract |
| `@oisin-ee/momokaya-agent-auth` | Momokaya agent-auth credential broker integration |
| `oxlint` | linter |
| `oxfmt` | formatter |
| `oxlint-tsgolint` | type-aware oxlint plugin |

## What the preset does

- **Pins exact versions** (`rangeStrategy: pin`) — no floating `^` or `rc` tag drift.
- **Opens per-package bump PRs as packages publish** so a single stalled toolchain package does not
  block unrelated updates.
- **Resolves private `@oisin-ee/*` packages from GitHub tags** (`github-tags`) instead of the npm
  registry; the repos publish version tags like `v1.3.3`, which Renovate normalizes to `1.3.3`.
- **Allows prerelease bumps** for the pre-stable members (`typescript` rc, tsgo dev builds,
  `oxfmt` beta) so the group can track the preview forward and flip to GA when it lands.

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
