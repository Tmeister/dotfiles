# Feature Issue Command

Systematically implement new features from GitHub issues using a comprehensive workflow that works across any repository.

## Instructions

Follow this structured approach to implement features from issues: **$ARGUMENTS**

1. **Issue Analysis**

   - Use `gh issue view $ARGUMENTS` to get complete issue details
   - Read the issue description, comments, and any requirements/specifications
   - Identify the scope and requirements of the feature
   - Understand the expected functionality and user experience

2. **Environment Setup**

   - Ensure you're on the correct branch (usually main/master)
   - Pull latest changes: `git pull origin main`
   - Create a new feature branch: `git checkout -b feature/{feature-name}-$ARGUMENTS`

3. **Feature Planning**

   - Break down the feature into smaller, manageable tasks
   - Identify affected components and modules
   - Plan the implementation approach and architecture
   - Consider dependencies and integration points

4. **Design Analysis**

   - Review existing codebase structure and patterns
   - Design the feature to align with current architecture
   - Plan for extensibility and maintainability
   - Consider performance implications

5. **Implementation Strategy**

   - Start with core functionality
   - Build incrementally with working checkpoints
   - Follow project conventions and patterns
   - Implement proper error handling and validation

6. **Development**

   - Write clean, well-structured code
   - Follow the project's coding standards
   - Add appropriate logging and debugging support
   - Ensure code is self-documenting with clear naming

7. **Testing Implementation**

   - Write comprehensive unit tests for new functionality
   - Focus on core features we don't need bloated tests
   - Add integration tests where appropriate
   - Ensure all existing tests continue to pass

8. **User Interface (if applicable)**

   - Implement UI components following design guidelines
   - Ensure accessibility standards are met
   - Test across different browsers/devices
   - Optimize for performance and user experience

9. **Code Quality Assurance**

   - Run linting and formatting tools
   - Use `mcp_ide_getDiagnostics` to check for errors
   - Perform code review self-check
   - Ensure no security vulnerabilities are introduced

10. **Documentation**

    - Document new APIs and interfaces
    - Update user documentation if needed
    - Add inline comments for complex logic
    - Update README or wiki as appropriate

11. **Final Testing**

    - Perform end-to-end testing of the feature
    - Verify all acceptance criteria are met
    - Test integration with existing features
    - Check for performance regressions

12. **Commit Changes**
    - ALWAYS ask the user before to stage changes and wait for the response
    - Stage the changes: `git add .`
    - use the command /commit to get a good commit message
    - Keep commits logical and atomic

<!--13. **Create Pull Request**-->
<!--    - Ask the user if want to make a pr if the answer is no, continue next step-->
<!--    - Use `gh pr create` to create a pull request-->
<!--    - Reference the issue: "Implements #$ARGUMENTS"-->
<!--    - Provide detailed description of the implementation-->
<!--    - Include testing steps and screenshots if relevant-->

14. **Follow-up**

    - Monitor the PR for feedback
    - Address review comments promptly
    - Update the issue with implementation progress
    - Ensure all CI/CD checks pass

15. **Post-Implementation**
    - Once merged, verify the feature in main branch
    - Update issue status and add implementation notes
    - Monitor for any issues or user feedback

Remember to communicate progress on the issue, ask for clarification when needed, and prioritize clean, maintainable code that enhances the project's value.
