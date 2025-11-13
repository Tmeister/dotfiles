# Git Workflow Automation

Advanced Git workflow automation for branch management, commit quality, PR preparation, conflict resolution, and history optimization following best practices.

## Instructions

Automate and optimize Git workflows for better collaboration: **$ARGUMENTS**

**Flags:**
- `--branch-cleanup`: Clean up merged and stale branches
- `--commit-check`: Validate commit messages and history
- `--pr-prepare`: Prepare branch for pull request with GitHub CLI integration
- `--conflict-assist`: Help resolve merge conflicts
- `--history-optimize`: Clean up Git history safely
- `--flow <type>`: Use specific Git flow (git-flow, github-flow, gitlab-flow)
- `--gh-setup`: Configure GitHub CLI for seamless integration

1. **Git Repository Analysis**
   ```markdown
   ## Repository Health Assessment
   
   ### Current State Analysis
   - **Active Branches**: Local and remote branch count
   - **Stale Branches**: Branches without recent activity
   - **Commit Quality**: Conventional commit compliance
   - **Merge Conflicts**: Potential conflict detection
   - **Repository Size**: Large files and history bloat
   
   ### Git Workflow Detection
   ```bash
   # Detect current Git flow pattern
   git remote -v
   git branch -r | head -20
   git log --oneline --graph --decorate -20
   
   # Analyze branch naming patterns
   git branch -r | grep -E "(feature|hotfix|release|develop|main|master)" | sort
   
   # Check for Git flow configuration
   git config --get-regexp "gitflow.*" || echo "Git flow not configured"
   ```
   ```

2. **Smart Branch Management**
   ```markdown
   ## Branch Lifecycle Management
   
   ### Branch Cleanup Strategy
   #### Safe Branch Deletion
   ```bash
   #!/bin/bash
   
   # Function to clean up merged branches
   cleanup_merged_branches() {
       echo "🧹 Cleaning up merged branches..."
       
       # Get default branch
       DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
       
       # Switch to default branch
       git checkout $DEFAULT_BRANCH
       git pull origin $DEFAULT_BRANCH
       
       # Delete local branches merged into default branch
       echo "Local branches that can be deleted:"
       git branch --merged $DEFAULT_BRANCH | grep -v "^\*" | grep -v "$DEFAULT_BRANCH"
       
       if [ $(git branch --merged $DEFAULT_BRANCH | grep -v "^\*" | grep -v "$DEFAULT_BRANCH" | wc -l) -gt 0 ]; then
           read -p "Delete these local branches? (y/n): " -n 1 -r
           echo
           if [[ $REPLY =~ ^[Yy]$ ]]; then
               git branch --merged $DEFAULT_BRANCH | grep -v "^\*" | grep -v "$DEFAULT_BRANCH" | xargs -n 1 git branch -d
           fi
       fi
       
       # Delete remote tracking branches
       echo -e "\n🌐 Remote branches that have been deleted:"
       git remote prune origin --dry-run
       
       read -p "Prune remote tracking branches? (y/n): " -n 1 -r
       echo
       if [[ $REPLY =~ ^[Yy]$ ]]; then
           git remote prune origin
       fi
   }
   
   # Function to detect stale branches
   find_stale_branches() {
       echo "🔍 Finding stale branches (no commits in last 30 days)..."
       
       for branch in $(git branch -r | grep -v HEAD); do
           last_commit=$(git log -1 --format="%cr" $branch)
           last_commit_date=$(git log -1 --format="%ci" $branch)
           author=$(git log -1 --format="%an" $branch)
           
           # Check if branch is older than 30 days
           if [ $(git log -1 --format="%ct" $branch) -lt $(date -d "30 days ago" +%s) ]; then
               echo "  - $branch (last commit: $last_commit by $author)"
           fi
       done
   }
   ```
   
   ### Branch Naming Conventions
   ```bash
   # Enforce branch naming conventions
   validate_branch_name() {
       local branch_name=$1
       local valid_patterns=(
           "^feature/[a-z0-9-]+$"
           "^bugfix/[a-z0-9-]+$"
           "^hotfix/[a-z0-9-]+$"
           "^release/[0-9]+\.[0-9]+\.[0-9]+$"
           "^chore/[a-z0-9-]+$"
       )
       
       for pattern in "${valid_patterns[@]}"; do
           if [[ $branch_name =~ $pattern ]]; then
               echo "✅ Valid branch name: $branch_name"
               return 0
           fi
       done
       
       echo "❌ Invalid branch name: $branch_name"
       echo "Valid patterns:"
       echo "  - feature/description-here"
       echo "  - bugfix/description-here"
       echo "  - hotfix/description-here"
       echo "  - release/1.2.3"
       echo "  - chore/description-here"
       return 1
   }
   
   # Create branch with validation
   create_branch() {
       local branch_type=$1
       local description=$2
       
       # Convert description to kebab-case
       description=$(echo "$description" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
       
       local branch_name="${branch_type}/${description}"
       
       if validate_branch_name "$branch_name"; then
           git checkout -b "$branch_name"
           echo "📌 Created and switched to branch: $branch_name"
       fi
   }
   ```
   ```

3. **Commit Message Quality Enforcement**
   ```markdown
   ## Commit Message Standards
   
   ### Conventional Commit Validation
   #### Commit Message Checker
   ```bash
   #!/bin/bash
   
   # Validate commit message format
   validate_commit_message() {
       local commit_msg=$1
       
       # Conventional commit pattern
       local pattern="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .{1,50}"
       
       if [[ ! $commit_msg =~ $pattern ]]; then
           echo "❌ Invalid commit message format!"
           echo ""
           echo "Expected format: <type>(<scope>): <subject>"
           echo ""
           echo "Types:"
           echo "  feat:     New feature"
           echo "  fix:      Bug fix"
           echo "  docs:     Documentation changes"
           echo "  style:    Code style changes (formatting, etc)"
           echo "  refactor: Code changes that neither fix bugs nor add features"
           echo "  perf:     Performance improvements"
           echo "  test:     Adding or modifying tests"
           echo "  build:    Build system or dependency changes"
           echo "  ci:       CI configuration changes"
           echo "  chore:    Other changes (maintenance, etc)"
           echo "  revert:   Revert a previous commit"
           echo ""
           echo "Example: feat(auth): add OAuth2 login support"
           return 1
       fi
       
       # Check subject length
       local subject=$(echo "$commit_msg" | sed 's/^[^:]*: //')
       if [ ${#subject} -gt 50 ]; then
           echo "⚠️  Warning: Subject line exceeds 50 characters (${#subject} chars)"
       fi
       
       echo "✅ Valid commit message"
       return 0
   }
   
   # Interactive commit with validation
   smart_commit() {
       echo "🔨 Creating a conventional commit..."
       
       # Select commit type
       echo "Select commit type:"
       select type in "feat" "fix" "docs" "style" "refactor" "perf" "test" "build" "ci" "chore" "revert"; do
           break
       done
       
       # Get scope (optional)
       read -p "Scope (optional, press enter to skip): " scope
       
       # Get subject
       read -p "Subject (imperative mood, max 50 chars): " subject
       
       # Build commit message
       if [ -n "$scope" ]; then
           commit_msg="${type}(${scope}): ${subject}"
       else
           commit_msg="${type}: ${subject}"
       fi
       
       # Validate before committing
       if validate_commit_message "$commit_msg"; then
           # Get body (optional)
           echo "Body (optional, press Ctrl+D when done):"
           body=$(cat)
           
           if [ -n "$body" ]; then
               git commit -m "$commit_msg" -m "$body"
           else
               git commit -m "$commit_msg"
           fi
       fi
   }
   ```
   
   ### Commit History Analysis
   ```bash
   # Analyze commit quality in current branch
   analyze_commit_quality() {
       echo "📊 Analyzing commit quality..."
       
       local total_commits=$(git rev-list --count HEAD)
       local conventional_commits=$(git log --pretty=format:"%s" | grep -E "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)" | wc -l)
       local percentage=$((conventional_commits * 100 / total_commits))
       
       echo "Total commits: $total_commits"
       echo "Conventional commits: $conventional_commits ($percentage%)"
       
       echo -e "\n📈 Commit type distribution:"
       git log --pretty=format:"%s" | grep -oE "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)" | sort | uniq -c | sort -rn
       
       echo -e "\n⚠️  Non-conventional commits:"
       git log --pretty=format:"%h %s" | grep -vE "^[a-f0-9]+ (feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)" | head -10
   }
   ```
   ```

4. **Pull Request Preparation**
   ```markdown
   ## PR Preparation Workflow
   
   ### Automated PR Readiness Check
   #### Pre-PR Validation
   ```bash
   #!/bin/bash
   
   prepare_for_pr() {
       echo "🚀 Preparing branch for Pull Request..."
       
       # Get current branch
       current_branch=$(git rev-parse --abbrev-ref HEAD)
       
       # Get default branch
       default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
       
       echo "Current branch: $current_branch"
       echo "Target branch: $default_branch"
       
       # Step 1: Update from target branch
       echo -e "\n1️⃣ Updating from $default_branch..."
       git fetch origin $default_branch
       git rebase origin/$default_branch
       
       if [ $? -ne 0 ]; then
           echo "❌ Rebase failed. Please resolve conflicts and run again."
           return 1
       fi
       
       # Step 2: Check for uncommitted changes
       echo -e "\n2️⃣ Checking for uncommitted changes..."
       if [ -n "$(git status --porcelain)" ]; then
           echo "❌ You have uncommitted changes. Please commit or stash them."
           return 1
       fi
       
       # Step 3: Validate commit messages
       echo -e "\n3️⃣ Validating commit messages..."
       invalid_commits=0
       while read -r commit; do
           msg=$(git log --format=%s -n 1 $commit)
           if ! validate_commit_message "$msg" >/dev/null 2>&1; then
               echo "  ❌ $commit: $msg"
               ((invalid_commits++))
           fi
       done < <(git log origin/$default_branch..$current_branch --pretty=format:"%h")
       
       if [ $invalid_commits -gt 0 ]; then
           echo "Found $invalid_commits non-conventional commits. Consider rebasing to fix."
       fi
       
       # Step 4: Check for large files
       echo -e "\n4️⃣ Checking for large files..."
       large_files=$(find . -type f -size +1M -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./vendor/*")
       if [ -n "$large_files" ]; then
           echo "⚠️  Large files detected:"
           echo "$large_files" | xargs -I {} sh -c 'echo "  - {} ($(du -h {} | cut -f1))"'
       fi
       
       # Step 5: Run tests if available
       echo -e "\n5️⃣ Running tests..."
       if [ -f "package.json" ] && grep -q "\"test\"" package.json; then
           npm test
       elif [ -f "composer.json" ] && [ -f "phpunit.xml" ]; then
           ./vendor/bin/phpunit
       elif [ -f "Makefile" ] && grep -q "^test:" Makefile; then
           make test
       else
           echo "⚠️  No test command found"
       fi
       
       # Step 6: Generate PR template
       echo -e "\n6️⃣ Generating PR description..."
       generate_pr_description
       
       echo -e "\n✅ Branch is ready for PR!"
       
       # Step 7: GitHub CLI integration
       if command -v gh >/dev/null 2>&1; then
           echo -e "\n7️⃣ GitHub CLI detected - creating PR automatically..."
           create_github_pr
       else
           echo "Next steps:"
           echo "  1. Push your branch: git push origin $current_branch"
           echo "  2. Create PR manually on GitHub"
           echo "  3. Use the generated PR description from .pr-description.md"
           echo ""
           echo "💡 Install GitHub CLI (gh) for automatic PR creation!"
       fi
   }
   
   # Generate PR description from commits
   generate_pr_description() {
       local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
       local pr_file=".pr-description.md"
       
       cat > $pr_file << EOF
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix (non-breaking change which fixes an issue)
   - [ ] New feature (non-breaking change which adds functionality)
   - [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
   - [ ] Documentation update
   
   ## Changes Made
   EOF
       
       # Add commit list
       git log origin/$default_branch..HEAD --pretty=format:"- %s" >> $pr_file
       
       cat >> $pr_file << EOF
   
   ## Testing
   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing completed
   
   ## Checklist
   - [ ] My code follows the style guidelines
   - [ ] I have performed a self-review
   - [ ] I have commented my code where necessary
   - [ ] I have updated the documentation
   - [ ] My changes generate no new warnings
   - [ ] I have added tests that prove my fix/feature works
   - [ ] New and existing unit tests pass locally
   EOF
       
       echo "📝 PR description saved to: $pr_file"
   }
   
   # Create GitHub PR using gh CLI
   create_github_pr() {
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
       
       # Push branch if not already pushed
       if ! git ls-remote --exit-code --heads origin "$current_branch" >/dev/null 2>&1; then
           echo "📤 Pushing branch to origin..."
           git push -u origin "$current_branch"
       fi
       
       # Check if PR already exists
       if gh pr view "$current_branch" >/dev/null 2>&1; then
           echo "✅ PR already exists for this branch!"
           gh pr view "$current_branch" --web
           return 0
       fi
       
       # Generate title from branch name
       local title=$(echo "$current_branch" | sed 's/^[^/]*\///' | tr '-' ' ' | sed 's/\b\w/\u&/g')
       
       # Use generated PR description
       local pr_body=""
       if [ -f ".pr-description.md" ]; then
           pr_body=$(cat .pr-description.md)
       fi
       
       echo "🚀 Creating GitHub PR..."
       
       # Create PR with draft option
       read -p "Create as draft PR? (y/n): " -n 1 -r
       echo
       
       if [[ $REPLY =~ ^[Yy]$ ]]; then
           gh pr create \
               --title "$title" \
               --body "$pr_body" \
               --base "$default_branch" \
               --head "$current_branch" \
               --draft
           echo "📋 Draft PR created!"
       else
           gh pr create \
               --title "$title" \
               --body "$pr_body" \
               --base "$default_branch" \
               --head "$current_branch"
           echo "📋 PR created!"
       fi
       
       # Open PR in browser
       read -p "Open PR in browser? (y/n): " -n 1 -r
       echo
       if [[ $REPLY =~ ^[Yy]$ ]]; then
           gh pr view --web
       fi
   }
   ```
   ```

5. **Merge Conflict Resolution Assistant**
   ```markdown
   ## Intelligent Conflict Resolution
   
   ### Conflict Detection and Resolution
   #### Smart Merge Conflict Handler
   ```bash
   #!/bin/bash
   
   # Assist with merge conflict resolution
   resolve_conflicts() {
       echo "🔧 Merge Conflict Resolution Assistant"
       
       # Check for conflicts
       if ! git ls-files -u >/dev/null 2>&1; then
           echo "✅ No merge conflicts detected!"
           return 0
       fi
       
       echo "❌ Merge conflicts detected in the following files:"
       git diff --name-only --diff-filter=U
       
       # Analyze conflict patterns
       echo -e "\n📊 Conflict Analysis:"
       for file in $(git diff --name-only --diff-filter=U); do
           echo -e "\n📄 $file:"
           
           # Count conflict markers
           conflicts=$(grep -c "^<<<<<<< " "$file" 2>/dev/null || echo 0)
           echo "  Conflicts: $conflicts"
           
           # Detect conflict type
           if grep -q "^<<<<<<< HEAD" "$file" 2>/dev/null; then
               echo "  Type: Regular merge conflict"
           elif grep -q "^<<<<<<< .*|" "$file" 2>/dev/null; then
               echo "  Type: Rebase conflict"
           fi
           
           # Show conflict preview
           echo "  Preview:"
           grep -A2 -B2 "^<<<<<<< " "$file" 2>/dev/null | head -10 | sed 's/^/    /'
       done
       
       # Offer resolution strategies
       echo -e "\n🛠️ Resolution Strategies:"
       echo "1. Accept incoming changes (theirs)"
       echo "2. Keep current changes (ours)"
       echo "3. Manual resolution with editor"
       echo "4. Use merge tool"
       echo "5. Show more details"
       
       read -p "Choose strategy (1-5): " strategy
       
       case $strategy in
           1) accept_theirs ;;
           2) accept_ours ;;
           3) manual_resolve ;;
           4) use_mergetool ;;
           5) show_conflict_details ;;
           *) echo "Invalid option" ;;
       esac
   }
   
   # Accept their changes
   accept_theirs() {
       read -p "Accept ALL incoming changes? This will overwrite your changes! (y/n): " -n 1 -r
       echo
       if [[ $REPLY =~ ^[Yy]$ ]]; then
           git checkout --theirs .
           git add .
           echo "✅ Accepted all incoming changes"
       fi
   }
   
   # Keep our changes
   accept_ours() {
       read -p "Keep ALL current changes? This will discard incoming changes! (y/n): " -n 1 -r
       echo
       if [[ $REPLY =~ ^[Yy]$ ]]; then
           git checkout --ours .
           git add .
           echo "✅ Kept all current changes"
       fi
   }
   
   # Manual resolution
   manual_resolve() {
       echo "Opening conflicts in editor..."
       
       # Get list of conflicted files
       files=$(git diff --name-only --diff-filter=U)
       
       # Open in default editor
       ${EDITOR:-vim} $files
       
       echo "After resolving conflicts, run:"
       echo "  git add <resolved-files>"
       echo "  git commit"
   }
   
   # Show detailed conflict information
   show_conflict_details() {
       for file in $(git diff --name-only --diff-filter=U); do
           echo -e "\n📄 Detailed view of $file:"
           echo "================================"
           
           # Show the conflicting commits
           echo "🔍 Conflicting commits:"
           git log --oneline --left-right --merge -- "$file"
           
           echo -e "\n📝 Conflict content:"
           grep -n -C5 "^<<<<<<< " "$file" | head -50
       done
   }
   ```
   ```

6. **Git History Optimization**
   ```markdown
   ## History Cleanup and Optimization
   
   ### Safe History Rewriting
   #### Interactive History Cleanup
   ```bash
   #!/bin/bash
   
   # Optimize Git history safely
   optimize_history() {
       echo "🧬 Git History Optimization"
       
       # Check if on a feature branch
       current_branch=$(git rev-parse --abbrev-ref HEAD)
       default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
       
       if [ "$current_branch" = "$default_branch" ]; then
           echo "❌ Cannot rewrite history on the default branch!"
           return 1
       fi
       
       echo "Current branch: $current_branch"
       
       # Show recent commits
       echo -e "\n📜 Recent commits:"
       git log --oneline -10
       
       echo -e "\n🛠️ History optimization options:"
       echo "1. Squash related commits"
       echo "2. Fix commit messages"
       echo "3. Remove large files from history"
       echo "4. Reorder commits"
       echo "5. Split large commits"
       
       read -p "Choose option (1-5): " option
       
       case $option in
           1) squash_commits ;;
           2) fix_commit_messages ;;
           3) remove_large_files ;;
           4) reorder_commits ;;
           5) split_commits ;;
           *) echo "Invalid option" ;;
       esac
   }
   
   # Squash related commits
   squash_commits() {
       echo "🔀 Squashing commits..."
       
       read -p "How many commits back to include? " num_commits
       
       echo "This will open an interactive rebase for the last $num_commits commits."
       echo "Change 'pick' to 'squash' for commits you want to combine."
       read -p "Continue? (y/n): " -n 1 -r
       echo
       
       if [[ $REPLY =~ ^[Yy]$ ]]; then
           git rebase -i HEAD~$num_commits
       fi
   }
   
   # Fix commit messages
   fix_commit_messages() {
       echo "✏️ Fixing commit messages..."
       
       # Show commits with non-conventional messages
       echo "Non-conventional commits in the last 20:"
       git log --pretty=format:"%h %s" -20 | grep -vE "^[a-f0-9]+ (feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)" || echo "All commits follow conventions!"
       
       read -p "How many commits back to review? " num_commits
       
       echo "Change 'pick' to 'reword' for commits you want to fix."
       read -p "Continue? (y/n): " -n 1 -r
       echo
       
       if [[ $REPLY =~ ^[Yy]$ ]]; then
           git rebase -i HEAD~$num_commits
       fi
   }
   
   # Remove large files from history
   remove_large_files() {
       echo "🗑️ Removing large files from history..."
       
       # Find large files
       echo "Finding large files in repository history..."
       
       # List large files
       git rev-list --objects --all |
         git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
         sed -n 's/^blob //p' |
         sort -k2 -n -r |
         head -20 |
         cut -f3- -d' ' |
         numfmt --field=1 --to=iec-i --suffix=B |
         column -t
       
       read -p "Enter filename to remove from history: " filename
       
       if [ -n "$filename" ]; then
           echo "⚠️  This will rewrite history! Make sure to coordinate with your team."
           read -p "Remove '$filename' from entire history? (y/n): " -n 1 -r
           echo
           
           if [[ $REPLY =~ ^[Yy]$ ]]; then
               git filter-branch --tree-filter "rm -f '$filename'" -- --all
               echo "✅ File removed from history. You may need to force push."
           fi
       fi
   }
   ```
   ```

7. **Git Flow Integration**
   ```markdown
   ## Git Flow Workflow Support
   
   ### Automated Flow Operations
   #### Git Flow Commands
   ```bash
   #!/bin/bash
   
   # Initialize Git flow structure
   init_git_flow() {
       echo "🌊 Initializing Git Flow..."
       
       # Check current branches
       if git show-ref --verify --quiet refs/heads/develop; then
           echo "✅ develop branch exists"
       else
           echo "Creating develop branch..."
           git checkout -b develop
           git push -u origin develop
       fi
       
       # Set up Git flow config
       git config gitflow.branch.master main
       git config gitflow.branch.develop develop
       git config gitflow.prefix.feature feature/
       git config gitflow.prefix.release release/
       git config gitflow.prefix.hotfix hotfix/
       
       echo "✅ Git Flow initialized"
   }
   
   # Start feature branch
   start_feature() {
       local feature_name=$1
       
       if [ -z "$feature_name" ]; then
           read -p "Feature name: " feature_name
       fi
       
       # Ensure on develop
       git checkout develop
       git pull origin develop
       
       # Create feature branch
       git checkout -b "feature/$feature_name"
       
       echo "✅ Started feature: feature/$feature_name"
       echo "When done, run: finish_feature $feature_name"
   }
   
   # Finish feature branch
   finish_feature() {
       local feature_name=$1
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       
       if [[ ! $current_branch =~ ^feature/ ]]; then
           echo "❌ Not on a feature branch!"
           return 1
       fi
       
       # Update develop
       git checkout develop
       git pull origin develop
       
       # Merge feature
       git merge --no-ff "$current_branch" -m "Merge $current_branch into develop"
       
       # Delete feature branch
       git branch -d "$current_branch"
       
       echo "✅ Feature completed and merged into develop"
       echo "Don't forget to push: git push origin develop"
   }
   
   # Start release
   start_release() {
       local version=$1
       
       if [ -z "$version" ]; then
           read -p "Release version (e.g., 1.2.0): " version
       fi
       
       # Ensure on develop
       git checkout develop
       git pull origin develop
       
       # Create release branch
       git checkout -b "release/$version"
       
       echo "✅ Started release: release/$version"
       echo "Perform release preparations, then run: finish_release $version"
   }
   
   # Create hotfix
   start_hotfix() {
       local version=$1
       
       if [ -z "$version" ]; then
           read -p "Hotfix version (e.g., 1.2.1): " version
       fi
       
       # Start from main/master
       git checkout main
       git pull origin main
       
       # Create hotfix branch
       git checkout -b "hotfix/$version"
       
       echo "✅ Started hotfix: hotfix/$version"
       echo "After fixing, run: finish_hotfix $version"
   }
   ```
   ```

8. **GitHub CLI Integration Setup**
   ```markdown
   ## GitHub CLI Configuration and Enhancement
   
   ### GitHub CLI Setup and Authentication
   #### GitHub Integration Functions
   ```bash
   #!/bin/bash
   
   # Setup GitHub CLI integration
   setup_github_cli() {
       echo "🐙 GitHub CLI Setup and Configuration"
       
       # Check if gh is installed
       if ! command -v gh >/dev/null 2>&1; then
           echo "❌ GitHub CLI is not installed!"
           echo ""
           echo "📦 Installation options:"
           echo "  macOS: brew install gh"
           echo "  Ubuntu/Debian: sudo apt install gh"
           echo "  Windows: winget install GitHub.cli"
           echo "  Other: https://cli.github.com/"
           return 1
       fi
       
       echo "✅ GitHub CLI is installed: $(gh --version | head -1)"
       
       # Check authentication
       if ! gh auth status >/dev/null 2>&1; then
           echo "🔐 Setting up GitHub authentication..."
           echo "Choose authentication method:"
           echo "1. Login with web browser"
           echo "2. Login with token"
           
           read -p "Choose option (1-2): " auth_option
           
           case $auth_option in
               1) gh auth login --web ;;
               2) gh auth login --with-token ;;
               *) echo "Invalid option" && return 1 ;;
           esac
       else
           echo "✅ Already authenticated with GitHub"
           gh auth status
       fi
       
       # Configure default settings
       echo -e "\n⚙️ Configuring GitHub CLI defaults..."
       
       # Set default editor
       read -p "Set default editor for GitHub CLI (current: $(gh config get editor 2>/dev/null || echo 'not set')): " editor
       if [ -n "$editor" ]; then
           gh config set editor "$editor"
       fi
       
       # Set default repository for PR operations
       if git remote get-url origin >/dev/null 2>&1; then
           echo "Setting default repository to current origin..."
           gh repo set-default
       fi
       
       echo "✅ GitHub CLI setup complete!"
   }
   
   # Enhanced PR management with GitHub CLI
   manage_github_prs() {
       echo "📋 GitHub Pull Request Management"
       
       if ! command -v gh >/dev/null 2>&1; then
           echo "❌ GitHub CLI not installed. Run setup_github_cli first."
           return 1
       fi
       
       echo ""
       echo "PR Management Options:"
       echo "1. List all PRs"
       echo "2. View PR details"
       echo "3. Check PR status"
       echo "4. Review PR"
       echo "5. Merge PR"
       echo "6. Close PR"
       echo "7. Convert to draft"
       echo "8. Ready for review"
       
       read -p "Choose option (1-8): " pr_option
       
       case $pr_option in
           1) 
               echo "📋 All Pull Requests:"
               gh pr list --state all
               ;;
           2)
               gh pr list --state open
               read -p "Enter PR number to view: " pr_number
               gh pr view "$pr_number"
               ;;
           3)
               gh pr list --state open
               read -p "Enter PR number to check: " pr_number
               gh pr status "$pr_number"
               gh pr checks "$pr_number"
               ;;
           4)
               gh pr list --state open
               read -p "Enter PR number to review: " pr_number
               gh pr review "$pr_number" --comment
               ;;
           5)
               gh pr list --state open --json number,title,headRefName
               read -p "Enter PR number to merge: " pr_number
               
               echo "Merge options:"
               echo "1. Merge commit"
               echo "2. Squash and merge"
               echo "3. Rebase and merge"
               
               read -p "Choose merge type (1-3): " merge_type
               
               case $merge_type in
                   1) gh pr merge "$pr_number" --merge ;;
                   2) gh pr merge "$pr_number" --squash ;;
                   3) gh pr merge "$pr_number" --rebase ;;
                   *) echo "Invalid option" ;;
               esac
               ;;
           6)
               gh pr list --state open
               read -p "Enter PR number to close: " pr_number
               read -p "Reason for closing: " reason
               gh pr close "$pr_number" --comment "$reason"
               ;;
           7)
               gh pr list --state open
               read -p "Enter PR number to convert to draft: " pr_number
               gh pr ready "$pr_number" --undo
               ;;
           8)
               gh pr list --state draft
               read -p "Enter PR number to mark ready: " pr_number
               gh pr ready "$pr_number"
               ;;
           *) echo "Invalid option" ;;
       esac
   }
   
   # GitHub repository insights
   github_repo_insights() {
       echo "📊 GitHub Repository Insights"
       
       if ! command -v gh >/dev/null 2>&1; then
           echo "❌ GitHub CLI not installed."
           return 1
       fi
       
       # Repository information
       echo -e "\n📁 Repository Information:"
       gh repo view --json name,description,defaultBranch,visibility,stargazerCount,forkCount,createdAt,updatedAt
       
       # Recent activity
       echo -e "\n📈 Recent Activity:"
       echo "Recent Issues:"
       gh issue list --limit 5 --state all
       
       echo -e "\nRecent Pull Requests:"
       gh pr list --limit 5 --state all
       
       echo -e "\nRecent Releases:"
       gh release list --limit 5
       
       # Workflow runs
       echo -e "\n⚙️ GitHub Actions Status:"
       gh run list --limit 10
       
       # Contributors
       echo -e "\n👥 Top Contributors:"
       gh api repos/:owner/:repo/contributors --paginate | jq -r '.[] | "\(.contributions) \(.login)"' | sort -rn | head -10
   }
   ```
   ```

9. **Comprehensive Workflow Analysis**
   ```markdown
   ## Repository Analytics and Insights
   
   ### Workflow Health Check
   ```bash
   #!/bin/bash
   
   # Comprehensive Git workflow analysis
   analyze_git_workflow() {
       echo "📊 Git Workflow Analysis Report"
       echo "=============================="
       
       # Repository info
       echo -e "\n📁 Repository Information:"
       echo "Remote: $(git remote get-url origin)"
       echo "Current branch: $(git rev-parse --abbrev-ref HEAD)"
       echo "Default branch: $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"
       
       # Branch statistics
       echo -e "\n🌳 Branch Statistics:"
       local total_branches=$(git branch -r | wc -l)
       local active_branches=$(git for-each-ref --format='%(refname:short) %(committerdate)' refs/remotes | awk '$2 > "'$(date -d '30 days ago' '+%Y-%m-%d')'"' | wc -l)
       local stale_branches=$((total_branches - active_branches))
       
       echo "Total remote branches: $total_branches"
       echo "Active branches (30 days): $active_branches"
       echo "Stale branches: $stale_branches"
       
       # Commit statistics
       echo -e "\n📈 Commit Statistics (last 30 days):"
       local total_commits=$(git log --since="30 days ago" --oneline | wc -l)
       local contributors=$(git log --since="30 days ago" --format="%an" | sort -u | wc -l)
       local conventional_commits=$(git log --since="30 days ago" --pretty=format:"%s" | grep -E "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)" | wc -l)
       
       echo "Total commits: $total_commits"
       echo "Active contributors: $contributors"
       echo "Conventional commits: $conventional_commits ($(( conventional_commits * 100 / total_commits ))%)"
       
       # Top contributors
       echo -e "\n👥 Top Contributors (last 30 days):"
       git log --since="30 days ago" --format="%an" | sort | uniq -c | sort -rn | head -5
       
       # Workflow patterns
       echo -e "\n🔄 Workflow Patterns:"
       if git branch -r | grep -q "develop"; then
           echo "✅ Git Flow detected (has develop branch)"
       elif git branch -r | grep -q "staging"; then
           echo "✅ Environment-based flow detected (has staging branch)"
       else
           echo "ℹ️  Simple workflow (direct to main/master)"
       fi
       
       # PR/MR readiness
       echo -e "\n🚀 Pull Request Readiness:"
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       if [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
           local behind=$(git rev-list --count HEAD..origin/$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'))
           local ahead=$(git rev-list --count origin/$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')..HEAD)
           
           echo "Current branch: $current_branch"
           echo "Commits behind default: $behind"
           echo "Commits ahead: $ahead"
           
           if [ $behind -gt 0 ]; then
               echo "⚠️  Branch needs updating from default branch"
           else
               echo "✅ Branch is up to date"
           fi
       fi
       
       # Recommendations
       echo -e "\n💡 Recommendations:"
       if [ $stale_branches -gt 10 ]; then
           echo "- Run branch cleanup to remove $stale_branches stale branches"
       fi
       
       if [ $(( conventional_commits * 100 / total_commits )) -lt 80 ]; then
           echo "- Improve commit message quality (currently $(( conventional_commits * 100 / total_commits ))% conventional)"
       fi
       
       if [ $behind -gt 0 ] && [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
           echo "- Update current branch from default branch before creating PR"
       fi
   }
   ```
   ```

## Usage Examples

```bash
# Setup GitHub CLI integration
/git-workflow --gh-setup

# Clean up merged and stale branches
/git-workflow --branch-cleanup

# Validate and improve commit messages
/git-workflow --commit-check

# Prepare branch for pull request with automatic GitHub PR creation
/git-workflow --pr-prepare

# Assist with merge conflict resolution
/git-workflow --conflict-assist

# Optimize Git history safely
/git-workflow --history-optimize

# Use specific Git flow
/git-workflow --flow git-flow start feature user-authentication

# Complete workflow analysis with GitHub insights
/git-workflow

# GitHub CLI specific operations
gh pr create --draft --title "feat: add user authentication" --body "$(cat .pr-description.md)"
gh pr merge 123 --squash
gh pr review 123 --approve --body "LGTM! Great work on the authentication system."
gh repo view --web
```

**Git Workflow Quality Standards:**
- All branches should follow naming conventions
- Commit messages must follow conventional commits
- Branches should be cleaned up after merging
- PR preparation should include all quality checks with GitHub CLI automation
- History should be clean and meaningful
- Conflicts should be resolved systematically
- Team workflows should be consistent and documented
- GitHub CLI should be configured for seamless integration
- PRs should be created automatically with proper templates and metadata