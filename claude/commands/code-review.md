# Code Review Command

Perform an automated code review using CodeRabbit and fix the issues it finds.

## Usage

- Default: Reviews uncommitted changes
- With branch: `code-review --branch <branch_name>` reviews all changes compared to that branch

Arguments: **$ARGUMENTS**

## Instructions

Follow these steps to conduct a code review:

1. **Run CodeRabbit Review**
   - Parse arguments to check for `--branch <branch_name>` flag
   - If `--branch <branch_name>` is present:
     - Execute `coderabbit review --plain --base <branch_name>` with a 10-minute timeout
   - Otherwise (default):
     - Execute `coderabbit review --plain --type uncommitted` with a 10-minute timeout
   - CodeRabbit will analyze changes and provide feedback

2. **Analyze CodeRabbit Output**
   - Review the issues, suggestions, and recommendations from CodeRabbit
   - Prioritize issues by severity (critical, high, medium, low)

3. **Fix Issues**
   - Address each issue identified by CodeRabbit
   - Make necessary code changes to resolve problems
   - Apply suggested improvements and best practices

4. **Verify Fixes**
   - Ensure all critical and high-priority issues are resolved
   - Run the coderabbit review again if needed to verify fixes