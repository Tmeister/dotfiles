---
description: Merge sync-upstream into main, tag, and push
---

Merge the `sync-upstream` branch into `main`, create a version tag, and push to origin.

## Pre-flight Checks

1. Ensure working directory is clean:
   ```bash
   git status --porcelain
   ```
   If not clean, STOP and ask user to commit or stash changes.

2. Verify sync-upstream has commits ahead of main:
   ```bash
   git log main..sync-upstream --oneline
   ```
   If no commits, inform user there's nothing to merge.

## Merge sync-upstream into main

1. Checkout main:
   ```bash
   git checkout main
   ```

2. Pull latest from origin:
   ```bash
   git pull origin main
   ```

3. Attempt plain merge:
   ```bash
   git merge sync-upstream
   ```

4. If there are conflicts:
   - List the conflicted files:
     ```bash
     git diff --name-only --diff-filter=U
     ```
   - For each conflicted file, show the conflict markers
   - Ask user how to resolve. Suggest "theirs" (sync-upstream version) as the default
   - After user provides guidance, resolve and stage the files
   - Complete the merge:
     ```bash
     git commit -m "Merge sync-upstream into main"
     ```

5. Show merge result:
   ```bash
   git log --oneline -5
   ```

## Create Version Tag

1. Get the latest tag and suggest next version:
   ```bash
   git tag -l --sort=-v:refname | head -1
   ```

2. Analyze the changes to determine version bump:
   ```bash
   git log $(git tag -l --sort=-v:refname | head -1)..HEAD --oneline
   git diff $(git tag -l --sort=-v:refname | head -1)..HEAD --stat
   ```

3. Determine version increment based on changes:
   - **MAJOR** (x.0.0): Breaking changes, major rewrites, incompatible API changes
   - **MINOR** (0.x.0): New features, new pages, significant enhancements
   - **PATCH** (0.0.x): Bug fixes, small tweaks, copy changes, asset updates

4. Present the suggested version and ASK FOR CONFIRMATION:
   - Show current version
   - Show suggested next version with reasoning
   - Allow user to override

5. Create annotated tag:
   ```bash
   git tag -a vX.Y.Z -m "vX.Y.Z: brief description of changes"
   ```

## Push to Origin

1. Push main branch:
   ```bash
   git push origin main
   ```

2. Push the new tag:
   ```bash
   git push origin vX.Y.Z
   ```

3. Show final status:
   ```bash
   git log --oneline -3
   git tag -l --sort=-v:refname | head -3
   ```

## Important Rules

- Always ask for confirmation before creating the tag
- Analyze changes to suggest appropriate version bump
- If no previous tags exist, suggest v1.0.0
- Include a brief, meaningful message in the annotated tag
- Report the final state so user can verify everything succeeded
