---
description: Cherry-pick a commit from gemini remote to sync-upstream branch
---

Cherry-pick commit `$1` from the gemini remote to the `sync-upstream` branch.

## Pre-flight Checks

1. Ensure working directory is clean:
   ```bash
   git status --porcelain
   ```
   If not clean, STOP and ask user to commit or stash changes.

2. Fetch latest from gemini remote:
   ```bash
   git fetch gemini
   ```

## Prepare sync-upstream Branch

1. Checkout main and pull latest:
   ```bash
   git checkout main && git pull origin main
   ```

2. Reset sync-upstream to match main (clean slate):
   ```bash
   git branch -f sync-upstream main
   ```

3. Checkout sync-upstream:
   ```bash
   git checkout sync-upstream
   ```

## Phase 1: Dry Run (Review)

1. Show the commit metadata:
   ```bash
   git show $1 --stat
   ```

2. Show the full diff so the user can review what will change:
   ```bash
   git show $1 -p
   ```

3. Present a summary:
   - Commit message
   - Files that will be modified/added/deleted
   - Potential conflict areas (compare with current branch)

4. **ASK FOR APPROVAL** before proceeding to Phase 2. Do NOT continue without explicit user confirmation.

## Phase 2: Apply (Only after approval)

1. Execute the cherry-pick:
   ```bash
   git cherry-pick $1
   ```

2. If there are conflicts:
   - List the conflicted files:
     ```bash
     git diff --name-only --diff-filter=U
     ```
   - For each conflicted file, show the conflict
   - Ask user how to resolve. Suggest "theirs" as the default since changes from gemini are typically preferred
   - After user provides guidance, resolve and stage the files
   - Complete the cherry-pick:
     ```bash
     git cherry-pick --continue
     ```

3. If successful, show the result:
   ```bash
   git log --oneline -5
   git status
   ```

## Important Rules

- NEVER proceed to Phase 2 without explicit user approval
- Always show the full diff during dry run
- If conflicts occur, suggest "theirs" but always ask for user decision
- The sync-upstream branch is now ready for review/testing before merging to main
- Remind user they can run `/gemini-release` when ready to merge to main
