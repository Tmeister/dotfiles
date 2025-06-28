# Commit Generator

Generate a conventional commit message following the Conventional Commits specification and create the commit automatically.

## Instructions

Analyze current git changes and generate an appropriate conventional commit: **$ARGUMENTS**

**Flags:**
- `--no-review`: Skip confirmation and commit immediately
- If `--no-review` is not provided, show the commit message and ask for confirmation

1. **Analyze Git Status and Changes**
   ```bash
   # Check staged changes
   git status --porcelain
   git diff --staged --name-only
   git diff --staged
   ```

2. **Determine Commit Type**
   - `feat`: New feature for the user
   - `fix`: Bug fix for the user
   - `docs`: Documentation changes
   - `style`: Code style changes (formatting, semicolons, etc.)
   - `refactor`: Code changes that neither fix bugs nor add features
   - `perf`: Performance improvements
   - `test`: Adding or modifying tests
   - `build`: Changes to build system or dependencies
   - `ci`: Changes to CI configuration
   - `chore`: Other changes (maintenance, tooling, etc.)
   - `revert`: Reverts a previous commit

3. **Identify Scope (Optional)**
   - Component, module, or area affected
   - Examples: `auth`, `api`, `ui`, `database`, `config`
   - Keep scope concise and lowercase

4. **Generate Commit Message Format**
   ```
   type(scope): description
   
   [optional body]
   
   [optional footer(s)]
   ```

5. **Message Guidelines**
   - **Description**: Imperative mood, lowercase, no period (≤50 chars)
   - **Body**: Explain what and why, wrap at 72 characters
   - **Footer**: BREAKING CHANGE or issue references

6. **Breaking Changes**
   ```
   feat(api)!: remove deprecated user endpoint
   
   BREAKING CHANGE: The /api/v1/user endpoint has been removed.
   Use /api/v2/users instead.
   ```

7. **Examples**
   ```bash
   # Simple feature
   feat(auth): add OAuth2 login support
   
   # Bug fix with scope
   fix(api): resolve null pointer in user endpoint
   
   # Documentation
   docs: update installation instructions
   
   # Dependency update
   chore(deps): bump lodash to 4.17.21
   
   # Breaking change
   feat(database)!: migrate to PostgreSQL
   
   BREAKING CHANGE: SQLite support has been removed.
   Update connection strings to use PostgreSQL format.
   ```

8. **Commit Process**
   - Generate appropriate message based on staged changes
   - Check if `--no-review` flag is present in arguments
   - If `--no-review` flag is NOT present:
     - Display the generated commit message
     - Ask for user confirmation before proceeding
     - Wait for user approval before committing
   - If `--no-review` flag IS present:
     - Proceed directly to commit without showing message or asking for confirmation
   - Use `git commit -m "message"` for simple commits
   - Use `git commit -F -` for multi-line commits with body/footer
   - Ensure all staged changes are included

Follow the specification strictly to enable automated changelog generation and semantic versioning and never add your signature on the commit message.
