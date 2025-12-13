---
description: Clean up merged and stale git branches
---

Clean up merged, stale, and unnecessary git branches safely.

## Steps

1. **Check current state**

   - Run `git status` to ensure working directory is clean
   - Identify the main branch: `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`

2. **Switch to main and update**

   - `git checkout main` (or master)
   - `git pull origin main`

3. **Find merged branches**

   - Local: `git branch --merged main | grep -v "main\|master\|develop\|\*"`
   - Remote: `git branch -r --merged main | grep -v "main\|master\|develop\|HEAD"`

4. **Delete merged local branches**

   - Ask for confirmation before deleting
   - `git branch -d <branch-name>` for each merged branch

5. **Prune remote tracking branches**

   - `git remote prune origin`

6. **Find stale branches** (optional, if requested)

   - List branches with no activity in 30+ days
   - `git for-each-ref --format='%(refname:short) %(committerdate:short)' refs/heads`

7. **Summary**
   - Report what was cleaned up
   - List any branches that couldn't be deleted

**Protected branches** (never delete): main, master, develop, staging, production

$ARGUMENTS
