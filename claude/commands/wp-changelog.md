# WordPress Plugin Changelog Generator

Intelligently generate user-focused changelogs by analyzing git diffs between main and current branch, highlighting business-value changes while filtering out technical noise.

## Instructions

Generate business-value focused changelog from git differences: **$ARGUMENTS**

**Flags:**
- `--format <md|html|txt>`: Output format (default: markdown)
- `--target <branch>`: Target branch to compare against (default: main)
- `--user-friendly`: Generate end-user focused descriptions
- `--include-technical`: Include technical changes alongside business changes
- `--version <version>`: Specify version for changelog header
- `--output <file>`: Save changelog to file instead of stdout
- `--since <date>`: Include commits since specific date
- `--commit-range <range>`: Use specific commit range instead of branch diff
- `--update-readme`: Update the changelog section in readme.txt file

1. **Business-Value Change Detection**
   ```markdown
   ## Intelligent Change Classification
   
   ### High-Value Changes (Include in Changelog)
   ```bash
   #!/bin/bash
   
   # Analyze git diff for business-value changes
   analyze_business_changes() {
       local target_branch=${1:-"main"}
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       
       echo "📊 Analyzing business-value changes..."
       echo "Comparing $current_branch with $target_branch"
       
       # Get diff and commit information
       local diff_output=$(git diff $target_branch...HEAD)
       local commits=$(git log $target_branch..HEAD --oneline --no-merges)
       
       if [ -z "$diff_output" ]; then
           echo "ℹ️  No changes detected between branches"
           return 0
       fi
       
       # Initialize change categories
       local features=()
       local bug_fixes=()
       local security_updates=()
       local performance_improvements=()
       local user_experience=()
       local api_changes=()
       local breaking_changes=()
       
       echo -e "\n🔍 Scanning for business-value changes..."
       
       # Analyze commits for business value
       while IFS= read -r commit_line; do
           local commit_hash=$(echo "$commit_line" | awk '{print $1}')
           local commit_msg=$(echo "$commit_line" | cut -d' ' -f2-)
           
           # Skip if empty
           [ -z "$commit_msg" ] && continue
           
           # Categorize commits based on conventional commit patterns and keywords
           if [[ $commit_msg =~ ^feat(\(.+\))?: ]]; then
               local feature_desc=$(echo "$commit_msg" | sed 's/^feat[^:]*: //' | sed 's/^./\U&/')
               features+=("$feature_desc")
           elif [[ $commit_msg =~ ^fix(\(.+\))?: ]]; then
               local fix_desc=$(echo "$commit_msg" | sed 's/^fix[^:]*: //' | sed 's/^./\U&/')
               bug_fixes+=("$fix_desc")
           elif [[ $commit_msg =~ ^perf(\(.+\))?: ]]; then
               local perf_desc=$(echo "$commit_msg" | sed 's/^perf[^:]*: //' | sed 's/^./\U&/')
               performance_improvements+=("$perf_desc")
           elif echo "$commit_msg" | grep -iq "security\\|vulnerability\\|CVE\\|exploit\\|patch"; then
               local security_desc=$(echo "$commit_msg" | sed 's/^[^:]*: //' | sed 's/^./\U&/')
               security_updates+=("$security_desc")
           elif echo "$commit_msg" | grep -iq "BREAKING CHANGE\\|breaking\\|!:"; then
               local breaking_desc=$(echo "$commit_msg" | sed 's/^[^:]*: //' | sed 's/^./\U&/')
               breaking_changes+=("$breaking_desc")
           elif echo "$commit_msg" | grep -iq "ui\\|ux\\|user.*experience\\|interface\\|usability"; then
               local ux_desc=$(echo "$commit_msg" | sed 's/^[^:]*: //' | sed 's/^./\U&/')
               user_experience+=("$ux_desc")
           elif echo "$commit_msg" | grep -iq "api\\|endpoint\\|rest\\|graphql"; then
               local api_desc=$(echo "$commit_msg" | sed 's/^[^:]*: //' | sed 's/^./\U&/')
               api_changes+=("$api_desc")
           fi
       done <<< "$commits"
       
       # Analyze file changes for additional business value
       analyze_file_changes "$diff_output" features bug_fixes security_updates performance_improvements user_experience api_changes
       
       # Store results in global arrays for changelog generation
       declare -g -a CHANGELOG_FEATURES=("${features[@]}")
       declare -g -a CHANGELOG_FIXES=("${bug_fixes[@]}")
       declare -g -a CHANGELOG_SECURITY=("${security_updates[@]}")
       declare -g -a CHANGELOG_PERFORMANCE=("${performance_improvements[@]}")
       declare -g -a CHANGELOG_UX=("${user_experience[@]}")
       declare -g -a CHANGELOG_API=("${api_changes[@]}")
       declare -g -a CHANGELOG_BREAKING=("${breaking_changes[@]}")
   }
   
   # Analyze file changes for business value indicators
   analyze_file_changes() {
       local diff_output="$1"
       local -n features_ref=$2
       local -n fixes_ref=$3
       local -n security_ref=$4
       local -n performance_ref=$5
       local -n ux_ref=$6
       local -n api_ref=$7
       
       # Check for new WordPress hooks/filters (indicates new features)
       local new_hooks=$(echo "$diff_output" | grep -E "^\\+.*add_(action|filter)" | wc -l)
       if [ $new_hooks -gt 0 ]; then
           features_ref+=("Added $new_hooks new WordPress hooks for enhanced customization")
       fi
       
       # Check for new REST API endpoints
       local new_endpoints=$(echo "$diff_output" | grep -E "^\\+.*register_rest_route" | wc -l)
       if [ $new_endpoints -gt 0 ]; then
           api_ref+=("Added $new_endpoints new REST API endpoints")
       fi
       
       # Check for new shortcodes
       local new_shortcodes=$(echo "$diff_output" | grep -E "^\\+.*add_shortcode" | wc -l)
       if [ $new_shortcodes -gt 0 ]; then
           features_ref+=("Added $new_shortcodes new shortcodes for content integration")
       fi
       
       # Check for database schema changes
       if echo "$diff_output" | grep -q "CREATE TABLE\\|ALTER TABLE\\|ADD COLUMN"; then
           features_ref+=("Enhanced database structure for improved functionality")
       fi
       
       # Check for security improvements
       if echo "$diff_output" | grep -q "wp_nonce\\|sanitize_\\|esc_\\|current_user_can"; then
           security_ref+=("Enhanced security measures and data validation")
       fi
       
       # Check for performance optimizations
       if echo "$diff_output" | grep -q "wp_cache\\|transient\\|wp_query.*meta_query\\|optimize"; then
           performance_ref+=("Improved performance through caching and query optimization")
       fi
       
       # Check for UI/UX improvements
       if echo "$diff_output" | grep -q "\\.css\\|\\.js\\|admin_enqueue\\|wp_enqueue"; then
           local css_changes=$(echo "$diff_output" | grep -c "\\.css")
           local js_changes=$(echo "$diff_output" | grep -c "\\.js")
           
           if [ $css_changes -gt 0 ] || [ $js_changes -gt 0 ]; then
               ux_ref+=("Improved user interface and experience")
           fi
       fi
   }
   ```
   ```

2. **User-Friendly Description Generation**
   ```markdown
   ## Business-Focused Change Descriptions
   
   ### Convert Technical Changes to User Benefits
   ```bash
   #!/bin/bash
   
   # Convert technical descriptions to user-friendly language
   humanize_change_descriptions() {
       local user_friendly=${1:-false}
       
       if [ "$user_friendly" = true ]; then
           echo "🔄 Converting technical descriptions to user-friendly language..."
           
           # Process features
           for i in "${!CHANGELOG_FEATURES[@]}"; do
               CHANGELOG_FEATURES[$i]=$(humanize_technical_description "${CHANGELOG_FEATURES[$i]}" "feature")
           done
           
           # Process bug fixes
           for i in "${!CHANGELOG_FIXES[@]}"; do
               CHANGELOG_FIXES[$i]=$(humanize_technical_description "${CHANGELOG_FIXES[$i]}" "fix")
           done
           
           # Process other categories
           for i in "${!CHANGELOG_PERFORMANCE[@]}"; do
               CHANGELOG_PERFORMANCE[$i]=$(humanize_technical_description "${CHANGELOG_PERFORMANCE[$i]}" "performance")
           done
       fi
   }
   
   # Convert technical description to user-friendly language
   humanize_technical_description() {
       local description="$1"
       local change_type="$2"
       
       # Common technical to user-friendly mappings
       description=$(echo "$description" | sed -E '
           s/add(ed)? authentication/Added secure login system/gi
           s/implement(ed)? OAuth/Added social media login options/gi
           s/add(ed)? REST API/Added integration capabilities for developers/gi
           s/optimize(d)? database queries/Improved website speed and performance/gi
           s/add(ed)? caching/Made the website load faster/gi
           s/fix(ed)? memory leak/Resolved performance issues/gi
           s/implement(ed)? security/Enhanced website security/gi
           s/add(ed)? validation/Improved data safety and reliability/gi
           s/refactor(ed)?/Improved internal code quality/gi
           s/update(d)? dependencies/Updated underlying technology for better security/gi
           s/add(ed)? logging/Added system monitoring capabilities/gi
           s/implement(ed)? rate limiting/Added protection against abuse/gi
           s/add(ed)? backup/Added data protection features/gi
           s/optimize(d)? images/Improved image loading speed/gi
           s/implement(ed)? CDN/Made content load faster globally/gi
           s/add(ed)? responsive/Made mobile-friendly interface/gi
           s/fix(ed)? XSS/Fixed security vulnerability/gi
           s/fix(ed)? SQL injection/Fixed security vulnerability/gi
           s/add(ed)? CSRF protection/Enhanced form security/gi
       ')
       
       # Enhance based on change type
       case $change_type in
           "feature")
               if ! echo "$description" | grep -iq "added\\|new\\|introduced"; then
                   description="Added: $description"
               fi
               ;;
           "fix")
               if ! echo "$description" | grep -iq "fixed\\|resolved\\|corrected"; then
                   description="Fixed: $description"
               fi
               ;;
           "performance")
               if ! echo "$description" | grep -iq "improved\\|faster\\|optimized"; then
                   description="Performance: $description"
               fi
               ;;
       esac
       
       echo "$description"
   }
   
   # Generate impact statements for changes
   generate_impact_statements() {
       echo "💡 Generating user impact statements..."
       
       # Calculate overall impact
       local total_features=${#CHANGELOG_FEATURES[@]}
       local total_fixes=${#CHANGELOG_FIXES[@]}
       local total_security=${#CHANGELOG_SECURITY[@]}
       local total_performance=${#CHANGELOG_PERFORMANCE[@]}
       
       local impact_summary=""
       
       if [ $total_features -gt 0 ]; then
           if [ $total_features -eq 1 ]; then
               impact_summary+="✨ 1 new feature"
           else
               impact_summary+="✨ $total_features new features"
           fi
       fi
       
       if [ $total_fixes -gt 0 ]; then
           [ -n "$impact_summary" ] && impact_summary+=", "
           if [ $total_fixes -eq 1 ]; then
               impact_summary+="🐛 1 bug fix"
           else
               impact_summary+="🐛 $total_fixes bug fixes"
           fi
       fi
       
       if [ $total_security -gt 0 ]; then
           [ -n "$impact_summary" ] && impact_summary+=", "
           if [ $total_security -eq 1 ]; then
               impact_summary+="🔒 1 security update"
           else
               impact_summary+="🔒 $total_security security updates"
           fi
       fi
       
       if [ $total_performance -gt 0 ]; then
           [ -n "$impact_summary" ] && impact_summary+=", "
           if [ $total_performance -eq 1 ]; then
               impact_summary+="⚡ 1 performance improvement"
           else
               impact_summary+="⚡ $total_performance performance improvements"
           fi
       fi
       
       echo "$impact_summary"
   }
   ```
   ```

3. **Changelog Format Generation**
   ```markdown
   ## Multi-Format Changelog Generation
   
   ### Markdown Format (Default)
   ```bash
   #!/bin/bash
   
   # Generate markdown changelog
   generate_markdown_changelog() {
       local version="$1"
       local target_branch="$2"
       local include_technical="$3"
       
       local changelog=""
       
       # Header
       if [ -n "$version" ]; then
           changelog+="# Changelog - Version $version\n\n"
       else
           changelog+="# Changelog\n\n"
       fi
       
       changelog+="*Release Date: $(date '+%Y-%m-%d')*\n\n"
       
       # Impact summary
       local impact=$(generate_impact_statements)
       if [ -n "$impact" ]; then
           changelog+="## Summary\n\n"
           changelog+="$impact\n\n"
       fi
       
       # Breaking changes (always show first if any)
       if [ ${#CHANGELOG_BREAKING[@]} -gt 0 ]; then
           changelog+="## ⚠️ Breaking Changes\n\n"
           for change in "${CHANGELOG_BREAKING[@]}"; do
               changelog+="- $change\n"
           done
           changelog+="\n"
       fi
       
       # New features
       if [ ${#CHANGELOG_FEATURES[@]} -gt 0 ]; then
           changelog+="## ✨ New Features\n\n"
           for feature in "${CHANGELOG_FEATURES[@]}"; do
               changelog+="- $feature\n"
           done
           changelog+="\n"
       fi
       
       # Bug fixes
       if [ ${#CHANGELOG_FIXES[@]} -gt 0 ]; then
           changelog+="## 🐛 Bug Fixes\n\n"
           for fix in "${CHANGELOG_FIXES[@]}"; do
               changelog+="- $fix\n"
           done
           changelog+="\n"
       fi
       
       # Security updates
       if [ ${#CHANGELOG_SECURITY[@]} -gt 0 ]; then
           changelog+="## 🔒 Security Updates\n\n"
           for security in "${CHANGELOG_SECURITY[@]}"; do
               changelog+="- $security\n"
           done
           changelog+="\n"
       fi
       
       # Performance improvements
       if [ ${#CHANGELOG_PERFORMANCE[@]} -gt 0 ]; then
           changelog+="## ⚡ Performance Improvements\n\n"
           for perf in "${CHANGELOG_PERFORMANCE[@]}"; do
               changelog+="- $perf\n"
           done
           changelog+="\n"
       fi
       
       # User experience improvements
       if [ ${#CHANGELOG_UX[@]} -gt 0 ]; then
           changelog+="## 🎨 User Experience\n\n"
           for ux in "${CHANGELOG_UX[@]}"; do
               changelog+="- $ux\n"
           done
           changelog+="\n"
       fi
       
       # API changes
       if [ ${#CHANGELOG_API[@]} -gt 0 ]; then
           changelog+="## 🔌 API Changes\n\n"
           for api in "${CHANGELOG_API[@]}"; do
               changelog+="- $api\n"
           done
           changelog+="\n"
       fi
       
       # Technical details (if requested)
       if [ "$include_technical" = true ]; then
           add_technical_details_markdown changelog "$target_branch"
       fi
       
       echo -e "$changelog"
   }
   
   # Generate HTML changelog
   generate_html_changelog() {
       local version="$1"
       local target_branch="$2"
       local include_technical="$3"
       
       local changelog=""
       
       # HTML header
       changelog+="<!DOCTYPE html>\n"
       changelog+="<html>\n<head>\n"
       changelog+="<title>Changelog"
       [ -n "$version" ] && changelog+=" - Version $version"
       changelog+="</title>\n"
       changelog+="<style>\n"
       changelog+="body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }\n"
       changelog+="h1 { color: #333; border-bottom: 2px solid #007cba; }\n"
       changelog+="h2 { color: #444; margin-top: 30px; }\n"
       changelog+="ul { padding-left: 20px; }\n"
       changelog+="li { margin-bottom: 8px; }\n"
       changelog+=".summary { background: #f0f8ff; padding: 15px; border-radius: 5px; margin: 20px 0; }\n"
       changelog+=".breaking { background: #fff2f2; border-left: 4px solid #dc3545; padding: 15px; }\n"
       changelog+="</style>\n"
       changelog+="</head>\n<body>\n"
       
       # Content
       if [ -n "$version" ]; then
           changelog+="<h1>Changelog - Version $version</h1>\n"
       else
           changelog+="<h1>Changelog</h1>\n"
       fi
       
       changelog+="<p><em>Release Date: $(date '+%Y-%m-%d')</em></p>\n"
       
       # Impact summary
       local impact=$(generate_impact_statements)
       if [ -n "$impact" ]; then
           changelog+="<div class=\"summary\">\n"
           changelog+="<h2>Summary</h2>\n"
           changelog+="<p>$impact</p>\n"
           changelog+="</div>\n"
       fi
       
       # Breaking changes
       if [ ${#CHANGELOG_BREAKING[@]} -gt 0 ]; then
           changelog+="<div class=\"breaking\">\n"
           changelog+="<h2>⚠️ Breaking Changes</h2>\n<ul>\n"
           for change in "${CHANGELOG_BREAKING[@]}"; do
               changelog+="<li>$change</li>\n"
           done
           changelog+="</ul>\n</div>\n"
       fi
       
       # Other sections (similar pattern)
       generate_html_sections changelog
       
       # HTML footer
       changelog+="</body>\n</html>\n"
       
       echo -e "$changelog"
   }
   
   # Generate WordPress readme.txt changelog format
   generate_wordpress_readme_changelog() {
       local version="$1"
       local target_branch="$2"
       
       local changelog=""
       
       # Version header (WordPress format)
       if [ -n "$version" ]; then
           changelog+="= $version =\n"
       else
           changelog+="= $(date '+%Y-%m-%d') =\n"
       fi
       
       # Breaking changes first
       if [ ${#CHANGELOG_BREAKING[@]} -gt 0 ]; then
           for change in "${CHANGELOG_BREAKING[@]}"; do
               changelog+="* Breaking: $change\n"
           done
       fi
       
       # Features
       if [ ${#CHANGELOG_FEATURES[@]} -gt 0 ]; then
           for feature in "${CHANGELOG_FEATURES[@]}"; do
               changelog+="* Feature: $feature\n"
           done
       fi
       
       # Bug fixes
       if [ ${#CHANGELOG_FIXES[@]} -gt 0 ]; then
           for fix in "${CHANGELOG_FIXES[@]}"; do
               changelog+="* Fix: $fix\n"
           done
       fi
       
       # Security updates
       if [ ${#CHANGELOG_SECURITY[@]} -gt 0 ]; then
           for security in "${CHANGELOG_SECURITY[@]}"; do
               changelog+="* Security: $security\n"
           done
       fi
       
       # Performance improvements
       if [ ${#CHANGELOG_PERFORMANCE[@]} -gt 0 ]; then
           for perf in "${CHANGELOG_PERFORMANCE[@]}"; do
               changelog+="* Performance: $perf\n"
           done
       fi
       
       # User experience improvements
       if [ ${#CHANGELOG_UX[@]} -gt 0 ]; then
           for ux in "${CHANGELOG_UX[@]}"; do
               changelog+="* Enhancement: $ux\n"
           done
       fi
       
       # API changes
       if [ ${#CHANGELOG_API[@]} -gt 0 ]; then
           for api in "${CHANGELOG_API[@]}"; do
               changelog+="* API: $api\n"
           done
       fi
       
       echo -e "$changelog"
   }
   
   # Update readme.txt with new changelog entry
   update_readme_changelog() {
       local new_changelog="$1"
       local readme_file="readme.txt"
       
       # Check if readme.txt exists
       if [ ! -f "$readme_file" ]; then
           echo "❌ Error: readme.txt not found in current directory!"
           return 1
       fi
       
       echo "📝 Updating changelog in readme.txt..."
       
       # Create temporary file
       local temp_file=$(mktemp)
       
       # Read the original readme
       local in_changelog_section=false
       local changelog_found=false
       local first_version_found=false
       
       while IFS= read -r line; do
           # Check if we're entering the changelog section
           if [[ "$line" =~ ^[[:space:]]*==[[:space:]]*Changelog[[:space:]]*==[[:space:]]*$ ]]; then
               in_changelog_section=true
               changelog_found=true
               echo "$line" >> "$temp_file"
               echo "" >> "$temp_file"  # Add blank line after == Changelog ==
               echo -n "$new_changelog" >> "$temp_file"  # Add new changelog entry
               continue
           fi
           
           # If we're in the changelog section and find a version entry
           if [ "$in_changelog_section" = true ] && [[ "$line" =~ ^[[:space:]]*=[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+.*=[[:space:]]*$ ]]; then
               if [ "$first_version_found" = false ]; then
                   first_version_found=true
                   echo "" >> "$temp_file"  # Add blank line before existing entries
               fi
           fi
           
           # If we hit another main section (==), we're out of changelog
           if [ "$in_changelog_section" = true ] && [ "$line" != "" ] && [[ "$line" =~ ^[[:space:]]*==[[:space:]]*[^=]+[[:space:]]*==[[:space:]]*$ ]] && ! [[ "$line" =~ Changelog ]]; then
               in_changelog_section=false
           fi
           
           echo "$line" >> "$temp_file"
       done < "$readme_file"
       
       if [ "$changelog_found" = false ]; then
           echo "❌ Error: No '== Changelog ==' section found in readme.txt!"
           rm "$temp_file"
           return 1
       fi
       
       # Replace original file with updated content
       mv "$temp_file" "$readme_file"
       
       echo "✅ Successfully updated changelog in readme.txt"
       echo ""
       echo "📋 New changelog entry added:"
       echo "-----------------------------"
       echo -n "$new_changelog"
       echo "-----------------------------"
       
       return 0
   }
   
   # Generate plain text changelog
   generate_text_changelog() {
       local version="$1"
       local target_branch="$2"
       local include_technical="$3"
       
       local changelog=""
       
       # Header
       if [ -n "$version" ]; then
           changelog+="CHANGELOG - VERSION $version\n"
           changelog+="$(printf '=%.0s' {1..50})\n\n"
       else
           changelog+="CHANGELOG\n"
           changelog+="$(printf '=%.0s' {1..20})\n\n"
       fi
       
       changelog+="Release Date: $(date '+%Y-%m-%d')\n\n"
       
       # Impact summary
       local impact=$(generate_impact_statements)
       if [ -n "$impact" ]; then
           changelog+="SUMMARY\n"
           changelog+="$(printf '-%.0s' {1..20})\n"
           changelog+="$impact\n\n"
       fi
       
       # Generate sections in plain text format
       generate_text_sections changelog
       
       echo -e "$changelog"
   }
   ```
   ```

4. **Low-Value Change Filtering**
   ```markdown
   ## Smart Change Filtering
   
   ### Filter Out Technical Noise
   ```bash
   #!/bin/bash
   
   # Filter out low-value changes that don't impact users
   filter_low_value_changes() {
       local commits="$1"
       
       echo "🔍 Filtering out low-value technical changes..."
       
       # Patterns for low-value changes to exclude
       local exclude_patterns=(
           "^(style|format|lint):"
           "^docs?:"
           "^chore:"
           "^refactor:"
           "^test:"
           "^build:"
           "^ci:"
           "formatting"
           "whitespace"
           "code style"
           "linting"
           "prettier"
           "eslint"
           "phpcs"
           "update.*comment"
           "typo"
           "spelling"
           "rename variable"
           "cleanup"
           "remove unused"
           "update dependency.*patch"
           "bump.*version"
           "merge branch"
           "update.*lock"
           "format.*code"
       )
       
       local filtered_commits=""
       
       while IFS= read -r commit_line; do
           local commit_msg=$(echo "$commit_line" | cut -d' ' -f2-)
           local is_low_value=false
           
           # Check against exclude patterns
           for pattern in "${exclude_patterns[@]}"; do
               if echo "$commit_msg" | grep -iq "$pattern"; then
                   is_low_value=true
                   break
               fi
           done
           
           # Only include if not low-value
           if [ "$is_low_value" = false ]; then
               filtered_commits+="$commit_line\n"
           fi
       done <<< "$commits"
       
       echo -e "$filtered_commits"
   }
   
   # Detect and categorize dependency updates
   analyze_dependency_updates() {
       local diff_output="$1"
       
       # Check for package.json changes
       local package_changes=$(echo "$diff_output" | grep -A5 -B5 "package\\.json")
       
       if [ -n "$package_changes" ]; then
           # Look for security updates
           if echo "$package_changes" | grep -iq "security\\|vulnerability\\|CVE"; then
               CHANGELOG_SECURITY+=("Updated dependencies to address security vulnerabilities")
           else
               # Check for major version updates
               local major_updates=$(echo "$package_changes" | grep -E "\"[^\"]+\":[[:space:]]*\"\\^?[0-9]+\\." | wc -l)
               if [ $major_updates -gt 0 ]; then
                   CHANGELOG_FEATURES+=("Updated core dependencies for improved functionality")
               fi
           fi
       fi
       
       # Similar checks for composer.json, requirements.txt, etc.
       local composer_changes=$(echo "$diff_output" | grep -A5 -B5 "composer\\.json")
       if [ -n "$composer_changes" ]; then
           if echo "$composer_changes" | grep -iq "security\\|vulnerability"; then
               CHANGELOG_SECURITY+=("Updated PHP dependencies for enhanced security")
           fi
       fi
   }
   
   # Smart commit message analysis
   extract_business_value_from_commit() {
       local commit_msg="$1"
       
       # Remove conventional commit prefix for analysis
       local clean_msg=$(echo "$commit_msg" | sed 's/^[a-z]*(\?[^)]*\)?: //')
       
       # Look for business value keywords
       local business_keywords=(
           "user"
           "customer"
           "admin"
           "dashboard"
           "interface"
           "experience"
           "workflow"
           "integration"
           "payment"
           "security"
           "performance"
           "speed"
           "loading"
           "response"
           "error"
           "bug"
           "issue"
           "problem"
           "fix"
           "resolve"
           "feature"
           "functionality"
           "capability"
           "support"
           "compatibility"
           "accessibility"
       )
       
       local has_business_value=false
       for keyword in "${business_keywords[@]}"; do
           if echo "$clean_msg" | grep -iq "$keyword"; then
               has_business_value=true
               break
           fi
       done
       
       echo "$has_business_value"
   }
   ```
   ```

5. **Complete WordPress Changelog Workflow**
   ```markdown
   ## Complete Changelog Generation System
   
   ### Main Changelog Function
   ```bash
   #!/bin/bash
   
   # Main WordPress changelog generation function
   wp_changelog_generator() {
       local format="md"
       local target_branch="main"
       local user_friendly=false
       local include_technical=false
       local version=""
       local output_file=""
       local since_date=""
       local commit_range=""
       local update_readme=false
       
       # Parse arguments
       while [[ $# -gt 0 ]]; do
           case $1 in
               --format)
                   format="$2"
                   shift 2
                   ;;
               --target)
                   target_branch="$2"
                   shift 2
                   ;;
               --user-friendly)
                   user_friendly=true
                   shift
                   ;;
               --include-technical)
                   include_technical=true
                   shift
                   ;;
               --version)
                   version="$2"
                   shift 2
                   ;;
               --output)
                   output_file="$2"
                   shift 2
                   ;;
               --since)
                   since_date="$2"
                   shift 2
                   ;;
               --commit-range)
                   commit_range="$2"
                   shift 2
                   ;;
               --update-readme)
                   update_readme=true
                   shift
                   ;;
               *)
                   echo "Unknown option: $1"
                   echo "Usage: wp-changelog [--format md|html|txt] [--target branch] [--user-friendly] [--include-technical] [--version X.Y.Z] [--output file] [--since date] [--commit-range range] [--update-readme]"
                   return 1
                   ;;
           esac
       done
       
       echo "📝 WordPress Plugin Changelog Generator"
       echo "======================================"
       
       # Validate git repository
       if ! git rev-parse --git-dir >/dev/null 2>&1; then
           echo "❌ Not in a git repository!"
           return 1
       fi
       
       # Validate target branch exists
       if ! git rev-parse --verify "origin/$target_branch" >/dev/null 2>&1; then
           echo "❌ Target branch 'origin/$target_branch' does not exist!"
           return 1
       fi
       
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       echo "Current branch: $current_branch"
       echo "Target branch: $target_branch"
       echo "Output format: $format"
       
       # Get version from plugin file if not specified
       if [ -z "$version" ]; then
           version=$(get_plugin_version_for_changelog)
       fi
       
       # Analyze changes
       echo -e "\n🔍 Analyzing changes..."
       analyze_business_changes "$target_branch"
       
       # Apply user-friendly descriptions if requested
       if [ "$user_friendly" = true ]; then
           humanize_change_descriptions true
       fi
       
       # Generate changelog in requested format
       local changelog_content=""
       case $format in
           "md"|"markdown")
               changelog_content=$(generate_markdown_changelog "$version" "$target_branch" "$include_technical")
               ;;
           "html")
               changelog_content=$(generate_html_changelog "$version" "$target_branch" "$include_technical")
               ;;
           "txt"|"text")
               changelog_content=$(generate_text_changelog "$version" "$target_branch" "$include_technical")
               ;;
           *)
               echo "❌ Unsupported format: $format"
               echo "Supported formats: md, html, txt"
               return 1
               ;;
       esac
       
       # Handle output options
       if [ "$update_readme" = true ]; then
           # Generate WordPress readme format changelog
           local readme_changelog=$(generate_wordpress_readme_changelog "$version" "$target_branch")
           update_readme_changelog "$readme_changelog"
       elif [ -n "$output_file" ]; then
           echo -e "$changelog_content" > "$output_file"
           echo "✅ Changelog saved to: $output_file"
           
           # Show preview
           echo -e "\n📋 Preview (first 20 lines):"
           head -20 "$output_file"
       else
           echo -e "\n📋 Generated Changelog:"
           echo "======================"
           echo -e "$changelog_content"
       fi
       
       # Show statistics
       show_changelog_statistics
   }
   
   # Get plugin version for changelog
   get_plugin_version_for_changelog() {
       # Try to find WordPress plugin file
       local main_file=""
       
       if [ -f "jwt-auth-pro.php" ]; then
           main_file="jwt-auth-pro.php"
       else
           main_file=$(find . -maxdepth 1 -name "*.php" -exec grep -l "Plugin Name:" {} \; 2>/dev/null | head -1)
       fi
       
       if [ -n "$main_file" ]; then
           local version=$(grep -i "Version:" "$main_file" | head -1 | sed 's/.*Version:[[:space:]]*//' | sed 's/[[:space:]]*$//' | tr -d '\r')
           echo "$version"
       fi
   }
   
   # Show changelog generation statistics
   show_changelog_statistics() {
       echo -e "\n📊 Changelog Statistics"
       echo "======================"
       echo "✨ Features: ${#CHANGELOG_FEATURES[@]}"
       echo "🐛 Bug Fixes: ${#CHANGELOG_FIXES[@]}"
       echo "🔒 Security Updates: ${#CHANGELOG_SECURITY[@]}"
       echo "⚡ Performance Improvements: ${#CHANGELOG_PERFORMANCE[@]}"
       echo "🎨 UX Improvements: ${#CHANGELOG_UX[@]}"
       echo "🔌 API Changes: ${#CHANGELOG_API[@]}"
       echo "⚠️ Breaking Changes: ${#CHANGELOG_BREAKING[@]}"
       
       local total=$((${#CHANGELOG_FEATURES[@]} + ${#CHANGELOG_FIXES[@]} + ${#CHANGELOG_SECURITY[@]} + ${#CHANGELOG_PERFORMANCE[@]} + ${#CHANGELOG_UX[@]} + ${#CHANGELOG_API[@]} + ${#CHANGELOG_BREAKING[@]}))
       echo "📝 Total Business-Value Changes: $total"
   }
   ```
   ```

## Usage Examples

```bash
# Generate basic markdown changelog
wp-changelog

# Generate user-friendly HTML changelog with version
wp-changelog --format html --user-friendly --version 2.1.0

# Generate changelog and save to file
wp-changelog --output CHANGELOG.md --version 2.1.0

# Compare against different branch
wp-changelog --target develop

# Include technical details alongside business changes
wp-changelog --include-technical --user-friendly

# Generate changelog for specific commit range
wp-changelog --commit-range v1.0.0..HEAD

# Generate changelog since specific date
wp-changelog --since "2024-01-01"

# Update readme.txt with new changelog entry
wp-changelog --update-readme --version 2.1.0 --user-friendly

# Complete workflow examples:

# 1. After completing feature work:
wp-changelog --user-friendly --version 2.1.0 --output release-notes.md

# 2. For end-user documentation:
wp-changelog --format html --user-friendly --output changelog.html

# 3. For developer release notes:
wp-changelog --include-technical --format md

# 4. Update WordPress readme.txt changelog:
wp-changelog --update-readme --version 2.1.0
```

**WordPress Plugin Changelog Standards:**
- Focus on user-visible changes and business value
- Filter out technical noise (formatting, refactoring, etc.)
- Categorize changes clearly (features, fixes, security, performance)
- Use user-friendly language when possible
- Include impact statements and summaries
- Support multiple output formats for different audiences
- Integrate with existing version management workflow
- Prioritize security and breaking changes visibility