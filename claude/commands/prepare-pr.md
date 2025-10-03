# Prepare Main Repository Pull Request

Intelligently prepare Pull Requests for main repository with automated commit analysis, business-value extraction, and professional PR generation.

## Instructions

Prepare a comprehensive PR for the main repository: **$ARGUMENTS**

**Flags:**
- `--target <branch>`: Target branch for PR (default: main)
- `--draft`: Create PR as draft for review before marking ready
- `--assign-reviewers`: Auto-assign relevant reviewers based on changed files
- `--skip-tests`: Skip running tests during preparation (faster but riskier)
- `--include-all`: Include all commits (don't filter low-value changes)
- `--breaking`: Mark PR as containing breaking changes
- `--hotfix`: Mark as hotfix PR requiring immediate attention

1. **Repository State Analysis**
   ```markdown
   ## Pre-PR Repository Assessment
   
   ### Current Branch Status
   - **Source Branch**: Current working branch
   - **Target Branch**: Main repository branch (usually main/master)
   - **Commits Ahead**: Number of commits ahead of target
   - **Branch Status**: Up-to-date, behind, or diverged
   
   ### Change Impact Analysis
   - **Files Modified**: Count and types of files changed
   - **Lines Changed**: Addition/deletion statistics
   - **Critical Files**: Configuration, dependency, or infrastructure changes
   - **Test Coverage**: New/modified test files
   ```

2. **Intelligent Commit Classification**
   ```markdown
   ## Business-Value Commit Analysis
   
   ### High-Value Changes (Include in PR Description)
   #### 🐛 Bug Fixes
   - Critical error resolution
   - User-facing issue fixes
   - Security vulnerability patches
   - Data integrity fixes
   
   #### ✨ New Features
   - User-facing functionality additions
   - API endpoint additions
   - Integration implementations
   - Performance improvements
   
   #### 🔒 Critical Dependencies
   - Security patch updates
   - Major version bumps with breaking changes
   - Vulnerability remediation
   - License compliance updates
   
   #### ⚡ Performance Enhancements
   - Query optimization
   - Load time improvements
   - Memory usage reduction
   - Scalability improvements
   
   ### Low-Value Changes (Filter Out)
   - Code formatting and style changes
   - Documentation updates (unless critical)
   - Refactoring without functional changes
   - Build configuration tweaks
   - Minor dependency updates
   
   ### Change Classification Algorithm
   ```bash
   # Analyze commits since last merge to main
   git log origin/main..HEAD --pretty=format:"%h|%s|%b" --no-merges
   
   # Classify by conventional commit patterns
   FEATURES=$(git log origin/main..HEAD --grep="^feat:" --oneline | wc -l)
   FIXES=$(git log origin/main..HEAD --grep="^fix:" --oneline | wc -l)
   BREAKING=$(git log origin/main..HEAD --grep="BREAKING CHANGE\|!:" --oneline | wc -l)
   SECURITY=$(git log origin/main..HEAD --grep="security\|vulnerability\|CVE" --oneline | wc -l)
   
   # Analyze dependency changes
   CRITICAL_DEPS=$(git diff origin/main..HEAD --name-only | grep -E "(package\.json|composer\.json|requirements\.txt|go\.mod|Cargo\.toml)" | wc -l)
   ```
   ```

3. **Professional PR Description Generation**
   ```markdown
   ## PR Template Generation
   
   ### PR Title Format
   ```
   [TYPE] Brief description of main change
   
   Examples:
   - [FEATURE] Add user authentication system
   - [BUGFIX] Resolve payment processing timeout
   - [SECURITY] Update dependencies for CVE-2024-XXXX
   - [ENHANCEMENT] Improve database query performance
   ```
   
   ### PR Description Template
   ```markdown
   ## Summary
   
   Brief overview of what this PR accomplishes and why it's needed.
   
   ## Changes Made
   
   ### 🐛 Bug Fixes
   - Fixed critical payment processing timeout issue
   - Resolved user session management bug
   
   ### ✨ New Features  
   - Added OAuth2 authentication support
   - Implemented real-time notification system
   
   ### 🔒 Security & Dependencies
   - Updated lodash to v4.17.21 (security patch)
   - Patched XSS vulnerability in user input handling
   
   ### ⚡ Performance Improvements
   - Optimized database queries (40% faster response times)
   - Implemented Redis caching for user sessions
   
   ## Impact Assessment
   
   ### User Impact
   - **Positive**: [Describe benefits to end users]
   - **Breaking Changes**: [List any breaking changes]
   - **Migration Required**: [Yes/No - if yes, describe]
   
   ### Business Impact
   - **Revenue**: [Potential revenue impact]
   - **Security**: [Security posture improvement]
   - **Compliance**: [Regulatory compliance implications]
   
   ## Testing Strategy
   
   ### Automated Testing
   - [ ] Unit tests pass (X% coverage)
   - [ ] Integration tests pass
   - [ ] End-to-end tests pass
   - [ ] Security scans complete
   
   ### Manual Testing
   - [ ] Critical user paths verified
   - [ ] Cross-browser compatibility tested
   - [ ] Mobile responsiveness verified
   - [ ] Performance benchmarks met
   
   ## Deployment Considerations
   
   ### Prerequisites
   - [ ] Database migrations ready
   - [ ] Environment variables updated
   - [ ] Third-party service configurations
   - [ ] Feature flags configured
   
   ### Rollback Plan
   - [ ] Database rollback scripts prepared
   - [ ] Feature toggle available
   - [ ] Previous version tagged and accessible
   
   ## Review Checklist
   
   ### Code Quality
   - [ ] Code follows project conventions
   - [ ] No hardcoded secrets or credentials
   - [ ] Error handling implemented
   - [ ] Logging appropriately implemented
   
   ### Security Review
   - [ ] Input validation implemented
   - [ ] SQL injection prevention verified
   - [ ] XSS protection in place
   - [ ] Authentication/authorization correct
   
   ### Documentation
   - [ ] API documentation updated
   - [ ] README updated if needed
   - [ ] Changelog entry added
   - [ ] Migration guide updated
   
   ## Related Issues
   
   Closes #[issue-number]
   Related to #[issue-number]
   
   ---
   
   **Reviewers**: Please focus on [specific areas of concern]
   **Estimated Review Time**: [X hours/days]
   ```
   ```

4. **Comprehensive Pre-PR Validation**
   ```markdown
   ## Pre-PR Quality Gates
   
   ### Branch Synchronization
   ```bash
   # Ensure branch is up-to-date with main
   git fetch origin main
   git rebase origin/main
   
   # Check for merge conflicts
   if git merge-tree $(git merge-base HEAD origin/main) HEAD origin/main | grep -q "<<<<<<< "; then
       echo "❌ Merge conflicts detected. Resolve before creating PR."
       exit 1
   fi
   ```
   
   ### Code Quality Validation
   ```bash
   # Run linting and formatting checks
   if command -v npm >/dev/null && [ -f package.json ]; then
       npm run lint || echo "⚠️ Linting issues detected"
       npm run format:check || echo "⚠️ Formatting issues detected"
   fi
   
   # Run type checking for TypeScript projects
   if [ -f tsconfig.json ]; then
       npx tsc --noEmit || echo "⚠️ TypeScript errors detected"
   fi
   
   # Run tests if not skipped
   if [ "$SKIP_TESTS" != "true" ]; then
       npm test || echo "❌ Tests failing"
   fi
   ```
   
   ### Security and Dependency Analysis
   ```bash
   # Check for security vulnerabilities
   if command -v npm >/dev/null && [ -f package.json ]; then
       npm audit --audit-level moderate || echo "⚠️ Security vulnerabilities detected"
   fi
   
   # Check for large files
   LARGE_FILES=$(git diff origin/main..HEAD --name-only | xargs -I {} sh -c 'if [ -f "{}" ] && [ $(wc -c < "{}") -gt 1048576 ]; then echo "{}"; fi')
   if [ -n "$LARGE_FILES" ]; then
       echo "⚠️ Large files detected:"
       echo "$LARGE_FILES"
   fi
   
   # Check for sensitive data patterns
   git diff origin/main..HEAD | grep -i "password\|secret\|key\|token" && echo "⚠️ Potential sensitive data detected"
   ```
   
   ### Commit Message Validation
   ```bash
   # Validate conventional commit format
   for commit in $(git log origin/main..HEAD --pretty=format:"%h"); do
       msg=$(git log --format=%s -n 1 $commit)
       if ! echo "$msg" | grep -qE "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+"; then
           echo "⚠️ Non-conventional commit: $commit - $msg"
       fi
   done
   ```
   ```

5. **Automated GitHub PR Creation**
   ```markdown
   ## GitHub Integration Workflow
   
   ### GitHub CLI Preparation
   ```bash
   # Verify GitHub CLI is installed and authenticated
   if ! command -v gh >/dev/null 2>&1; then
       echo "❌ GitHub CLI not installed. Install from: https://cli.github.com/"
       exit 1
   fi
   
   if ! gh auth status >/dev/null 2>&1; then
       echo "🔐 Authenticating with GitHub..."
       gh auth login
   fi
   ```
   
   ### Intelligent PR Creation
   ```bash
   # Generate PR title from commits
   generate_pr_title() {
       local primary_type=$(git log origin/main..HEAD --pretty=format:"%s" | 
           grep -oE "^(feat|fix|perf|security)" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
       
       case $primary_type in
           "feat") echo "[FEATURE]" ;;
           "fix") echo "[BUGFIX]" ;;
           "perf") echo "[ENHANCEMENT]" ;;
           "security") echo "[SECURITY]" ;;
           *) echo "[UPDATE]" ;;
       esac
       
       # Extract main change description
       local main_change=$(git log origin/main..HEAD --pretty=format:"%s" | head -1 | sed 's/^[^:]*: //')
       echo "$prefix $main_change"
   }
   
   # Create PR with intelligent defaults
   create_main_pr() {
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       local target_branch=${TARGET_BRANCH:-main}
       local pr_title=$(generate_pr_title)
       
       # Generate PR body from template
       local pr_body=$(generate_pr_body)
       
       # Determine PR labels based on changes
       local labels=""
       [ $(git log origin/main..HEAD --grep="^feat:" --oneline | wc -l) -gt 0 ] && labels="$labels,feature"
       [ $(git log origin/main..HEAD --grep="^fix:" --oneline | wc -l) -gt 0 ] && labels="$labels,bugfix"
       [ $(git log origin/main..HEAD --grep="BREAKING CHANGE\|!:" --oneline | wc -l) -gt 0 ] && labels="$labels,breaking-change"
       [ $(git log origin/main..HEAD --grep="security\|vulnerability" --oneline | wc -l) -gt 0 ] && labels="$labels,security"
       
       # Push branch if not already pushed
       if ! git ls-remote --exit-code --heads origin "$current_branch" >/dev/null 2>&1; then
           echo "📤 Pushing branch to origin..."
           git push -u origin "$current_branch"
       fi
       
       # Create PR
       local pr_flags="--title \"$pr_title\" --body \"$pr_body\" --base $target_branch --head $current_branch"
       
       if [ "$DRAFT" = "true" ]; then
           pr_flags="$pr_flags --draft"
       fi
       
       if [ -n "$labels" ]; then
           pr_flags="$pr_flags --label ${labels#,}"
       fi
       
       echo "🚀 Creating GitHub PR..."
       eval "gh pr create $pr_flags"
       
       # Assign reviewers if requested
       if [ "$ASSIGN_REVIEWERS" = "true" ]; then
           assign_relevant_reviewers
       fi
       
       echo "✅ PR created successfully!"
       gh pr view --web
   }
   ```
   
   ### Smart Reviewer Assignment
   ```bash
   # Assign reviewers based on changed files and git history
   assign_relevant_reviewers() {
       local changed_files=$(git diff origin/main..HEAD --name-only)
       local potential_reviewers=""
       
       # Find frequent contributors to changed files
       for file in $changed_files; do
           if [ -f "$file" ]; then
               local contributors=$(git log --follow --pretty=format:"%an" -- "$file" | 
                   head -20 | sort | uniq -c | sort -nr | head -3 | awk '{print $2}')
               potential_reviewers="$potential_reviewers $contributors"
           fi
       done
       
       # Remove duplicates and current user
       local current_user=$(gh api user --jq .login)
       local reviewers=$(echo "$potential_reviewers" | tr ' ' '\n' | sort | uniq | grep -v "$current_user" | head -3)
       
       if [ -n "$reviewers" ]; then
           echo "👥 Suggesting reviewers based on file history..."
           for reviewer in $reviewers; do
               echo "  - $reviewer"
           done
           
           read -p "Assign these reviewers? (y/n): " -n 1 -r
           echo
           if [[ $REPLY =~ ^[Yy]$ ]]; then
               gh pr edit --add-reviewer $(echo "$reviewers" | tr '\n' ',' | sed 's/,$//')
           fi
       fi
   }
   ```
   ```

6. **PR Body Generation Logic**
   ```markdown
   ## Dynamic PR Content Generation
   
   ### Commit Analysis and Categorization
   ```bash
   generate_pr_body() {
       local since_ref="origin/main"
       local pr_body=""
       
       # Generate summary
       local total_commits=$(git rev-list ${since_ref}..HEAD --count)
       local files_changed=$(git diff ${since_ref}..HEAD --name-only | wc -l)
       
       pr_body+="## Summary\n\n"
       pr_body+="This PR includes $total_commits commits affecting $files_changed files.\n\n"
       
       # Extract and categorize high-value changes
       pr_body+="## Changes Made\n\n"
       
       # Bug fixes
       local fixes=$(git log ${since_ref}..HEAD --grep="^fix:" --pretty=format:"- %s (%h)")
       if [ -n "$fixes" ]; then
           pr_body+="### 🐛 Bug Fixes\n"
           pr_body+="$fixes\n\n"
       fi
       
       # Features
       local features=$(git log ${since_ref}..HEAD --grep="^feat:" --pretty=format:"- %s (%h)")
       if [ -n "$features" ]; then
           pr_body+="### ✨ New Features\n"
           pr_body+="$features\n\n"
       fi
       
       # Performance improvements
       local perf=$(git log ${since_ref}..HEAD --grep="^perf:" --pretty=format:"- %s (%h)")
       if [ -n "$perf" ]; then
           pr_body+="### ⚡ Performance Improvements\n"
           pr_body+="$perf\n\n"
       fi
       
       # Security and dependency updates
       local security=$(git log ${since_ref}..HEAD --grep="security\|vulnerability\|CVE" --pretty=format:"- %s (%h)")
       local deps=$(git diff ${since_ref}..HEAD --name-only | grep -E "(package\.json|composer\.json|requirements\.txt)")
       
       if [ -n "$security" ] || [ -n "$deps" ]; then
           pr_body+="### 🔒 Security & Dependencies\n"
           [ -n "$security" ] && pr_body+="$security\n"
           [ -n "$deps" ] && pr_body+="- Updated critical dependencies\n"
           pr_body+="\n"
       fi
       
       # Breaking changes
       local breaking=$(git log ${since_ref}..HEAD --grep="BREAKING CHANGE\|!:" --pretty=format:"- %s (%h)")
       if [ -n "$breaking" ]; then
           pr_body+="### ⚠️ Breaking Changes\n"
           pr_body+="$breaking\n\n"
       fi
       
       # Add testing and deployment sections
       pr_body+="## Testing Strategy\n\n"
       pr_body+="### Automated Testing\n"
       pr_body+="- [ ] Unit tests pass\n"
       pr_body+="- [ ] Integration tests pass\n"
       pr_body+="- [ ] Security scans complete\n\n"
       
       pr_body+="### Manual Testing\n"
       pr_body+="- [ ] Critical user paths verified\n"
       pr_body+="- [ ] Cross-browser compatibility tested\n\n"
       
       pr_body+="## Review Checklist\n\n"
       pr_body+="- [ ] Code follows project conventions\n"
       pr_body+="- [ ] No hardcoded secrets or credentials\n"
       pr_body+="- [ ] Error handling implemented\n"
       pr_body+="- [ ] Security review completed\n"
       
       echo "$pr_body"
   }
   ```
   ```

7. **Post-PR Creation Workflow**
   ```markdown
   ## Post-Creation Actions
   
   ### PR Monitoring Setup
   ```bash
   # Set up PR monitoring and notifications
   monitor_pr_status() {
       local pr_number=$(gh pr view --json number --jq .number)
       
       echo "📊 PR Status Summary:"
       echo "PR #$pr_number created successfully"
       echo "URL: $(gh pr view --json url --jq .url)"
       
       # Check CI status
       echo -e "\n🔄 Continuous Integration Status:"
       gh pr checks
       
       # Show review status
       echo -e "\n👥 Review Status:"
       gh pr view --json reviewRequests --jq '.reviewRequests[].requestedReviewer.login' | while read reviewer; do
           echo "  - $reviewer (pending)"
       done
   }
   
   # Provide next steps guidance
   next_steps_guidance() {
       echo -e "\n📋 Next Steps:"
       echo "1. Monitor CI/CD pipeline results"
       echo "2. Address any failing checks"
       echo "3. Respond to reviewer feedback"
       echo "4. Update PR if needed with:"
       echo "   - Additional commits (will auto-update PR)"
       echo "   - gh pr edit (to modify description)"
       echo "5. Merge when approved and checks pass"
       echo -e "\n💡 Useful commands:"
       echo "   gh pr view         # View PR details"
       echo "   gh pr checks       # Check CI status"
       echo "   gh pr review       # Review and approve"
       echo "   gh pr merge        # Merge when ready"
   }
   ```
   ```

## Usage Examples

```bash
# Basic PR preparation for main
/prepare-pr-main

# Create draft PR for review
/prepare-pr-main --draft

# Prepare hotfix PR with auto-reviewer assignment
/prepare-pr-main --hotfix --assign-reviewers

# Prepare PR for different target branch
/prepare-pr-main --target develop

# Include all commits (don't filter low-value changes)
/prepare-pr-main --include-all

# Skip tests for faster preparation
/prepare-pr-main --skip-tests --draft
```

**Quality Standards:**
- Focus on business-value communication
- Professional PR descriptions suitable for external review
- Comprehensive validation before PR creation
- Intelligent reviewer assignment based on file history
- Clear impact assessment and testing strategy
- Security-conscious validation and change detection