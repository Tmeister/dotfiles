# Project Cleanup Command

Systematically clean up technical debt, dead code, and improve code quality across the entire project.

## Instructions

Clean up technical debt and improve code quality: **$ARGUMENTS**

**Flags:**
- `--dry-run`: Show what would be cleaned without making changes
- `--category <type>`: Focus on specific cleanup category (comments, dead-code, formatting, etc.)
- `--aggressive`: Include more risky cleanup operations
- `--skip-tests`: Skip running tests between cleanup steps (faster but riskier)
- `--commit-each`: Create separate git commits for each cleanup category
- `--exclude <pattern>`: Exclude files/directories matching pattern
- `--since <date>`: Only clean up code older than specified date

1. **Pre-Cleanup Analysis and Safety Setup**
   ```bash
   # Ensure we're in a git repository with clean working tree
   git status --porcelain
   if [ $? -ne 0 ]; then
     echo "Working tree must be clean before cleanup"
     exit 1
   fi
   
   # Create backup branch
   BACKUP_BRANCH="cleanup-backup-$(date +%Y%m%d-%H%M%S)"
   git checkout -b $BACKUP_BRANCH
   git checkout -
   
   # Run initial test suite to establish baseline
   npm test || yarn test || python -m pytest || go test ./... || echo "No tests found"
   ```

2. **Scan and Identify Cleanup Targets**
   ```bash
   # Find TODO/FIXME/HACK comments
   rg -i "TODO|FIXME|HACK|XXX|BUG|TEMP" --type-add 'source:*.{js,ts,jsx,tsx,py,go,java,rb,php,cs,cpp,c,h}' -t source
   
   # Find commented-out code blocks
   rg -A 3 -B 1 "^\s*//.*[{}();]|^\s*#.*[{}();]|^\s*/\*.*\*/" --type-add 'source:*.{js,ts,jsx,tsx,py,go,java,rb,php,cs,cpp,c,h}' -t source
   
   # Find debug statements
   rg -i "console\.(log|debug|info|warn|error)|print\(|debugger|pdb\.set_trace|fmt\.Print" --type-add 'source:*.{js,ts,jsx,tsx,py,go,java,rb,php,cs,cpp,c,h}' -t source
   
   # Find unused imports (language-specific)
   # JavaScript/TypeScript
   npx eslint --ext .js,.ts,.jsx,.tsx --rule 'no-unused-vars: error' . || true
   
   # Python
   python -m pyflakes . 2>/dev/null || true
   
   # Go
   go vet ./... 2>/dev/null || true
   ```

3. **Code Quality and Linting Fixes**
   ```bash
   # Run linters with auto-fix where possible
   
   # JavaScript/TypeScript
   if [ -f "package.json" ]; then
     npx eslint --fix --ext .js,.ts,.jsx,.tsx .
     npx prettier --write "**/*.{js,ts,jsx,tsx,json,css,md}"
     
     # TypeScript specific
     npx tsc --noEmit --strict || true
   fi
   
   # Python
   if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
     python -m black . || true
     python -m isort . || true
     python -m autoflake --remove-all-unused-imports --recursive --in-place . || true
   fi
   
   # Go
   if [ -f "go.mod" ]; then
     go fmt ./...
     goimports -w . || true
     golangci-lint run --fix || true
   fi
   
   # Rust
   if [ -f "Cargo.toml" ]; then
     cargo fmt
     cargo clippy --fix --allow-dirty || true
   fi
   ```

4. **Remove Debug Statements and Logging**
   ```bash
   # Remove console.log statements (but preserve intentional logging)
   rg -l "console\.(log|debug)" --type-add 'js:*.{js,ts,jsx,tsx}' -t js | \
   xargs sed -i.bak '/console\.\(log\|debug\)/d'
   
   # Remove Python print statements in non-main files
   rg -l "^\s*print\(" --type py | \
   grep -v "__main__" | \
   xargs sed -i.bak '/^\s*print(/d'
   
   # Remove debugger statements
   rg -l "debugger;" --type-add 'js:*.{js,ts,jsx,tsx}' -t js | \
   xargs sed -i.bak '/debugger;/d'
   
   # Remove pdb traces
   rg -l "pdb\.set_trace\(\)" --type py | \
   xargs sed -i.bak '/pdb\.set_trace()/d'
   
   # Clean up backup files
   find . -name "*.bak" -delete
   ```

5. **Remove Commented-Out Code**
   ```bash
   # Find and remove old commented-out code (older than 3 months)
   # This requires manual review for safety
   
   # Create list of commented code blocks for review
   rg -n "^\s*//.*[{}();=]" --type-add 'js:*.{js,ts,jsx,tsx}' -t js > commented_code_review.txt
   rg -n "^\s*#.*[{}();=]" --type py >> commented_code_review.txt
   
   # Use git blame to find old commented code
   for file in $(rg -l "^\s*//.*[{}();=]" --type-add 'js:*.{js,ts,jsx,tsx}' -t js); do
     git blame "$file" | grep "^\s*//" | awk '{print $1}' | \
     xargs -I {} git show --format="%ci" {} | head -1
   done
   ```

6. **Dead Code and Unused Import Removal**
   ```bash
   # JavaScript/TypeScript - Remove unused imports
   if command -v ts-unused-exports &> /dev/null; then
     ts-unused-exports tsconfig.json
   fi
   
   # Python - Remove unused imports
   if command -v unimport &> /dev/null; then
     unimport --remove-all --check --diff .
   fi
   
   # Remove empty files
   find . -type f -name "*.js" -o -name "*.ts" -o -name "*.py" | \
   xargs -I {} sh -c 'if [ ! -s "{}" ]; then echo "Empty file: {}"; fi'
   
   # Find potentially unused files (no references)
   for file in $(find . -name "*.js" -o -name "*.ts" | grep -v node_modules | grep -v ".d.ts"); do
     basename=$(basename "$file" | sed 's/\.[^.]*$//')
     if ! rg -q "$basename" --type-add 'source:*.{js,ts,jsx,tsx}' -t source; then
       echo "Potentially unused file: $file"
     fi
   done
   ```

7. **Modernize Code Syntax**
   ```bash
   # JavaScript: Convert var to let/const
   rg -l "^\s*var\s" --type js | \
   xargs sed -i.bak 's/^\(\s*\)var\(\s\)/\1let\2/g'
   
   # Update function declarations to arrow functions (where appropriate)
   # This requires more sophisticated tooling like jscodeshift
   
   # Python: Update print statements to print functions (Python 2 to 3)
   rg -l "print\s[^(]" --type py | \
   xargs sed -i.bak 's/print\s\+\([^(].*\)/print(\1)/g'
   
   # Clean up backup files
   find . -name "*.bak" -delete
   ```

8. **Consolidate Code Duplication**
   ```bash
   # Find duplicate code blocks (requires jscpd or similar tool)
   if command -v jscpd &> /dev/null; then
     jscpd --threshold 50 --min-lines 5 --formats javascript,typescript,python .
   fi
   
   # Find similar function signatures
   rg "function\s+\w+\(" --type js -A 3 | sort | uniq -c | sort -nr
   rg "def\s+\w+\(" --type py -A 3 | sort | uniq -c | sort -nr
   
   # Identify potential utility functions
   rg -c "function\s+\w+(.*)" --type js | sort -nr -t: -k2 | head -20
   ```

9. **Update Deprecated API Usage**
   ```bash
   # Find deprecated jQuery methods
   rg "\$\(.*\)\.(live|bind|unbind|delegate|undelegate)" --type js
   
   # Find deprecated React patterns
   rg "componentWillMount|componentWillReceiveProps|componentWillUpdate" --type-add 'react:*.{js,jsx,ts,tsx}' -t react
   
   # Find deprecated Node.js APIs
   rg "require\('util'\)\.isArray|Buffer\(\)" --type js
   
   # Python deprecated patterns
   rg "imp\s+\w+|from\s+imp\s+import" --type py
   
   # Generate deprecation report
   echo "## Deprecated API Usage Report" > deprecation_report.md
   echo "Generated on: $(date)" >> deprecation_report.md
   ```

10. **File and Directory Organization**
    ```bash
    # Find and remove empty directories
    find . -type d -empty -not -path "./node_modules/*" -not -path "./.git/*"
    
    # Organize imports (requires tooling)
    if command -v organize-imports-cli &> /dev/null; then
      organize-imports-cli --write "**/*.{ts,tsx}"
    fi
    
    # Fix file extensions
    find . -name "*.jsx" -exec sh -c 'if ! grep -q "React\|JSX" "$1"; then mv "$1" "${1%.jsx}.js"; fi' _ {} \;
    
    # Detect circular dependencies
    if command -v madge &> /dev/null; then
      madge --circular --extensions js,ts .
    fi
    ```

11. **Documentation and Comment Cleanup**
    ```bash
    # Find outdated comments with years
    rg "20[0-1][0-9]" --type js | grep -E "//|/\*" | grep -v $(date +%Y)
    
    # Find TODO comments older than 6 months
    for file in $(rg -l "TODO" --type-add 'source:*.{js,ts,jsx,tsx,py,go,java,rb,php,cs,cpp,c,h}' -t source); do
      git blame "$file" | grep "TODO" | while read line; do
        commit=$(echo "$line" | awk '{print $1}')
        date=$(git show -s --format="%ci" "$commit")
        echo "$file: $date - $line"
      done
    done
    
    # Update broken documentation links
    rg -l "http[s]?://[^\s)]+" . | xargs -I {} sh -c 'echo "Checking links in: {}"'
    ```

12. **Dependency and Configuration Cleanup**
    ```bash
    # Remove unused npm dependencies
    if command -v depcheck &> /dev/null; then
      depcheck --json > unused_deps.json
    fi
    
    # Clean up package-lock.json and node_modules
    if [ -f "package.json" ]; then
      rm -rf node_modules package-lock.json yarn.lock
      npm install
    fi
    
    # Python: Remove unused requirements
    if [ -f "requirements.txt" ] && command -v pip-check-reqs &> /dev/null; then
      pip-check-reqs --ignore-files
    fi
    
    # Clean up build artifacts
    rm -rf dist/ build/ .next/ .nuxt/ *.egg-info/ __pycache__/ .pytest_cache/
    ```

13. **Testing and Validation**
    ```bash
    # Run tests after each major cleanup category
    TEST_CMD="npm test"  # or appropriate test command
    
    echo "Running tests after cleanup..."
    if ! $TEST_CMD; then
      echo "Tests failed after cleanup. Check recent changes."
      git status
      exit 1
    fi
    
    # Check for build errors
    if [ -f "package.json" ]; then
      npm run build || yarn build || true
    fi
    
    # Validate TypeScript compilation
    if [ -f "tsconfig.json" ]; then
      npx tsc --noEmit
    fi
    ```

14. **Generate Cleanup Report**
    ```bash
    # Create comprehensive cleanup report
    cat > cleanup_report.md << EOF
    # Project Cleanup Report
    
    **Date**: $(date)
    **Branch**: $(git branch --show-current)
    **Commit**: $(git rev-parse --short HEAD)
    
    ## Summary
    
    ### Files Modified
    \`\`\`
    $(git diff --name-only --cached | wc -l) files changed
    $(git diff --cached --shortstat)
    \`\`\`
    
    ### Cleanup Categories
    
    #### Code Quality
    - Linting errors fixed
    - Formatting standardized
    - Modern syntax applied
    
    #### Dead Code Removal
    - Debug statements removed
    - Commented code cleaned
    - Unused imports deleted
    
    #### File Organization
    - Empty files/directories removed
    - Imports organized
    - Dependencies cleaned
    
    ### Performance Impact
    - Bundle size reduction: TBD
    - Load time improvement: TBD
    - Memory usage: TBD
    
    ### Risk Assessment
    - **Low Risk**: Formatting, linting fixes
    - **Medium Risk**: Dead code removal
    - **High Risk**: API updates, major refactoring
    
    ### Next Steps
    1. Review all changes carefully
    2. Run comprehensive test suite
    3. Perform manual testing of critical paths
    4. Consider gradual deployment
    
    EOF
    ```

15. **Commit Strategy and Documentation**
    ```bash
    # Create structured commits for different cleanup types
    if [ "$COMMIT_EACH" = "true" ]; then
      # Stage and commit linting fixes
      git add .
      git commit -m "style: fix linting errors and apply formatting
      
      - Fix ESLint/TSLint violations
      - Apply Prettier formatting
      - Standardize code style"
      
      # Stage and commit dead code removal
      git add .
      git commit -m "refactor: remove dead code and debug statements
      
      - Remove console.log/print debug statements
      - Clean up commented-out code blocks
      - Delete unused imports and variables"
      
      # Stage and commit modernization
      git add .
      git commit -m "refactor: modernize code syntax and patterns
      
      - Convert var to let/const
      - Update to modern JavaScript/Python patterns
      - Replace deprecated API usage"
    else
      # Single comprehensive commit
      git add .
      git commit -m "refactor: comprehensive project cleanup
      
      - Fix linting errors and apply consistent formatting
      - Remove debug statements and commented code
      - Clean up unused imports and dead code
      - Modernize syntax and update deprecated APIs
      - Organize file structure and dependencies
      
      Reduces technical debt and improves code maintainability."
    fi
    ```

16. **Safety Measures and Rollback**
    ```bash
    # Create rollback script
    cat > rollback_cleanup.sh << 'EOF'
    #!/bin/bash
    echo "Rolling back cleanup changes..."
    git reset --hard HEAD~1
    echo "Cleanup rolled back. Review changes and re-run if needed."
    EOF
    chmod +x rollback_cleanup.sh
    
    # Document what was changed
    git diff HEAD~1 --stat > changes_summary.txt
    git diff HEAD~1 --name-only > changed_files.txt
    ```

17. **Advanced Cleanup Options**
    ```bash
    # Aggressive cleanup (use with caution)
    if [ "$AGGRESSIVE" = "true" ]; then
      # Remove all TODO comments older than 1 year
      # Automatically fix some code patterns
      # Remove experimental/feature flag code
      # Clean up test files with no assertions
      
      echo "Running aggressive cleanup..."
      echo "This mode removes more code and makes larger changes."
      echo "Ensure you have proper backups and test coverage."
    fi
    
    # Category-specific cleanup
    case "$CATEGORY" in
      "comments")
        # Only clean up comments and documentation
        ;;
      "dead-code")
        # Only remove unused/dead code
        ;;
      "formatting")
        # Only fix formatting and style
        ;;
      "deps")
        # Only clean up dependencies
        ;;
    esac
    ```

## Usage Examples

```bash
# Basic project cleanup
/clean-up-project

# Dry run to see what would be cleaned
/clean-up-project --dry-run

# Focus on specific cleanup category
/clean-up-project --category dead-code

# Aggressive cleanup with separate commits
/clean-up-project --aggressive --commit-each

# Clean up excluding certain directories
/clean-up-project --exclude "vendor/*,third_party/*"

# Clean up only recent code
/clean-up-project --since "3 months ago"

# Skip tests for faster cleanup (riskier)
/clean-up-project --skip-tests --dry-run
```

**Safety Guidelines:**
- Always run with `--dry-run` first
- Ensure tests pass before starting
- Create backup branch automatically
- Review changes before committing
- Test thoroughly after cleanup
- Document all removed functionality
- Keep cleanup commits focused and atomic