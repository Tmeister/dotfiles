# WordPress Plugin Version Manager

Intelligently manage WordPress plugin versions using SemVer by analyzing git diffs and automatically updating version numbers across all plugin files.

## Instructions

Analyze git changes and manage WordPress plugin versions systematically: **$ARGUMENTS**

**Flags:**
- `--analyze`: Analyze changes and suggest version increment
- `--update <version>`: Update to specific version
- `--auto`: Automatically determine and apply version based on changes
- `--dry-run`: Show what would be changed without applying updates
- `--files`: List all files that contain version references

1. **Plugin Analysis and Version Discovery**
   ```markdown
   ## WordPress Plugin Version Detection
   
   ### Current Version Analysis
   ```bash
   #!/bin/bash
   
   # Find main plugin file
   find_main_plugin_file() {
       echo "🔍 Detecting main WordPress plugin file..."
       
       # Look for plugin files with plugin headers
       main_files=$(find . -name "*.php" -not -path "./vendor/*" -not -path "./node_modules/*" -exec grep -l "Plugin Name:" {} \; 2>/dev/null)
       
       if [ -z "$main_files" ]; then
           echo "❌ No WordPress plugin files found!"
           return 1
       fi
       
       # If multiple files, prefer the one in root directory
       for file in $main_files; do
           if [[ "$file" == "./"*".php" ]] && [[ "$file" != *"/"*"/"* ]]; then
               echo "📄 Main plugin file: $file"
               echo "$file"
               return 0
           fi
       done
       
       # Use first found file
       main_file=$(echo "$main_files" | head -1)
       echo "📄 Main plugin file: $main_file"
       echo "$main_file"
   }
   
   # Extract current version from main plugin file
   get_current_version() {
       local main_file=$(find_main_plugin_file)
       
       if [ -z "$main_file" ]; then
           return 1
       fi
       
       # Extract version from plugin header
       local version=$(grep -i "Version:" "$main_file" | head -1 | sed 's/.*Version:[[:space:]]*//' | sed 's/[[:space:]]*$//' | tr -d '\r')
       
       if [ -z "$version" ]; then
           echo "❌ Could not find version in plugin header!"
           return 1
       fi
       
       echo "📌 Current version: $version"
       echo "$version"
   }
   
   # Find all files containing version references
   find_version_files() {
       local current_version=$(get_current_version)
       
       if [ -z "$current_version" ]; then
           return 1
       fi
       
       echo "🔍 Finding all files with version references..."
       
       # Common patterns where version might be referenced
       version_patterns=(
           "Version: $current_version"
           "version.*$current_version"
           "'$current_version'"
           "\"$current_version\""
           "define.*VERSION.*$current_version"
           "const.*VERSION.*$current_version"
       )
       
       echo "Files containing version $current_version:"
       
       for pattern in "${version_patterns[@]}"; do
           grep -r -l "$pattern" . \
               --include="*.php" \
               --include="*.json" \
               --include="*.md" \
               --include="*.txt" \
               --include="*.js" \
               --exclude-dir=vendor \
               --exclude-dir=node_modules \
               --exclude-dir=.git \
               2>/dev/null | sort -u
       done | sort -u
   }
   ```
   ```

2. **Git Diff Analysis for SemVer Classification**
   ```markdown
   ## Change Impact Analysis
   
   ### SemVer Classification Logic
   ```bash
   #!/bin/bash
   
   # Analyze git diff to determine version increment type
   analyze_changes() {
       echo "📊 Analyzing changes for SemVer classification..."
       
       local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@' 2>/dev/null || echo "main")
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       
       echo "Comparing $current_branch with $default_branch..."
       
       # Get diff between branches
       local diff_output=$(git diff $default_branch...HEAD)
       
       if [ -z "$diff_output" ]; then
           echo "ℹ️  No changes detected between branches"
           return 0
       fi
       
       # Initialize change indicators
       local has_breaking_changes=false
       local has_new_features=false
       local has_bug_fixes=false
       
       # Analyze added/removed functions and classes
       echo -e "\n🔍 Analyzing code changes..."
       
       # Check for breaking changes
       local removed_functions=$(echo "$diff_output" | grep -E "^-.*function [a-zA-Z_]" | wc -l)
       local removed_classes=$(echo "$diff_output" | grep -E "^-.*class [a-zA-Z_]" | wc -l)
       local removed_hooks=$(echo "$diff_output" | grep -E "^-.*add_(action|filter)" | wc -l)
       local modified_signatures=$(echo "$diff_output" | grep -E "^[\+\-].*function [a-zA-Z_].*\(" | sort | uniq -d | wc -l)
       
       if [ $removed_functions -gt 0 ] || [ $removed_classes -gt 0 ] || [ $removed_hooks -gt 0 ] || [ $modified_signatures -gt 0 ]; then
           echo "💥 BREAKING CHANGES detected:"
           [ $removed_functions -gt 0 ] && echo "  - Removed functions: $removed_functions"
           [ $removed_classes -gt 0 ] && echo "  - Removed classes: $removed_classes"
           [ $removed_hooks -gt 0 ] && echo "  - Removed hooks: $removed_hooks"
           [ $modified_signatures -gt 0 ] && echo "  - Modified function signatures: $modified_signatures"
           has_breaking_changes=true
       fi
       
       # Check for new features
       local new_functions=$(echo "$diff_output" | grep -E "^\+.*function [a-zA-Z_]" | wc -l)
       local new_classes=$(echo "$diff_output" | grep -E "^\+.*class [a-zA-Z_]" | wc -l)
       local new_hooks=$(echo "$diff_output" | grep -E "^\+.*add_(action|filter)" | wc -l)
       local new_endpoints=$(echo "$diff_output" | grep -E "^\+.*register_rest_route" | wc -l)
       local new_shortcodes=$(echo "$diff_output" | grep -E "^\+.*add_shortcode" | wc -l)
       
       if [ $new_functions -gt 0 ] || [ $new_classes -gt 0 ] || [ $new_hooks -gt 0 ] || [ $new_endpoints -gt 0 ] || [ $new_shortcodes -gt 0 ]; then
           echo "✨ NEW FEATURES detected:"
           [ $new_functions -gt 0 ] && echo "  - New functions: $new_functions"
           [ $new_classes -gt 0 ] && echo "  - New classes: $new_classes"
           [ $new_hooks -gt 0 ] && echo "  - New hooks: $new_hooks"
           [ $new_endpoints -gt 0 ] && echo "  - New REST endpoints: $new_endpoints"
           [ $new_shortcodes -gt 0 ] && echo "  - New shortcodes: $new_shortcodes"
           has_new_features=true
       fi
       
       # Check for bug fixes
       local fix_patterns=(
           "fix"
           "bug"
           "issue"
           "error"
           "problem"
           "correct"
           "resolve"
       )
       
       local bug_fix_indicators=0
       for pattern in "${fix_patterns[@]}"; do
           bug_fix_indicators=$((bug_fix_indicators + $(echo "$diff_output" | grep -i "$pattern" | wc -l)))
       done
       
       # Check commit messages for fix patterns
       local fix_commits=$(git log $default_branch..HEAD --oneline | grep -iE "(fix|bug|issue|resolve)" | wc -l)
       
       if [ $bug_fix_indicators -gt 0 ] || [ $fix_commits -gt 0 ]; then
           echo "🐛 BUG FIXES detected:"
           [ $bug_fix_indicators -gt 0 ] && echo "  - Fix-related code changes: $bug_fix_indicators"
           [ $fix_commits -gt 0 ] && echo "  - Fix-related commits: $fix_commits"
           has_bug_fixes=true
       fi
       
       # Determine version increment
       echo -e "\n📈 SemVer Recommendation:"
       if [ "$has_breaking_changes" = true ]; then
           echo "🔴 MAJOR version increment recommended (breaking changes)"
           echo "MAJOR"
       elif [ "$has_new_features" = true ]; then
           echo "🟡 MINOR version increment recommended (new features)"
           echo "MINOR"
       elif [ "$has_bug_fixes" = true ]; then
           echo "🟢 PATCH version increment recommended (bug fixes)"
           echo "PATCH"
       else
           echo "ℹ️  No significant changes detected"
           echo "NONE"
       fi
   }
   
   # Calculate next version based on current version and increment type
   calculate_next_version() {
       local current_version=$1
       local increment_type=$2
       
       # Parse semantic version (major.minor.patch)
       if [[ ! $current_version =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
           echo "❌ Invalid semantic version format: $current_version"
           echo "Expected format: MAJOR.MINOR.PATCH (e.g., 1.2.3)"
           return 1
       fi
       
       local major=${BASH_REMATCH[1]}
       local minor=${BASH_REMATCH[2]}
       local patch=${BASH_REMATCH[3]}
       
       case $increment_type in
           "MAJOR")
               major=$((major + 1))
               minor=0
               patch=0
               ;;
           "MINOR")
               minor=$((minor + 1))
               patch=0
               ;;
           "PATCH")
               patch=$((patch + 1))
               ;;
           *)
               echo "❌ Invalid increment type: $increment_type"
               return 1
               ;;
       esac
       
       echo "$major.$minor.$patch"
   }
   ```
   ```

3. **Version Update Implementation**
   ```markdown
   ## Version Update System
   
   ### Update All Version References
   ```bash
   #!/bin/bash
   
   # Update version in all relevant files
   update_plugin_version() {
       local current_version=$1
       local new_version=$2
       local dry_run=${3:-false}
       
       if [ -z "$current_version" ] || [ -z "$new_version" ]; then
           echo "❌ Both current and new versions are required"
           return 1
       fi
       
       echo "🔄 Updating version from $current_version to $new_version"
       
       if [ "$dry_run" = true ]; then
           echo "🏃 DRY RUN MODE - No files will be modified"
       fi
       
       local main_file=$(find_main_plugin_file)
       local files_updated=0
       
       # Update main plugin file header
       if [ -n "$main_file" ]; then
           echo "📝 Updating main plugin file: $main_file"
           
           if [ "$dry_run" = false ]; then
               # Update Version header
               sed -i.bak "s/Version: $current_version/Version: $new_version/g" "$main_file"
               
               # Update version constants/variables
               sed -i.bak "s/define.*VERSION.*'$current_version'/define('VERSION', '$new_version')/g" "$main_file"
               sed -i.bak "s/define.*VERSION.*\"$current_version\"/define('VERSION', \"$new_version\")/g" "$main_file"
               
               # Clean up backup file
               rm -f "$main_file.bak"
           else
               echo "  Would update: Version header and constants"
           fi
           
           files_updated=$((files_updated + 1))
       fi
       
       # Update other PHP files with version references
       echo "🔍 Searching for other version references..."
       
       local php_files=$(find . -name "*.php" -not -path "./vendor/*" -not -path "./node_modules/*")
       
       for file in $php_files; do
           if grep -q "$current_version" "$file" 2>/dev/null; then
               echo "📝 Updating PHP file: $file"
               
               if [ "$dry_run" = false ]; then
                   # Update version strings
                   sed -i.bak "s/'$current_version'/'$new_version'/g" "$file"
                   sed -i.bak "s/\"$current_version\"/\"$new_version\"/g" "$file"
                   sed -i.bak "s/VERSION.*$current_version/VERSION', '$new_version/g" "$file"
                   
                   # Clean up backup file
                   rm -f "$file.bak"
               else
                   echo "  Would update: version strings"
               fi
               
               files_updated=$((files_updated + 1))
           fi
       done
       
       # Update package.json if exists
       if [ -f "package.json" ] && grep -q "$current_version" "package.json"; then
           echo "📝 Updating package.json"
           
           if [ "$dry_run" = false ]; then
               sed -i.bak "s/\"version\": \"$current_version\"/\"version\": \"$new_version\"/g" package.json
               rm -f package.json.bak
           else
               echo "  Would update: version field"
           fi
           
           files_updated=$((files_updated + 1))
       fi
       
       # Update README files
       local readme_files=$(find . -name "README*" -o -name "readme*" | head -5)
       
       for readme in $readme_files; do
           if [ -f "$readme" ] && grep -q "$current_version" "$readme"; then
               echo "📝 Updating $readme"
               
               if [ "$dry_run" = false ]; then
                   sed -i.bak "s/$current_version/$new_version/g" "$readme"
                   rm -f "$readme.bak"
               else
                   echo "  Would update: version references"
               fi
               
               files_updated=$((files_updated + 1))
           fi
       done
       
       # Update WordPress plugin constants
       local const_files=$(grep -r "define.*VERSION" . --include="*.php" -l 2>/dev/null | head -10)
       
       for const_file in $const_files; do
           if grep -q "$current_version" "$const_file" 2>/dev/null; then
               echo "📝 Updating constants in: $const_file"
               
               if [ "$dry_run" = false ]; then
                   sed -i.bak "s/define([^,]*VERSION[^,]*, '$current_version')/define('VERSION', '$new_version')/g" "$const_file"
                   sed -i.bak "s/define([^,]*VERSION[^,]*, \"$current_version\")/define('VERSION', \"$new_version\")/g" "$const_file"
                   rm -f "$const_file.bak"
               else
                   echo "  Would update: VERSION constants"
               fi
           fi
       done
       
       echo -e "\n✅ Version update complete!"
       echo "📊 Files updated: $files_updated"
       
       if [ "$dry_run" = false ]; then
           echo -e "\n📋 Summary of changes:"
           echo "  Old version: $current_version"
           echo "  New version: $new_version"
           echo -e "\n💡 Next steps:"
           echo "  1. Review the changes: git diff"
           echo "  2. Test the plugin functionality"
           echo "  3. Commit the version update: git add -A && git commit -m \"chore: bump version to $new_version\""
           echo "  4. Create a git tag: git tag v$new_version"
           echo "  5. Push changes: git push origin HEAD && git push origin v$new_version"
       fi
   }
   ```
   ```

4. **Automated Version Management Workflow**
   ```markdown
   ## Complete Version Management Workflow
   
   ### Full Automation Pipeline
   ```bash
   #!/bin/bash
   
   # Complete automated version management
   manage_wp_plugin_version() {
       local action=${1:-"analyze"}
       local target_version=$2
       local dry_run=${3:-false}
       
       echo "🚀 WordPress Plugin Version Manager"
       echo "=================================="
       
       # Validate we're in a WordPress plugin directory
       if ! find_main_plugin_file >/dev/null 2>&1; then
           echo "❌ Not in a WordPress plugin directory!"
           echo "Please run this command from the root of your WordPress plugin."
           return 1
       fi
       
       # Get current version
       local current_version=$(get_current_version)
       if [ -z "$current_version" ]; then
           echo "❌ Could not determine current version!"
           return 1
       fi
       
       case $action in
           "analyze")
               echo -e "\n📊 Change Analysis Report"
               echo "========================"
               
               # Show current version
               echo "Current version: $current_version"
               
               # Analyze changes
               local suggested_increment=$(analyze_changes)
               local increment_type=$(echo "$suggested_increment" | tail -1)
               
               if [ "$increment_type" != "NONE" ]; then
                   local suggested_version=$(calculate_next_version "$current_version" "$increment_type")
                   echo -e "\n💡 Suggested next version: $suggested_version"
                   echo "Run with --auto to apply automatically"
                   echo "Run with --update $suggested_version to apply manually"
               else
                   echo -e "\n💡 No version increment needed"
               fi
               
               # Show files that would be updated
               echo -e "\n📄 Files containing version references:"
               find_version_files | while read -r file; do
                   echo "  - $file"
               done
               ;;
               
           "auto")
               echo -e "\n🤖 Automatic Version Management"
               echo "==============================="
               
               # Analyze changes
               local suggested_increment=$(analyze_changes)
               local increment_type=$(echo "$suggested_increment" | tail -1)
               
               if [ "$increment_type" = "NONE" ]; then
                   echo "ℹ️  No changes require version increment"
                   return 0
               fi
               
               local new_version=$(calculate_next_version "$current_version" "$increment_type")
               
               echo "🎯 Automatically updating to version: $new_version"
               
               # Confirm with user unless in CI
               if [ -z "$CI" ] && [ "$dry_run" = false ]; then
                   read -p "Proceed with version update? (y/n): " -n 1 -r
                   echo
                   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                       echo "❌ Version update cancelled"
                       return 1
                   fi
               fi
               
               # Update version
               update_plugin_version "$current_version" "$new_version" "$dry_run"
               ;;
               
           "update")
               if [ -z "$target_version" ]; then
                   echo "❌ Target version required for update action"
                   echo "Usage: --update 1.2.3"
                   return 1
               fi
               
               # Validate target version format
               if [[ ! $target_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                   echo "❌ Invalid version format: $target_version"
                   echo "Expected format: MAJOR.MINOR.PATCH (e.g., 1.2.3)"
                   return 1
               fi
               
               echo -e "\n🎯 Manual Version Update"
               echo "======================="
               echo "Current version: $current_version"
               echo "Target version: $target_version"
               
               # Update version
               update_plugin_version "$current_version" "$target_version" "$dry_run"
               ;;
               
           "files")
               echo -e "\n📄 Version Reference Files"
               echo "=========================="
               
               find_version_files | while read -r file; do
                   echo "📄 $file"
                   grep -n "$current_version" "$file" 2>/dev/null | head -5 | sed 's/^/  /'
                   echo
               done
               ;;
               
           *)
               echo "❌ Unknown action: $action"
               echo "Valid actions: analyze, auto, update, files"
               return 1
               ;;
       esac
   }
   
   # Main entry point
   wp_version_manager() {
       local action="analyze"
       local target_version=""
       local dry_run=false
       
       # Parse arguments
       while [[ $# -gt 0 ]]; do
           case $1 in
               --analyze)
                   action="analyze"
                   shift
                   ;;
               --auto)
                   action="auto"
                   shift
                   ;;
               --update)
                   action="update"
                   target_version="$2"
                   shift 2
                   ;;
               --files)
                   action="files"
                   shift
                   ;;
               --dry-run)
                   dry_run=true
                   shift
                   ;;
               *)
                   echo "Unknown option: $1"
                   echo "Usage: wp-version-manager [--analyze|--auto|--update <version>|--files] [--dry-run]"
                   return 1
                   ;;
           esac
       done
       
       # Execute the requested action
       manage_wp_plugin_version "$action" "$target_version" "$dry_run"
   }
   ```
   ```

5. **Integration with WordPress Development Workflow**
   ```markdown
   ## WordPress Plugin Development Integration
   
   ### Pre-Release Validation
   ```bash
   #!/bin/bash
   
   # Validate plugin before version update
   validate_plugin_before_version_update() {
       echo "🔍 WordPress Plugin Validation"
       echo "============================="
       
       local validation_errors=0
       
       # Check for PHP syntax errors
       echo "1️⃣ Checking PHP syntax..."
       find . -name "*.php" -not -path "./vendor/*" -exec php -l {} \; 2>&1 | grep -v "No syntax errors detected" | head -10
       
       if [ $? -eq 0 ]; then
           echo "❌ PHP syntax errors found!"
           validation_errors=$((validation_errors + 1))
       else
           echo "✅ No PHP syntax errors"
       fi
       
       # Check WordPress coding standards (if PHPCS is available)
       if command -v phpcs >/dev/null 2>&1; then
           echo -e "\n2️⃣ Checking WordPress coding standards..."
           phpcs --standard=WordPress --extensions=php --ignore=vendor/ . 2>/dev/null | head -20
           
           if [ $? -ne 0 ]; then
               echo "⚠️  Coding standard issues found (not blocking)"
           else
               echo "✅ WordPress coding standards passed"
           fi
       else
           echo -e "\n2️⃣ ⚠️  PHPCS not available - skipping coding standards check"
       fi
       
       # Check for WordPress security issues
       echo -e "\n3️⃣ Basic security checks..."
       
       # Check for direct file access protection
       local unprotected_files=$(find . -name "*.php" -not -path "./vendor/*" -exec grep -L "defined.*ABSPATH" {} \; | head -10)
       if [ -n "$unprotected_files" ]; then
           echo "⚠️  Files without ABSPATH protection:"
           echo "$unprotected_files" | sed 's/^/  /'
       else
           echo "✅ All PHP files have ABSPATH protection"
       fi
       
       # Check for SQL injection vulnerabilities
       local sql_issues=$(grep -r "\\$_[GP]" . --include="*.php" | grep -v "sanitize\|prepare\|esc_" | wc -l)
       if [ $sql_issues -gt 0 ]; then
           echo "⚠️  Potential SQL injection issues: $sql_issues"
           echo "  Review direct usage of \$_GET, \$_POST without sanitization"
       else
           echo "✅ No obvious SQL injection vulnerabilities"
       fi
       
       # Check for XSS vulnerabilities
       local xss_issues=$(grep -r "echo.*\\$_[GP]" . --include="*.php" | grep -v "esc_\|sanitize" | wc -l)
       if [ $xss_issues -gt 0 ]; then
           echo "⚠️  Potential XSS issues: $xss_issues"
           echo "  Review direct echo of user input without escaping"
       else
           echo "✅ No obvious XSS vulnerabilities"
       fi
       
       # Check plugin header completeness
       echo -e "\n4️⃣ Plugin header validation..."
       local main_file=$(find_main_plugin_file)
       
       if [ -n "$main_file" ]; then
           local required_headers=("Plugin Name" "Version" "Author")
           local missing_headers=()
           
           for header in "${required_headers[@]}"; do
               if ! grep -q "$header:" "$main_file"; then
                   missing_headers+=("$header")
               fi
           done
           
           if [ ${#missing_headers[@]} -gt 0 ]; then
               echo "⚠️  Missing plugin headers:"
               printf '  - %s\n' "${missing_headers[@]}"
           else
               echo "✅ All required plugin headers present"
           fi
       fi
       
       # Summary
       echo -e "\n📊 Validation Summary"
       echo "===================="
       
       if [ $validation_errors -eq 0 ]; then
           echo "✅ Plugin validation passed - ready for version update"
           return 0
       else
           echo "❌ Plugin validation failed - fix issues before version update"
           return 1
       fi
   }
   ```
   ```

## Usage Examples

```bash
# Analyze changes and get version recommendation
wp-plugin-version-manager --analyze

# Automatically determine and apply version update
wp-plugin-version-manager --auto

# Update to specific version
wp-plugin-version-manager --update 2.1.0

# See what files contain version references
wp-plugin-version-manager --files

# Dry run to see what would be changed
wp-plugin-version-manager --auto --dry-run

# Manual workflow
wp-plugin-version-manager --analyze
wp-plugin-version-manager --update 1.3.0
git add -A
git commit -m "chore: bump version to 1.3.0"
git tag v1.3.0
git push origin HEAD --tags
```

**WordPress Plugin Version Management Standards:**
- Always use semantic versioning (MAJOR.MINOR.PATCH)
- MAJOR: Breaking changes or major new features
- MINOR: New features that are backward compatible
- PATCH: Bug fixes and minor improvements
- Version references should be updated in all relevant files
- Plugin header Version field is the source of truth
- Always validate plugin before version updates
- Create git tags for each version release
- Update documentation and changelogs with version changes