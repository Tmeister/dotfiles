# Commit Generator

Generate a clean, concise conventional commit message and create the commit automatically.

## Instructions

Analyze current git changes and generate an appropriate conventional commit: **$ARGUMENTS**

1. **Analyze Git Status and Changes**

   ```bash
   git status --porcelain
   git diff --staged --name-only
   git diff --staged
   ```

2. **Determine Commit Type**
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation changes
   - `style`: Code style/formatting changes
   - `refactor`: Code refactoring
   - `perf`: Performance improvements
   - `test`: Test changes
   - `build`: Build system or dependency changes
   - `ci`: CI configuration changes
   - `chore`: Maintenance and tooling

3. **Identify Scope (Optional)**
   - Component or module affected (e.g., `auth`, `api`, `ui`)
   - Keep concise and lowercase

4. **Generate Commit Message Format**

   ```
   type(scope): description

   [optional body - keep concise]
   ```

5. **Message Guidelines**
   - **Description**: Imperative mood, lowercase, no period (≤50 chars)
   - **Body**: Brief explanation of WHAT and WHY (2-3 lines max)
   - Focus on core features/changes only
   - **DO NOT include:**
     - Individual file changes
     - Test results or pass counts
     - Testing instructions
     - Implementation details
     - Time estimates

6. **Examples**

   ```bash
   # Simple feature
   feat(auth): add OAuth2 login support

   # Feature with brief context
   feat(api): add user export functionality

   Allows users to export their data in CSV and JSON formats

   # Bug fix with explanation
   fix(database): prevent duplicate user entries

   Add unique constraint to email field

   # Breaking change
   feat(api)!: remove deprecated v1 endpoints

   BREAKING CHANGE: Use /api/v2 endpoints instead
   ```

7. **Commit Process**
   - Generate appropriate message based on core changes
   - Use `git commit -m "message"` for simple commits
   - Use `git commit -F -` for multi-line commits
   - Never add your signature to the commit message
