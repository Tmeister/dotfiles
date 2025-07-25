# PR Review and Test Command

Fetch a GitHub PR, run project tests, analyze the changes, and provide recommendations with an interactive approval workflow.

## Purpose
This command automates the process of reviewing a GitHub pull request by:
1. Fetching PR details and changes
2. Running the project's test suite
3. Analyzing code quality and changes
4. Providing comprehensive recommendations
5. Prompting user for PR acceptance decision

## Usage
```bash
# Review a specific PR
claude "Review PR #123 and test it"

# Review PR from URL
claude "Review and test PR https://github.com/owner/repo/pull/123"

# Review with specific test command
claude "Review PR #123 using 'npm run test:ci'"
```

## Instructions

### 1. Fetch PR Information
First, gather comprehensive PR details using GitHub CLI:

```bash
# Get detailed PR information
gh pr view <PR_NUMBER> --json title,body,labels,assignees,state,url,createdAt,updatedAt,milestone,additions,deletions,changedFiles,commits,reviews,mergeable,draft

# Get PR diff to analyze changes
gh pr diff <PR_NUMBER>

# Get file list with changes
gh pr view <PR_NUMBER> --json files
```

### 2. Checkout PR Branch
Create a safe environment to test the PR:

```bash
# Fetch and checkout PR branch
gh pr checkout <PR_NUMBER>

# Or manually checkout
git fetch origin pull/<PR_NUMBER>/head:pr-<PR_NUMBER>
git checkout pr-<PR_NUMBER>
```

### 3. Run Project Tests
Detect and execute the appropriate test commands:

```bash
# Auto-detect test command from package.json, Makefile, or common patterns
# Priority order:
# 1. package.json scripts: test, test:ci, test:all
# 2. Makefile: test, check
# 3. Common commands: npm test, yarn test, pytest, cargo test, go test
# 4. Custom command provided by user

# Example detection logic:
if [ -f "package.json" ]; then
  if jq -e '.scripts.test' package.json > /dev/null; then
    npm run test
  elif jq -e '.scripts["test:ci"]' package.json > /dev/null; then
    npm run test:ci
  fi
elif [ -f "Makefile" ]; then
  if grep -q "^test:" Makefile; then
    make test
  fi
elif [ -f "Cargo.toml" ]; then
  cargo test
elif [ -f "go.mod" ]; then
  go test ./...
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
  pytest
fi
```

### 4. Analyze PR Changes
Perform comprehensive analysis of the changes:

```javascript
// Change Analysis Structure
const analysis = {
  overview: {
    title: prData.title,
    description: prData.body,
    author: prData.user.login,
    size: {
      additions: prData.additions,
      deletions: prData.deletions,
      changedFiles: prData.changedFiles
    },
    labels: prData.labels,
    isDraft: prData.draft,
    mergeable: prData.mergeable
  },

  codeQuality: {
    fileChanges: analyzeFileChanges(prDiff),
    complexity: assessComplexity(prDiff),
    testCoverage: analyzeTestChanges(prDiff),
    documentation: checkDocumentationUpdates(prDiff)
  },

  testResults: {
    status: testExitCode === 0 ? 'PASSED' : 'FAILED',
    output: testOutput,
    coverage: extractCoverageData(testOutput),
    failures: parseTestFailures(testOutput)
  },

  risks: identifyRisks(prData, prDiff),
  recommendations: generateRecommendations(analysis)
};
```

### 5. Risk Assessment
Identify potential risks and concerns:

- **Breaking Changes**: API modifications, database schema changes
- **Security Issues**: New dependencies, authentication changes, input validation
- **Performance Impact**: Large file changes, algorithm modifications, database queries
- **Test Coverage**: Missing tests for new features, reduced coverage
- **Dependencies**: New packages, version updates, security vulnerabilities
- **Merge Conflicts**: Potential conflicts with main branch

### 6. Generate Recommendations
Provide structured recommendations based on analysis:

```markdown
## PR Review Summary

### ✅ Positive Aspects
- Well-tested changes with X% coverage increase
- Clear documentation updates
- Follows project coding standards
- No breaking changes detected

### ⚠️ Areas of Concern
- Missing tests for new utility functions
- Large file changes in critical modules
- New dependency introduced without security audit

### 🚨 Critical Issues
- Tests failing in CI environment
- Potential security vulnerability in input validation
- Breaking change in public API

### 📋 Recommendations
1. **MUST FIX**: Add tests for new functions in `utils/helper.js:45-67`
2. **SHOULD FIX**: Update documentation for API changes
3. **CONSIDER**: Extract large function into smaller methods for maintainability

### 🎯 Decision Factors
- Test Status: ✅ PASSED / ❌ FAILED
- Code Quality: High/Medium/Low
- Risk Level: Low/Medium/High
- Breaking Changes: Yes/No
```

### 7. Interactive Approval Workflow
Present findings and prompt for decision:

```bash
echo "🔍 PR Review Complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Test Results: ${TEST_STATUS}"
echo "🎯 Risk Level: ${RISK_LEVEL}"
echo "📈 Code Quality: ${QUALITY_SCORE}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "Would you like to proceed with this PR?"
echo "1) ✅ Approve and merge"
echo "2) ✅ Approve (don't merge)"
echo "3) 📝 Request changes"
echo "4) ❌ Reject"
echo "5) 🤔 View detailed analysis"
echo "6) 🧪 Re-run tests"
echo "7) 🚪 Exit without action"
echo
read -p "Enter your choice (1-7): " choice

case $choice in
  1)
    gh pr review --approve
    gh pr merge --auto
    ;;
  2)
    gh pr review --approve
    ;;
  3)
    echo "Enter your change requests:"
    read -p "Comments: " comments
    gh pr review --request-changes --body "$comments"
    ;;
  4)
    echo "Enter rejection reason:"
    read -p "Reason: " reason
    gh pr review --request-changes --body "❌ PR Rejected: $reason"
    ;;
  5)
    # Show detailed analysis report
    ;;
  6)
    # Re-run test suite
    ;;
  7)
    echo "Exiting without action"
    ;;
esac
```

### 8. Cleanup
Always clean up the environment:

```bash
# Return to original branch
git checkout -

# Clean up PR branch if needed
git branch -D pr-<PR_NUMBER>

# Reset any local changes
git reset --hard HEAD
```

## Error Handling

Handle common failure scenarios:

```bash
# Check prerequisites
command -v gh >/dev/null 2>&1 || { echo "GitHub CLI required"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "Git required"; exit 1; }

# Verify PR exists
gh pr view "$PR_NUMBER" >/dev/null 2>&1 || { echo "PR #$PR_NUMBER not found"; exit 1; }

# Handle test failures gracefully
if [ $TEST_EXIT_CODE -ne 0 ]; then
  echo "⚠️ Tests failed but continuing with review..."
  echo "Test failures should be addressed before merging"
fi

# Handle merge conflicts
if ! git merge-tree $(git merge-base HEAD main) HEAD main | grep -q "<<<<<<< "; then
  echo "✅ No merge conflicts detected"
else
  echo "⚠️ Merge conflicts detected - resolve before merging"
fi
```

## Example Output

```
🔍 Analyzing PR #123: Add user authentication middleware

📥 Fetching PR details...
✓ PR #123 fetched successfully
  Author: @johndoe
  Size: +234/-56 lines across 8 files
  Labels: feature, security, backend

🔄 Checking out PR branch...
✓ Switched to branch 'pr-123'

🧪 Running tests...
✓ Tests passed (47/47)
✓ Coverage: 89% (+2%)

🔍 Analyzing changes...
✓ 3 new files added
✓ 5 existing files modified
✓ Documentation updated
⚠️ 1 new dependency added

📊 Review Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Test Status: PASSED
🎯 Risk Level: LOW
📈 Code Quality: HIGH
🔄 Mergeable: YES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Recommendations:
• Consider adding integration tests for auth flow
• New bcrypt dependency looks secure and up-to-date
• API documentation updated appropriately

Would you like to proceed with this PR?
1) ✅ Approve and merge
2) ✅ Approve (don't merge)
3) 📝 Request changes
4) ❌ Reject
5) 🤔 View detailed analysis
6) 🧪 Re-run tests
7) 🚪 Exit without action

Enter your choice (1-7): _
```

## Advanced Features

### Test Command Detection
Automatically detect the appropriate test command based on project structure:

```bash
detect_test_command() {
  if [ -f "package.json" ] && jq -e '.scripts.test' package.json >/dev/null; then
    echo "npm test"
  elif [ -f "Cargo.toml" ]; then
    echo "cargo test"
  elif [ -f "go.mod" ]; then
    echo "go test ./..."
  elif [ -f "Makefile" ] && grep -q "^test:" Makefile; then
    echo "make test"
  elif [ -f "requirements.txt" ]; then
    echo "pytest"
  else
    echo "echo 'No test command detected'"
  fi
}
```

### Coverage Analysis
Extract and analyze test coverage changes:

```bash
extract_coverage() {
  # Parse coverage from different formats
  if command -v nyc >/dev/null; then
    nyc report --reporter=text-summary | grep "Lines"
  elif grep -q "coverage" package.json; then
    npm run coverage 2>&1 | grep -E "[0-9]+%"
  fi
}
```

### Security Scanning
Integrate security checks:

```bash
security_scan() {
  # Check for known vulnerabilities
  if [ -f "package.json" ]; then
    npm audit --audit-level=moderate
  fi

  # Scan for secrets
  if command -v gitleaks >/dev/null; then
    gitleaks detect --source .
  fi
}
```

## Integration Tips

- Use with existing CI/CD workflows
- Integrate with Linear/Jira for task tracking
- Set up as Git hooks for automated reviews
- Configure team-specific approval rules
- Add Slack/Discord notifications for review results
