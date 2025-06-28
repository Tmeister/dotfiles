# Changelog Generator

Generate comprehensive changelog from git commits, pull requests, and release tags following conventional changelog standards.

## Instructions

Analyze git history and generate a comprehensive changelog: **$ARGUMENTS**

**Flags:**
- `--since <date/tag>`: Generate changelog since specific date or tag (default: last tag)
- `--until <date/tag>`: Generate changelog until specific date or tag (default: HEAD)
- `--format <format>`: Output format - `markdown` (default), `json`, `yaml`
- `--output <file>`: Write to file instead of stdout
- `--unreleased`: Include unreleased changes section
- `--breaking`: Highlight breaking changes prominently
- `--contributors`: Include contributors section
- `--links`: Include PR/issue links when available

1. **Analyze Git Repository State**
   ```bash
   # Check if we're in a git repository
   git rev-parse --is-inside-work-tree
   
   # Get current branch and latest tag
   git branch --show-current
   git describe --tags --abbrev=0 2>/dev/null || echo "No tags found"
   
   # Determine date range for changelog
   SINCE=${1:-$(git describe --tags --abbrev=0 2>/dev/null || git log --reverse --format="%H" | head -1)}
   UNTIL=${2:-HEAD}
   ```

2. **Gather Commit History and Analysis**
   ```bash
   # Get all commits in range with detailed information
   git log ${SINCE}..${UNTIL} \
     --pretty=format:"%H|%h|%s|%b|%an|%ae|%ad|%P" \
     --date=short \
     --no-merges
   
   # Get merge commits and PR information
   git log ${SINCE}..${UNTIL} \
     --pretty=format:"%H|%h|%s|%b|%an|%ae|%ad" \
     --merges \
     --grep="Merge pull request\|Merge branch"
   
   # Count total commits and contributors
   COMMIT_COUNT=$(git rev-list ${SINCE}..${UNTIL} --count)
   CONTRIBUTOR_COUNT=$(git shortlog -sn ${SINCE}..${UNTIL} | wc -l)
   ```

3. **Commit Classification and Parsing**
   
   Classify commits using conventional commit patterns:
   
   ```typescript
   interface CommitClassification {
     breaking: string[];     // BREAKING CHANGE, feat!, fix!
     features: string[];     // feat:, feature:
     fixes: string[];        // fix:, bugfix:
     performance: string[];  // perf:, performance improvements
     refactor: string[];     // refactor:, code restructuring
     docs: string[];         // docs:, documentation
     style: string[];        // style:, formatting, lint
     test: string[];         // test:, testing
     build: string[];        // build:, ci:, chore: deps
     chore: string[];        // chore:, maintenance
     security: string[];     // security:, sec:, vulnerability
     deprecated: string[];   // deprecated:, deprecate:
     removed: string[];      // remove:, delete:
   }
   ```

4. **Extract Metadata from Commits**
   ```bash
   # Extract PR numbers from commit messages
   git log ${SINCE}..${UNTIL} --pretty=format:"%s" | \
     grep -oE "#[0-9]+" | sort | uniq
   
   # Extract issue references
   git log ${SINCE}..${UNTIL} --pretty=format:"%s %b" | \
     grep -oiE "(closes?|fixes?|resolves?) #[0-9]+" | sort | uniq
   
   # Extract co-authors
   git log ${SINCE}..${UNTIL} --pretty=format:"%b" | \
     grep -i "co-authored-by:" | sort | uniq
   
   # Get breaking change notices
   git log ${SINCE}..${UNTIL} --pretty=format:"%s %b" | \
     grep -i "BREAKING CHANGE"
   ```

5. **Version Determination**
   ```bash
   # Determine next version based on conventional commits
   CURRENT_VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0")
   
   # Check for breaking changes (major bump)
   HAS_BREAKING=$(git log ${SINCE}..${UNTIL} --grep="BREAKING CHANGE\|^.*!:" --oneline | wc -l)
   
   # Check for features (minor bump)
   HAS_FEATURES=$(git log ${SINCE}..${UNTIL} --grep="^feat:" --oneline | wc -l)
   
   # Check for fixes (patch bump)
   HAS_FIXES=$(git log ${SINCE}..${UNTIL} --grep="^fix:" --oneline | wc -l)
   
   # Calculate next version
   if [ $HAS_BREAKING -gt 0 ]; then
     VERSION_TYPE="major"
   elif [ $HAS_FEATURES -gt 0 ]; then
     VERSION_TYPE="minor"
   elif [ $HAS_FIXES -gt 0 ]; then
     VERSION_TYPE="patch"
   else
     VERSION_TYPE="patch"  # Default for any changes
   fi
   ```

6. **Generate Changelog Structure**

   **Standard Changelog Format:**
   ```markdown
   # Changelog
   
   All notable changes to this project will be documented in this file.
   
   The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
   and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
   
   ## [Unreleased]
   
   ## [${NEXT_VERSION}] - ${DATE}
   
   ### ⚠️ BREAKING CHANGES
   
   ${BREAKING_CHANGES}
   
   ### ✨ Added
   
   ${NEW_FEATURES}
   
   ### 🔄 Changed
   
   ${CHANGES_AND_IMPROVEMENTS}
   
   ### 🗑️ Deprecated
   
   ${DEPRECATED_FEATURES}
   
   ### 🚫 Removed
   
   ${REMOVED_FEATURES}
   
   ### 🐛 Fixed
   
   ${BUG_FIXES}
   
   ### 🔒 Security
   
   ${SECURITY_FIXES}
   
   ### 🏠 Internal
   
   ${INTERNAL_CHANGES}
   ```

7. **Detailed Commit Processing**
   
   For each commit:
   - Parse conventional commit format: `type(scope): description`
   - Extract breaking change indicators (`!` or `BREAKING CHANGE:`)
   - Extract scope for better categorization
   - Link to PR/issue numbers when available
   - Include commit hash for traceability
   
   **Commit Entry Format:**
   ```markdown
   - **scope**: Description of change ([commit-hash](link)) [#PR-number](pr-link)
   - Description of change without scope ([commit-hash](link))
   - **BREAKING**: Breaking change description ([commit-hash](link)) [#PR-number](pr-link)
   ```

8. **Contributors Section Generation**
   ```bash
   # Generate contributor list with commit counts
   git shortlog -sn ${SINCE}..${UNTIL} | \
     awk '{print "- " $2 " " $3 " (" $1 " commits)"}' | \
     head -20  # Limit to top 20 contributors
   
   # Include co-authors
   git log ${SINCE}..${UNTIL} --pretty=format:"%b" | \
     grep -i "co-authored-by:" | \
     sed 's/Co-authored-by: /- /' | \
     sort | uniq
   ```

9. **Statistics and Summary Generation**
   ```markdown
   ## Summary
   
   - **Version**: ${NEXT_VERSION}
   - **Release Date**: ${DATE}
   - **Total Commits**: ${COMMIT_COUNT}
   - **Contributors**: ${CONTRIBUTOR_COUNT}
   - **Breaking Changes**: ${BREAKING_COUNT}
   - **New Features**: ${FEATURE_COUNT}
   - **Bug Fixes**: ${FIX_COUNT}
   - **Files Changed**: ${FILES_CHANGED}
   ```

10. **Generate Links and References**
    ```markdown
    ## Links
    
    - [Full Changelog](${REPO_URL}/compare/${SINCE}...${UNTIL})
    - [Release Notes](${REPO_URL}/releases/tag/${NEXT_VERSION})
    - [Milestone](${REPO_URL}/milestone/${MILESTONE_NUMBER})
    - [Project Board](${REPO_URL}/projects/${PROJECT_NUMBER})
    ```

11. **Output Formatting Options**

    **Markdown (Default):**
    - Standard Keep a Changelog format
    - GitHub-flavored markdown
    - Emoji indicators for sections
    - Links to commits, PRs, and issues

    **JSON Format:**
    ```json
    {
      "version": "1.2.0",
      "date": "2024-01-15",
      "summary": {
        "commits": 45,
        "contributors": 8,
        "breaking": 1,
        "features": 12,
        "fixes": 8
      },
      "sections": {
        "breaking": [...],
        "added": [...],
        "changed": [...],
        "fixed": [...],
        "security": [...]
      },
      "contributors": [...],
      "links": {...}
    }
    ```

    **YAML Format:**
    ```yaml
    version: 1.2.0
    date: '2024-01-15'
    summary:
      commits: 45
      contributors: 8
      breaking: 1
      features: 12
      fixes: 8
    sections:
      breaking: [...]
      added: [...]
      changed: [...]
      fixed: [...]
      security: [...]
    contributors: [...]
    links: {}
    ```

12. **Advanced Features**

    **Scope-based Grouping:**
    ```markdown
    ### ✨ Added
    
    #### Authentication
    - Add OAuth2 support for Google login ([abc123f](link)) [#45](link)
    - Implement JWT token refresh mechanism ([def456g](link)) [#47](link)
    
    #### API
    - Add rate limiting middleware ([ghi789h](link)) [#52](link)
    - Implement GraphQL subscription support ([jkl012i](link)) [#55](link)
    ```

    **Breaking Change Highlighting:**
    ```markdown
    ### ⚠️ BREAKING CHANGES
    
    - **API**: Remove deprecated `/api/v1/users` endpoint ([abc123f](link)) [#78](link)
      
      **Migration:** Use `/api/v2/users` instead. See [migration guide](link) for details.
    
    - **Config**: Change database configuration format ([def456g](link)) [#82](link)
      
      **Migration:** Update `database.yml` to use new connection string format.
    ```

13. **Integration with Release Process**
    ```bash
    # Generate changelog and prepare release
    /changelog --since v1.1.0 --output CHANGELOG.md --unreleased
    
    # Update version in package files
    npm version ${NEXT_VERSION}
    
    # Create git tag
    git add CHANGELOG.md package.json
    git commit -m "chore: prepare release ${NEXT_VERSION}"
    git tag -a ${NEXT_VERSION} -m "Release ${NEXT_VERSION}"
    
    # Push to remote
    git push origin main --tags
    ```

14. **Error Handling and Validation**
    - Verify git repository exists
    - Check if specified tags/dates are valid
    - Handle empty commit ranges gracefully
    - Validate conventional commit format
    - Warn about commits that don't follow conventions
    - Suggest improvements for commit messages

15. **Customization Options**
    ```bash
    # Custom date ranges
    /changelog --since "2024-01-01" --until "2024-12-31"
    
    # Specific version ranges
    /changelog --since v1.0.0 --until v2.0.0
    
    # Output to file with specific format
    /changelog --output releases/v1.2.0.md --format markdown --contributors
    
    # Include only breaking changes and features
    /changelog --breaking --features-only
    
    # Generate release notes style
    /changelog --release-notes --template custom
    ```

## Usage Examples

```bash
# Generate changelog since last tag
/changelog

# Generate changelog for specific version range
/changelog --since v1.0.0 --until v2.0.0

# Generate with contributors and links
/changelog --contributors --links --output CHANGELOG.md

# Generate unreleased changes only
/changelog --unreleased --since HEAD~10

# Generate in JSON format for automation
/changelog --format json --output release-data.json

# Generate breaking changes summary
/changelog --breaking --since v1.0.0
```

**Quality Standards:**
- Follow conventional commit specifications
- Include proper semantic versioning guidance
- Provide clear migration instructions for breaking changes
- Link all changes to source commits and PRs
- Group related changes logically
- Highlight security-related changes
- Credit all contributors appropriately
- Generate machine-readable formats for automation