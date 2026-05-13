---
name: commit
description: On dotfiles branch ff-canva, the agent commits staged work with git, then runs post-commit-resync so main picks up shared commits and ff-canva ends as origin main plus exactly one personal marker commit. Use when the user asks to commit, /commit, or finish ff-canva work in this repo.
---

## When to use

Use in **this dotfiles repo** when the user wants to land work from **`ff-canva`**: changes become a **git commit** you create yourself, then run [post-commit-resync.sh](post-commit-resync.sh) so **`origin/$(git mb)`** gets the shared commits and **`ff-canva`** is **rebased on that remote mainline with exactly one commit on top** (the local-only marker commit, for example copy that mentions Canva or machine setup).

If the user **already committed** and only needs the resync, skip straight to **post-commit-resync.sh**.

## Primary flow (you commit, then script resyncs)

1. Confirm repo is **this dotfiles checkout**, branch is **`ff-canva`**, and the working tree is ready (stage with `git add` as needed).
2. Create the commit yourself: **`git commit -m "..."`** (use a clear, complete sentence; avoid leaving the editor open in automation).
3. With a **clean** working tree after that commit, run:

```bash
bash "${DOTFILES:-$HOME/dotfiles}/.claude/skills/commit/post-commit-resync.sh"
```

If cwd is not inside the repo, pass the dotfiles root:

```bash
bash "${DOTFILES:-$HOME/dotfiles}/.claude/skills/commit/post-commit-resync.sh" "$HOME/dotfiles"
```

[post-commit-resync.sh](post-commit-resync.sh) runs [canva/master-resync.sh](../../../canva/master-resync.sh), which requires **clean** tree and **ff-canva**.

## What success looks like

- **`master-resync`** promoted any extra commits from `ff-canva` onto **`$(git mb)`**, pushed that branch, then reset **`ff-canva`** to **`origin/$(git mb)`** and replayed the **oldest** ff-canva-only commit (the personal marker).
- After a full run, **`ff-canva`** must be **exactly one commit** ahead of **`origin/$(git mb)`**; `master-resync` checks this and fails if not.

## After it runs

Summarize stdout and stderr. If anything exits non-zero, paste the error and suggest fixes (wrong branch, dirty tree, not this repo, missing `ff-canva`, network or push failures).
