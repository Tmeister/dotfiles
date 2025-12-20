---
description: Cherry-pick a commit from gemini remote (dry-run first, then apply)
---

Sync commit `$1` from the gemini remote (Tmeister/empower-gemini.git) to the current branch.

## Phase 1: Dry Run (Review)

1. Fetch the latest from gemini remote:
   ```bash
   git fetch gemini
   ```

2. Show the commit metadata:
   ```bash
   git show $1 --stat
   ```

3. Show the full diff so the user can review what will change:
   ```bash
   git show $1 -p
   ```

4. Present a summary:
   - Commit message
   - Files that will be modified/added/deleted
   - Potential conflict areas (if any files were modified in both branches)

5. **ASK FOR APPROVAL** before proceeding to Phase 2. Do NOT continue without explicit user confirmation.

## Phase 2: Apply (Only after approval)

1. Execute the cherry-pick:
   ```bash
   git cherry-pick $1
   ```

2. If there are conflicts:
   - List the conflicted files
   - Show the conflict markers for each file
   - Ask how the user wants to resolve each conflict
   - After the user provides guidance, resolve and stage the files
   - Complete the cherry-pick with a commit

3. If successful, show the result:
   ```bash
   git log --oneline -3
   ```

## Important Rules:
- NEVER proceed to Phase 2 without explicit user approval (e.g., "go", "approved", "yes")
- Always show the full diff during dry run so the user can review all changes
- If conflicts occur, explain them clearly and wait for user decision on each one
- Do not auto-resolve conflicts - always ask for user preference
