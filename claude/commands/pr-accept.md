# PR Accept Command

Accept and merge a pull request with a short, concise commit message.

## Usage

```bash
pr-accept <pr-number>
pr-accept #12
```

Arguments: **$ARGUMENTS**

## Instructions

Follow these steps to accept and merge a PR:

1. **Parse PR Number**
   - Extract PR number from arguments (handle both `12` and `#12` formats)
   - Remove the `#` if present

2. **Fetch PR Details**
   - Run `gh pr view <pr-number> --json title,body,headRefName` to get PR information
   - Review the PR title and description to understand the changes

3. **Generate Commit Message**
   - Create a short, concise merge commit message (1-2 lines max)
   - Base the message on the PR title and key changes
   - Keep it clean and focused on what was merged
   - Format: Brief description of what was merged

4. **Merge the PR**
   - Execute `gh pr merge <pr-number> --merge --body "commit message"`
   - The `--merge` flag creates a merge commit (not squash or rebase)
   - Use the generated commit message as the merge commit body

5. **Confirm Success**
   - Verify the PR was successfully merged
   - Display the merge commit details
