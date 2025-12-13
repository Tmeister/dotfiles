---
description: Generate conventional commit message
---

Analyze staged changes and create a conventional commit.

## Steps

1. **Check staged changes**

   ```bash
   git diff --staged --name-only
   git diff --staged
   ```

2. **Determine commit type**

   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation
   - `style`: Formatting
   - `refactor`: Code restructuring
   - `perf`: Performance
   - `test`: Tests
   - `chore`: Maintenance

3. **Generate commit message**
   Format: `type(scope): description`

   - Description: imperative mood, lowercase, no period, max 50 chars
   - Body (optional): brief 1-2 lines explaining WHY, not WHAT

4. **Create commit**
   - Simple: `git commit -m "type(scope): description"`
   - With body: `git commit -m "type(scope): description" -m "body"`

**Rules:**

- Never add signatures to commit messages
- Keep it concise
- Focus on the core change, not file lists

$ARGUMENTS
