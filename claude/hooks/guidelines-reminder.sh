#!/bin/bash

# Guidelines Reminder Hook for Claude Code
# For SessionStart hooks, stdout is added to Claude's context (not shown to user directly)

cat <<'EOF'
.
====================================================================
                 🎯 PROJECT GUIDELINES REMINDER                     
====================================================================

IMPORTANT: Remember to load the appropriate guidelines for your project 
to ensure consistent code style and best practices!

Available project types for /load-guidelines command:
• laravel         - Laravel with Spatie conventions
• laravel-inertia - Laravel backend + React/Inertia frontend
• wordpress       - WordPress development standards
• node            - Node.js with JavaScript Standard Style
• react           - React with Airbnb style guide

The user should run: /load-guidelines <project-type>

Examples:
• /load-guidelines laravel
• /load-guidelines laravel-inertia
• /load-guidelines react

Please remind the user to load guidelines if they haven't already.
====================================================================
.
EOF

# Exit with 0 to add this to Claude's context
exit 0

