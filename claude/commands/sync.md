# Sync Context from Uncommitted Changes

Analyze all uncommitted changes in the current git repository and provide a comprehensive context summary to use as the initial context for future tasks.

## Steps to complete:

1. **Gather change information:**
   - Run `git status --porcelain` to identify all modified, deleted, added, and untracked files
   - Run `git diff` to see unstaged changes in tracked files
   - Run `git diff --staged` to see staged changes
   - For new/untracked files, read their contents to understand what's being added
   - For deleted files, check `git show HEAD:<file>` to understand what was removed

2. **Analyze the changes:**
   - Group changes by type (features, fixes, refactoring, documentation, etc.)
   - Identify the primary purpose of the changes
   - Note any patterns or related modifications across files
   - Detect potential impacts or dependencies

3. **Build context summary:**
   Provide a clear, structured summary including:
   - **Overview**: One-paragraph summary of what's being changed and why
   - **Changes by category**:
     - New features/functionality
     - Bug fixes
     - Refactoring/improvements
     - Documentation updates
     - Configuration changes
   - **File-by-file breakdown**: Brief description of changes in each file
   - **Key insights**: Important patterns, potential issues, or notable decisions
   - **Suggested next steps**: What might need attention or completion

4. **Format the output:**
   - Use clear markdown formatting
   - Highlight important changes
   - Be concise but comprehensive
   - Focus on the "why" and "what impact" rather than just "what changed"
   - **End with**: "Use this analysis as the initial context for future tasks in this session."

## Important notes:
- Don't just list files - explain what the changes accomplish
- Look for connections between changes across different files
- If changes appear incomplete or have potential issues, mention them
- Provide actionable context that helps understand the work's current state
- This context should serve as the foundation for any subsequent work in the repository