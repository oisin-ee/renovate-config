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

## Copier template updates

The preset enables Renovate's built-in [`copier` manager](https://docs.renovatebot.com/modules/manager/copier/).
Any consuming repo stamped from `momokaya-template` (i.e. it has a `.copier-answers.yml` with
`_src_path: gh:oisin-ee/momokaya-template`) gets a `copier update` PR each time the template
publishes a new PEP-440 git tag. Renovate reads `_commit` as the current version and bumps it to
the template's latest tag via the `git-tags` datasource.

Copier stores its `gh:`/`gl:` shorthand verbatim in `_src_path` — it only expands the shorthand to
a real clone URL internally when it runs `git`. Renovate's `git-tags` datasource does not do that
expansion; it passes `packageName` straight to `git ls-remote`, so a bare `gh:oisin-ee/...` would
fail to resolve. A `packageRules` entry rewrites `gh:`-prefixed `_src_path` values to
`https://github.com/...` before the datasource looks them up.

**Guardrail: Copier updates never automerge.** A `packageRules` entry pins
`automerge: false` for `matchManagers: ["copier"]`, overriding whatever automerge policy the rest
of this preset carries. This exists because of a known Renovate wart
([renovatebot/renovate#31590](https://github.com/renovatebot/renovate/discussions/31590)): when a
`copier update` produces merge conflicts, Renovate does not treat that as a failure — it commits
the file with raw `<<<<<<<`/`=======`/`>>>>>>>` conflict markers left in place and opens (or
automerges, if enabled) the PR anyway. Renovate's maintainers confirmed this is intentional
behavior, not a bug, and that automerge must not be used "unless you have tests which can
test/validate the PR contents." A human must review every Copier update PR for stray conflict
markers before merging.

**Status: PENDING-FIRST-STAMP.** As of this writing there are zero `momokaya-template`-stamped
repos in the fleet, so this manager has not yet produced a live update PR in a real repo. The
manager and datasource resolution were verified with a local Renovate `--platform=local`
dry-run fixture: it detected a `.copier-answers.yml` pinned to `_commit: v1.0.0` and correctly
resolved the live `momokaya-template` tags, proposing an update to `v1.1.0` — see the ENG-30
ticket notes for the fixture and output.

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
