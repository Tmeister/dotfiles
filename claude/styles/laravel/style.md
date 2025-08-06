# Quick Style Reference - Laravel Spatie

## Core Rules
- Early returns, no else
- ?string not string|null  
- void returns explicit
- Type all properties

## Naming
- camelCase: variables, route names, policies
- kebab-case: URLs, commands, config files, multi-word resources
- PascalCase: enums, classes
- snake_case: config keys, custom validation rules
- Plural: controllers, resources

## Laravel Patterns
- Array validation rules `['required', 'email']`
- Route tuples `[Controller::class, 'method']`
- 4-space Blade indent, no spaces after @if
- Use __() for translations
- No env() outside config

## Code Structure
- Unhappy path first
- Each trait on own line
- String interpolation over concat
- Blank lines between statements
- Constructor property promotion with trailing comma

## CRUD Operations
- index, create, store, show, edit, update, destroy
- Use 'view' instead of 'show' for user-facing