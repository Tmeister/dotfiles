# WordPress Plugin Git Tag Manager

Create and manage WordPress plugin git tags based on the version in the main plugin file, designed to work seamlessly with wp-version.md and prepare-pr-main.md workflow.

## Instructions

Create git tags for WordPress plugin releases from main branch: **$ARGUMENTS**

**Flags:**
- `--create`: Create a new tag based on current plugin version
- `--verify`: Verify tag matches plugin version without creating
- `--push`: Push tag to remote repository after creation
- `--force`: Force create tag even if it already exists
- `--list`: List all existing plugin version tags
- `--delete <tag>`: Delete specified tag locally and remotely
- `--annotated`: Create annotated tag with release notes

1. **Plugin Version Detection and Validation**
   ```markdown
   ## WordPress Plugin Version Tag System
   
   ### Version Extraction from Main Plugin File
   ```bash
   #!/bin/bash
   
   # Find the main plugin file (jwt-auth-pro.php or similar)
   find_main_plugin_file() {
       echo "🔍 Detecting main WordPress plugin file..."
       
       # First, look for jwt-auth-pro.php specifically
       if [ -f "jwt-auth-pro.php" ]; then
           echo "📄 Found jwt-auth-pro.php"
           echo "jwt-auth-pro.php"
           return 0
       fi
       
       # Look for plugin files with plugin headers
       main_files=$(find . -maxdepth 1 -name "*.php" -exec grep -l "Plugin Name:" {} \; 2>/dev/null)
       
       if [ -z "$main_files" ]; then
           echo "❌ No WordPress plugin files found in root directory!"
           return 1
       fi
       
       # Use first found file
       main_file=$(echo "$main_files" | head -1)
       echo "📄 Main plugin file: $main_file"
       echo "$main_file"
   }
   
   # Extract current version from plugin file
   get_plugin_version() {
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
       
       # Validate semantic version format
       if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
           echo "⚠️  Version format is not semantic: $version"
           echo "Expected format: MAJOR.MINOR.PATCH (e.g., 1.2.3)"
       fi
       
       echo "$version"
   }
   
   # Validate we're on main branch
   validate_main_branch() {
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@' 2>/dev/null || echo "main")
       
       if [ "$current_branch" != "$default_branch" ] && [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
           echo "❌ Not on main branch!"
           echo "Current branch: $current_branch"
           echo "Expected: $default_branch"
           echo "Please checkout main branch before creating tags"
           return 1
       fi
       
       echo "✅ On main branch: $current_branch"
       return 0
   }
   
   # Ensure branch is up-to-date
   ensure_branch_updated() {
       echo "🔄 Ensuring main branch is up-to-date..."
       
       # Fetch latest changes
       git fetch origin
       
       local current_branch=$(git rev-parse --abbrev-ref HEAD)
       local local_commit=$(git rev-parse HEAD)
       local remote_commit=$(git rev-parse origin/$current_branch 2>/dev/null || git rev-parse origin/main)
       
       if [ "$local_commit" != "$remote_commit" ]; then
           echo "⚠️  Local branch is not up-to-date with remote"
           echo "Local:  $local_commit"
           echo "Remote: $remote_commit"
           
           read -p "Pull latest changes from remote? (y/n): " -n 1 -r
           echo
           if [[ $REPLY =~ ^[Yy]$ ]]; then
               git pull origin $current_branch
               echo "✅ Branch updated"
           else
               echo "❌ Cancelled - branch not updated"
               return 1
           fi
       else
           echo "✅ Branch is up-to-date"
       fi
       
       return 0
   }
   ```
   ```

2. **Git Tag Management**
   ```markdown
   ## Tag Creation and Management
   
   ### Tag Creation with Validation
   ```bash
   #!/bin/bash
   
   # Check if tag already exists
   tag_exists() {
       local tag_name=$1
       
       # Check local tags
       if git tag -l | grep -q "^$tag_name$"; then
           echo "📋 Tag exists locally: $tag_name"
           return 0
       fi
       
       # Check remote tags
       if git ls-remote --tags origin | grep -q "refs/tags/$tag_name$"; then
           echo "📋 Tag exists on remote: $tag_name"
           return 0
       fi
       
       return 1
   }
   
   # Create tag based on plugin version
   create_plugin_tag() {
       local plugin_version=$1
       local force_create=${2:-false}
       local annotated=${3:-true}
       local push_tag=${4:-false}
       
       if [ -z "$plugin_version" ]; then
           echo "❌ Plugin version is required"
           return 1
       fi
       
       local tag_name="v$plugin_version"
       
       echo "🏷️  Creating tag: $tag_name"
       
       # Check if tag already exists
       if tag_exists "$tag_name" && [ "$force_create" != true ]; then
           echo "❌ Tag $tag_name already exists!"
           echo "Use --force to overwrite existing tag"
           return 1
       fi
       
       # Delete existing tag if force is enabled
       if [ "$force_create" = true ] && tag_exists "$tag_name"; then
           echo "🗑️  Deleting existing tag: $tag_name"
           git tag -d "$tag_name" 2>/dev/null || true
           git push origin ":refs/tags/$tag_name" 2>/dev/null || true
       fi
       
       # Create the tag
       if [ "$annotated" = true ]; then
           # Generate release notes for annotated tag
           local release_notes=$(generate_release_notes "$plugin_version")
           
           echo "📝 Creating annotated tag with release notes..."
           git tag -a "$tag_name" -m "$release_notes"
       else
           echo "📝 Creating lightweight tag..."
           git tag "$tag_name"
       fi
       
       if [ $? -eq 0 ]; then
           echo "✅ Tag created successfully: $tag_name"
           
           # Push tag if requested
           if [ "$push_tag" = true ]; then
               push_tag_to_remote "$tag_name"
           fi
           
           return 0
       else
           echo "❌ Failed to create tag"
           return 1
       fi
   }
   
   # Push tag to remote
   push_tag_to_remote() {
       local tag_name=$1
       
       echo "📤 Pushing tag to remote: $tag_name"
       
       git push origin "$tag_name"
       
       if [ $? -eq 0 ]; then
           echo "✅ Tag pushed successfully"
           echo "🔗 Tag URL: $(git remote get-url origin | sed 's/\.git$//')/releases/tag/$tag_name"
       else
           echo "❌ Failed to push tag"
           return 1
       fi
   }
   
   # Generate release notes for annotated tag
   # This function reads the changelog from readme.txt for the current version
   # Falls back to standard git log if readme.txt doesn't have the changelog
   generate_release_notes() {
       local version=$1
       local main_file=$(find_main_plugin_file)
       
       # Get plugin information
       local plugin_name=$(grep -i "Plugin Name:" "$main_file" | head -1 | sed 's/.*Plugin Name:[[:space:]]*//' | sed 's/[[:space:]]*$//')
       
       # Start building release notes
       local release_notes="$plugin_name v$version"
       release_notes="$release_notes

"
       
       # Try to extract changelog from readme.txt
       local changelog_extracted=false
       
       echo "🔍 Looking for changelog in readme.txt..." >&2
       
       if [ -f "readme.txt" ]; then
           # Extract the changelog section for the current version
           # Look for the pattern: = X.Y.Z =
           local version_pattern="^= *${version} *="
           
           # Use awk to extract the specific version's changelog
           local changelog_content=$(awk -v version="$version_pattern" '
               BEGIN { in_changelog=0; found_version=0; capture=0 }
               /^== *Changelog *==/ { in_changelog=1; next }
               in_changelog && /^= *[0-9]+\.[0-9]+\.[0-9]+ *=/ {
                   if ($0 ~ version) {
                       found_version=1
                       capture=1
                       next
                   } else if (capture) {
                       exit
                   }
               }
               capture && /^[^=]/ { print }
               capture && /^$/ { print }
           ' readme.txt)
           
           if [ -n "$changelog_content" ]; then
               # Clean up the changelog content
               # Remove leading/trailing whitespace and empty lines
               changelog_content=$(echo "$changelog_content" | sed 's/^[[:space:]]*//' | sed '/^$/N;/^\n$/d')
               
               if [ -n "$changelog_content" ]; then
                   echo "✅ Found changelog for version $version in readme.txt" >&2
                   
                   # Format the changelog content for the tag
                   # Convert WordPress readme format to more readable format
                   local formatted_changelog=$(echo "$changelog_content" | sed 's/^\* /• /')
                   
                   release_notes="$release_notes$formatted_changelog"
                   changelog_extracted=true
               else
                   echo "⚠️  Version $version found in readme.txt but no changelog content" >&2
               fi
           else
               echo "⚠️  Version $version not found in readme.txt changelog section" >&2
           fi
       else
           echo "⚠️  readme.txt not found" >&2
       fi
       
       # If we couldn't extract from readme.txt, try wp-changelog or fallback
       if [ "$changelog_extracted" = false ]; then
           echo "ℹ️  Falling back to alternative changelog generation methods" >&2
           
           # Try to find previous tag to generate changelog
           local previous_tag=$(git tag -l "v*" | sort -V | tail -2 | head -1)
           
           # Try to use wp-changelog generator if available
           local temp_changelog_file=$(mktemp)
           
           if [ -n "$previous_tag" ] && [ "$previous_tag" != "v$version" ]; then
               echo "🔍 Attempting to generate changelog using wp-changelog..." >&2
               
               if command -v wp-changelog >/dev/null 2>&1; then
                   wp-changelog --commit-range "$previous_tag..HEAD" --format md --user-friendly --version "$version" --output "$temp_changelog_file" 2>/dev/null
                   
                   if [ $? -eq 0 ] && [ -s "$temp_changelog_file" ]; then
                       local changelog_content=$(cat "$temp_changelog_file" | sed '1,/^## /d' | sed '/^$/N;/^\n$/d')
                       
                       if [ -n "$changelog_content" ]; then
                           release_notes="$release_notes$changelog_content"
                           changelog_extracted=true
                           echo "✅ Successfully generated changelog using wp-changelog" >&2
                       fi
                   fi
               fi
           fi
           
           # Clean up temp file
           rm -f "$temp_changelog_file"
           
           # Final fallback to basic git log
           if [ "$changelog_extracted" = false ]; then
               echo "ℹ️  Using basic git log for changelog" >&2
               
               # Add basic description if available
               local plugin_description=$(grep -i "Description:" "$main_file" | head -1 | sed 's/.*Description:[[:space:]]*//' | sed 's/[[:space:]]*$//')
               if [ -n "$plugin_description" ]; then
                   release_notes="$release_notes$plugin_description

"
               fi
               
               # Add changelog if previous tag exists
               if [ -n "$previous_tag" ] && [ "$previous_tag" != "v$version" ]; then
                   release_notes="$release_notes
Changes since $previous_tag:

"
                   
                   # Get commits since previous tag
                   local commits=$(git log --oneline "$previous_tag"..HEAD --no-merges | head -20)
                   if [ -n "$commits" ]; then
                       release_notes="$release_notes$(echo "$commits" | sed 's/^/- /')

"
                   fi
               fi
           fi
       fi
       
       # Always add release date at the end
       release_notes="$release_notes

Release Date: $(date '+%Y-%m-%d')"
       
       echo "$release_notes"
   }
   ```
   ```

3. **Tag Verification and Listing**
   ```markdown
   ## Tag Verification and Management
   
   ### Verification System
   ```bash
   #!/bin/bash
   
   # Verify tag matches plugin version
   verify_tag_version() {
       local plugin_version=$(get_plugin_version)
       
       if [ -z "$plugin_version" ]; then
           echo "❌ Could not determine plugin version"
           return 1
       fi
       
       local expected_tag="v$plugin_version"
       
       echo "🔍 Plugin version verification"
       echo "Plugin file version: $plugin_version"
       echo "Expected tag: $expected_tag"
       
       # Check if tag exists
       if tag_exists "$expected_tag"; then
           echo "✅ Tag exists and matches plugin version"
           
           # Show tag details
           echo -e "\n📋 Tag Details:"
           git show --no-patch --format="Commit: %H%nDate: %ci%nAuthor: %an <%ae>" "$expected_tag"
           
           # Show tag message if annotated
           if git cat-file -t "$expected_tag" | grep -q "tag"; then
               echo -e "\n📝 Tag Message:"
               git tag -l --format='%(contents)' "$expected_tag"
           fi
           
           return 0
       else
           echo "❌ Tag does not exist for current plugin version"
           echo "Run with --create to create the tag"
           return 1
       fi
   }
   
   # List all plugin version tags
   list_plugin_tags() {
       echo "🏷️  WordPress Plugin Version Tags"
       echo "================================="
       
       # Get all version tags
       local tags=$(git tag -l "v*" | sort -V)
       
       if [ -z "$tags" ]; then
           echo "No version tags found"
           return 0
       fi
       
       echo "Local Tags:"
       for tag in $tags; do
           local tag_commit=$(git rev-list -n 1 "$tag" 2>/dev/null)
           local tag_date=$(git log -1 --format="%ci" "$tag_commit" 2>/dev/null | cut -d' ' -f1)
           local tag_type="lightweight"
           
           if git cat-file -t "$tag" 2>/dev/null | grep -q "tag"; then
               tag_type="annotated"
           fi
           
           echo "  $tag ($tag_type) - $tag_date"
       done
       
       # Check remote tags
       echo -e "\nRemote Tags:"
       git ls-remote --tags origin 2>/dev/null | grep "refs/tags/v" | while read commit ref; do
           local tag_name=$(echo "$ref" | sed 's|refs/tags/||')
           echo "  $tag_name (remote)"
       done
       
       # Show current plugin version
       local current_version=$(get_plugin_version)
       if [ -n "$current_version" ]; then
           echo -e "\nCurrent plugin version: $current_version"
           local current_tag="v$current_version"
           
           if echo "$tags" | grep -q "^$current_tag$"; then
               echo "✅ Tag exists for current version"
           else
               echo "❌ No tag exists for current version"
           fi
       fi
   }
   
   # Delete tag locally and remotely
   delete_plugin_tag() {
       local tag_name=$1
       
       if [ -z "$tag_name" ]; then
           echo "❌ Tag name is required"
           return 1
       fi
       
       # Ensure tag name has v prefix
       if [[ ! $tag_name =~ ^v ]]; then
           tag_name="v$tag_name"
       fi
       
       echo "🗑️  Deleting tag: $tag_name"
       
       # Confirm deletion
       read -p "Are you sure you want to delete tag $tag_name? (y/n): " -n 1 -r
       echo
       if [[ ! $REPLY =~ ^[Yy]$ ]]; then
           echo "❌ Deletion cancelled"
           return 1
       fi
       
       # Delete local tag
       if git tag -l | grep -q "^$tag_name$"; then
           git tag -d "$tag_name"
           echo "✅ Local tag deleted"
       else
           echo "ℹ️  Tag does not exist locally"
       fi
       
       # Delete remote tag
       if git ls-remote --tags origin | grep -q "refs/tags/$tag_name$"; then
           git push origin ":refs/tags/$tag_name"
           echo "✅ Remote tag deleted"
       else
           echo "ℹ️  Tag does not exist on remote"
       fi
   }
   ```
   ```

4. **Complete WordPress Tag Management Workflow**
   ```markdown
   ## Complete Tag Management System
   
   ### Main Tag Management Function
   ```bash
   #!/bin/bash
   
   # Main WordPress plugin tag management
   wp_tag_manager() {
       local action="verify"
       local tag_to_delete=""
       local force_create=false
       local push_tag=false
       local annotated=true
       
       # Parse arguments
       while [[ $# -gt 0 ]]; do
           case $1 in
               --create)
                   action="create"
                   shift
                   ;;
               --verify)
                   action="verify"
                   shift
                   ;;
               --list)
                   action="list"
                   shift
                   ;;
               --delete)
                   action="delete"
                   tag_to_delete="$2"
                   shift 2
                   ;;
               --force)
                   force_create=true
                   shift
                   ;;
               --push)
                   push_tag=true
                   shift
                   ;;
               --annotated)
                   annotated=true
                   shift
                   ;;
               --lightweight)
                   annotated=false
                   shift
                   ;;
               *)
                   echo "Unknown option: $1"
                   echo "Usage: wp-tag [--create|--verify|--list|--delete <tag>] [--force] [--push] [--annotated|--lightweight]"
                   return 1
                   ;;
           esac
       done
       
       echo "🏷️  WordPress Plugin Tag Manager"
       echo "================================="
       
       # Validate we're in a WordPress plugin directory
       if ! find_main_plugin_file >/dev/null 2>&1; then
           echo "❌ Not in a WordPress plugin directory!"
           echo "Please run this command from the root of your WordPress plugin."
           return 1
       fi
       
       case $action in
           "create")
               echo -e "\n🚀 Creating WordPress Plugin Tag"
               echo "================================="
               
               # First, fetch all remote changes
               echo "🔄 Fetching latest changes from all remotes..."
               git fetch --all
               
               if [ $? -ne 0 ]; then
                   echo "❌ Failed to fetch from remotes"
                   echo "Please check your network connection and try again"
                   return 1
               fi
               
               # Get current branch and determine main branch
               local current_branch=$(git rev-parse --abbrev-ref HEAD)
               local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@' 2>/dev/null || echo "main")
               
               echo "Current branch: $current_branch"
               echo "Main branch: $default_branch"
               
               # Switch to main branch if not already there
               if [ "$current_branch" != "$default_branch" ] && [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
                   echo "📌 Switching to main branch ($default_branch)..."
                   
                   # Try to checkout the default branch, fall back to main, then master
                   if ! git checkout "$default_branch" 2>/dev/null; then
                       if ! git checkout main 2>/dev/null; then
                           if ! git checkout master 2>/dev/null; then
                               echo "❌ Failed to switch to main branch"
                               echo "Available branches:"
                               git branch -a
                               return 1
                           fi
                       fi
                   fi
                   
                   echo "✅ Switched to main branch"
               else
                   echo "✅ Already on main branch"
               fi
               
               # Pull latest changes from main
               local current_branch_name=$(git rev-parse --abbrev-ref HEAD)
               echo "📥 Pulling latest changes from origin/$current_branch_name..."
               git pull origin "$current_branch_name"
               
               if [ $? -ne 0 ]; then
                   echo "❌ Failed to pull latest changes"
                   echo "Please resolve any conflicts and try again"
                   return 1
               fi
               
               echo "✅ Repository is up-to-date"
               
               # Now validate we're on main branch (should always be true at this point)
               if ! validate_main_branch; then
                   return 1
               fi
               
               # Double-check branch is updated (should be redundant now)
               if ! ensure_branch_updated; then
                   return 1
               fi
               
               # Get plugin version
               local plugin_version=$(get_plugin_version)
               if [ -z "$plugin_version" ]; then
                   echo "❌ Could not determine plugin version"
                   return 1
               fi
               
               echo "Plugin version: $plugin_version"
               
               # Create the tag
               create_plugin_tag "$plugin_version" "$force_create" "$annotated" "$push_tag"
               ;;
               
           "verify")
               echo -e "\n🔍 Verifying Plugin Tag"
               echo "======================="
               
               verify_tag_version
               ;;
               
           "list")
               echo -e "\n📋 Plugin Tags List"
               echo "==================="
               
               list_plugin_tags
               ;;
               
           "delete")
               if [ -z "$tag_to_delete" ]; then
                   echo "❌ Tag name required for delete action"
                   echo "Usage: wp-tag --delete <tag-name>"
                   return 1
               fi
               
               echo -e "\n🗑️  Deleting Plugin Tag"
               echo "======================="
               
               delete_plugin_tag "$tag_to_delete"
               ;;
               
           *)
               echo "❌ Unknown action: $action"
               return 1
               ;;
       esac
   }
   ```
   ```

5. **Integration with Existing Workflow**
   ```markdown
   ## Workflow Integration
   
   ### Integration with wp-version.md and prepare-pr-main.md
   ```bash
   #!/bin/bash
   
   # Complete workflow integration
   wp_release_workflow_integration() {
       echo "🔄 WordPress Plugin Release Workflow Integration"
       echo "================================================"
       
       echo "This command integrates with your existing workflow:"
       echo ""
       echo "1. 📝 wp-version.md - Version management and updates"
       echo "2. 🔀 prepare-pr-main.md - Pull request creation"
       echo "3. 🏷️ wp-tag.md - Tag creation (this command)"
       echo ""
       echo "Recommended workflow:"
       echo ""
       echo "Development Phase:"
       echo "  1. Work on feature branches"
       echo "  2. Use wp-version --analyze to determine version increment"
       echo "  3. Use wp-version --update X.Y.Z to update version"
       echo "  4. Use prepare-pr-main to create pull request"
       echo ""
       echo "Release Phase (on main branch):"
       echo "  5. Merge PR to main branch"
       echo "  6. Use wp-tag --create --push to create and push release tag"
       echo ""
       echo "Maintenance:"
       echo "  - Use wp-tag --list to view all release tags"
       echo "  - Use wp-tag --verify to check tag consistency"
       echo "  - Use wp-tag --delete <tag> if needed to remove incorrect tags"
   }
   
   # Show post-tag creation next steps
   show_post_tag_steps() {
       local tag_name=$1
       local plugin_version=$2
       
       echo -e "\n🎉 Tag Creation Complete!"
       echo "========================"
       echo "Tag: $tag_name"
       echo "Version: $plugin_version"
       echo ""
       echo "📋 Next Steps:"
       echo "1. ✅ Tag created and pushed to repository"
       echo "2. 🚀 Create GitHub release (if using GitHub)"
       echo "3. 📦 Build plugin distribution package"
       echo "4. 🌐 Update WordPress.org repository (if applicable)"
       echo "5. 📢 Announce release to users"
       echo ""
       echo "💡 Useful commands:"
       echo "  gh release create $tag_name    # Create GitHub release"
       echo "  wp-tag --list                  # View all tags"
       echo "  git show $tag_name             # View tag details"
   }
   ```
   ```

## Usage Examples

```bash
# Verify current plugin version has matching tag
wp-tag --verify

# Create tag for current plugin version
wp-tag --create

# Create and push tag to remote
wp-tag --create --push

# Force create tag (overwrite if exists)
wp-tag --create --force --push

# Create lightweight tag (no release notes)
wp-tag --create --lightweight

# List all plugin version tags
wp-tag --list

# Delete a specific tag
wp-tag --delete v1.2.3

# Complete workflow integration help
wp-tag --help-workflow

# Example complete workflow:
# 1. After merging PR to main, just run wp-tag (it handles git operations):
wp-tag --create --push

# 2. Verify tag was created correctly:
wp-tag --verify

# Note: wp-tag automatically:
# - Fetches all remote changes
# - Switches to main branch if needed
# - Pulls latest changes
# - Then creates the tag
```

**WordPress Plugin Release Workflow:**
1. **Development**: Use wp-version.md to manage version updates
2. **Pull Request**: Use prepare-pr-main.md to create comprehensive PRs
3. **Release**: Use wp-tag.md to create release tags from main branch
4. **Verification**: Always verify tags match plugin versions
5. **Distribution**: Tags serve as release points for plugin distribution
6. **Maintenance**: Clean up incorrect or obsolete tags as needed

**Tag Naming Convention:**
- Format: `vMAJOR.MINOR.PATCH` (e.g., v1.2.3)
- Always prefix with 'v' for consistency
- Must match semantic version in plugin file
- Annotated tags include release notes and changelog
- Lightweight tags for simple version markers

**Changelog Integration:**
- **Primary Source**: Reads changelog directly from readme.txt for consistency
- Extracts the specific version's changelog from the `== Changelog ==` section
- Ensures tag description matches exactly what users see in readme.txt
- **Fallback Methods** (in order):
  1. Uses wp-changelog generator if readme.txt doesn't have the version
  2. Falls back to standard git log if neither method works
- Tag descriptions include plugin name, version, changelog, and release date