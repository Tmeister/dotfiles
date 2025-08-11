## ⚠️ EXTREMELY IMPORTANT DEVELOPMENT GUIDELINES

### **Code Quality and Diagnostics**

- **ALWAYS use `mcp_ide_getDiagnostics`** after modifying any file\*\* to check for linting and type errors
- **DO NOT build the app on every step** - only build when specifically testing or deploying
- **Fix any diagnostics issues immediately** before proceeding with additional changes
- **Prioritize code quality** over speed of implementation
- Do not add your signature to the commit messages
- Never use ENUM fields on the database, always use either text or tinyints, but never enums
- Never use — in text 

### Laravel

- **Auth:** Always use the Auth facade for get the authenticated user, example: instead of `auth()->user` use Auth::user()
- **Eloquent:** When using eloquent use the query() method at the beginning, example, instead of `Model::where()` use Model::query()->where()

### **Task Execution**

- Think carefully and only action the specific task I have given you with the most concise and elegant solution that changes as little code as possible

## 📚 Style Guide System

### Available Style Guides

The `~/.claude/styles/` directory contains coding style guides for different frameworks:

- **laravel-spatie**: Spatie's Laravel & PHP conventions
- **react-airbnb**: Airbnb's React/JSX style guide
- **node-standard**: JavaScript Standard Style

Each style guide includes:

- `style.md` - Quick reference guide
- `guidelines.md` - Comprehensive rules
- `quick-rules/` - Bite-sized rule files
- `templates/` - Code templates

### My Universal Preferences

Check `~/.claude/my-preferences.md` for coding preferences that apply across all projects:

- Early returns over nested conditions
- Explicit types when available
- Functional over class-based patterns
- RESTful API conventions

### How to Use Styles in a Project

#### Option 1: Reference the style guide directly

When starting work on a project, tell Claude which style to use:

```
"Use the laravel-spatie style guide from ~/.claude/styles/laravel-spatie for this project"
```

#### Option 2: Create a project-specific CLAUDE.md

In your project root, create a `CLAUDE.md` file that references the style:

```markdown
# Project Style Guide

Please follow the ~/.claude/styles/laravel-spatie style guide for this project.
```

#### Option 3: Quick reference specific rules

For targeted style checks:

```
"Check ~/.claude/styles/laravel-spatie/quick-rules/naming.txt for naming conventions"
```

### Example Usage

```bash
# For a Laravel project
"Apply the Spatie Laravel conventions from ~/.claude/styles/laravel-spatie"

# For a React project
"Use ~/.claude/styles/react-airbnb for component structure"

# For general preferences
"Follow my preferences in ~/.claude/my-preferences.md"
```
- never user php artisan migrate:fresh without user confirmation