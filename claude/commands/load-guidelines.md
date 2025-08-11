# Load Guidelines

Load project-specific coding guidelines and style guides for consistent development.

## Instructions

Load the appropriate style guide and preferences for: **$ARGUMENTS**

**Supported project types:**
- `laravel` - Laravel with Spatie conventions
- `laravel-inertia` - Laravel backend with React/Inertia frontend
- `wordpress` - WordPress development standards
- `node` - Node.js with JavaScript Standard Style
- `react` - React with Airbnb style guide

1. **Parse Project Type**
   - Extract the project type from arguments
   - Map to appropriate style guide(s)
   - Handle compound types (e.g., laravel-inertia loads both Laravel and React guides)

2. **Load Universal Preferences**
   ```bash
   # Always load universal preferences first
   cat ~/.claude/my-preferences.md
   ```
   Apply these preferences across all code:
   - Early returns over nested conditions
   - Explicit types when available
   - Functional over class-based patterns
   - RESTful API conventions
   - No comments explaining what, only why

3. **Load Project-Specific Style Guide**
   
   For **laravel**:
   ```bash
   # Load main style guide
   cat ~/.claude/styles/laravel/style.md
   cat ~/.claude/styles/laravel/guidelines.md
   
   # Load quick rules for reference
   ls ~/.claude/styles/laravel/quick-rules/
   ```
   Apply Spatie's Laravel conventions including:
   - Controller and model patterns
   - Blade templating rules
   - PHP type declarations
   - Naming conventions

   For **laravel-inertia**:
   ```bash
   # Load Laravel backend guidelines
   cat ~/.claude/styles/laravel/style.md
   
   # Load React frontend guidelines
   cat ~/.claude/styles/react-airbnb/style.md
   ```
   Apply both Laravel and React conventions for full-stack development

   For **node**:
   ```bash
   cat ~/.claude/styles/node-standard/style.md
   ```
   Apply JavaScript Standard Style:
   - No semicolons
   - 2-space indentation
   - Single quotes for strings

   For **react**:
   ```bash
   cat ~/.claude/styles/react-airbnb/style.md
   ```
   Apply Airbnb's React/JSX style guide:
   - Component structure
   - PropTypes/TypeScript types
   - Hooks patterns

   For **wordpress**:
   ```bash
   # Note: WordPress style guide to be added
   echo "WordPress coding standards will be applied when available"
   ```

4. **Confirm Guidelines Loaded**
   
   Acknowledge that the following guidelines are now active:
   - Universal preferences from `~/.claude/my-preferences.md`
   - Project-specific style guide(s) loaded
   - Quick rules available for reference
   
   State clearly: "I will follow the [PROJECT TYPE] coding guidelines throughout this session."

5. **Session Persistence**
   
   These guidelines remain active for the entire session. When writing or modifying code:
   - Reference quick rules for specific patterns
   - Check templates for boilerplate code
   - Maintain consistency with loaded style guides
   - Apply universal preferences to all code

## Examples

```bash
# Load Laravel guidelines
/load-guidelines laravel

# Load for Laravel with Inertia/React frontend
/load-guidelines laravel-inertia

# Load React guidelines
/load-guidelines react

# Load Node.js standards
/load-guidelines node
```

## Notes

- Guidelines persist throughout the session
- Use quick-rules for specific pattern lookups
- Templates provide boilerplate for common patterns
- Universal preferences always apply regardless of project type