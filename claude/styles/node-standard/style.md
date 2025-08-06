# Quick Style Reference - Node.js Standard

## Core Rules
- 2 space indentation
- Single quotes for strings
- No semicolons
- Space after keywords
- No unused variables

## Naming
- camelCase: variables, functions
- PascalCase: classes, constructors
- SCREAMING_SNAKE_CASE: constants
- Prefix private with _ (deprecated)

## Module Structure
```js
// Imports
const express = require('express')
const { someFunction } = require('./utils')

// Constants
const PORT = process.env.PORT || 3000

// Main code
const app = express()

// Exports
module.exports = app
```

## Error Handling
- Error-first callbacks
- Try/catch for async/await
- Always handle Promise rejections

## Express Patterns
```js
// Routes in separate files
// Middleware for cross-cutting concerns
// Environment variables for config
// Graceful shutdown handling
```