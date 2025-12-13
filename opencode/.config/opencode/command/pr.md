---
description: Create a pull request with minimal body
---

Prepare and create a PR for the current branch.

## Steps

1. **Check branch status**

   ```bash
   git status
   git log origin/main..HEAD --oneline
   ```

2. **Ensure branch is up to date**

   ```bash
   git fetch origin main
   git rebase origin/main
   ```

3. **Push branch if needed**

   ```bash
   git push -u origin $(git rev-parse --abbrev-ref HEAD)
   ```

4. **Generate PR title**

   - Use conventional format: `type(scope): brief description`
   - Or extract from the main commit message

5. **Create PR with minimal body**

   ```bash
   gh pr create --title "title here" --body ""
   ```

   Note: Keep the body minimal or empty - CodeRabbit will add all the details.

6. **Open PR in browser** (optional)
   ```bash
   gh pr view --web
   ```

**Flags:**

- `--draft`: Create as draft PR
- `--target <branch>`: Target branch (default: main)

$ARGUMENTS
