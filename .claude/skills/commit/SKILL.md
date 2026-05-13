---
name: commit
description: After committing in the Canva repo on branch ff-canva, run master-resync to promote shared commits onto the main branch and rebuild ff-canva. Use when a commit just landed on ff-canva, when the user asks to sync after commit, or when finishing work on the FF Canva branch.
---

## When to use

Use this skill **after** a successful commit when the active git repository is the **Canva** checkout (not dotfiles or other repos).

## What to run

Run [post-commit-resync.sh](post-commit-resync.sh) with bash. Resolve it from this skill directory (same folder as this file) or from the dotfiles repo root.

From inside the Canva checkout (so `git rev-parse --show-toplevel` is that repo):

```bash
bash "${DOTFILES:-$HOME/dotfiles}/.claude/skills/commit/post-commit-resync.sh"
```

If the shell cwd is not inside the Canva repo, pass the checkout path as the first argument:

```bash
bash "${DOTFILES:-$HOME/dotfiles}/.claude/skills/commit/post-commit-resync.sh" /path/to/canva
```

The runner is [post-commit-resync.sh](post-commit-resync.sh). It exits with a clear message if the branch is not `ff-canva`. It sets `MASTER_RESYNC_REPO_ROOT` and runs [canva/master-resync.sh](../../../canva/master-resync.sh), which also requires a clean working tree and being on `ff-canva`.

## After it runs

Summarize stdout and stderr. If the script exits non-zero, paste the error and suggest fixes (wrong branch, dirty tree, missing `ff-canva`, network or push failures).
