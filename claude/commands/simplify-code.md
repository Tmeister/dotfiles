# Code Simplification Command

Refactor complex code to be more readable, maintainable, and easier to understand while preserving functionality and improving overall code quality.

## Instructions

Simplify and refactor complex code for better readability: **$ARGUMENTS**

**Flags:**
- `--scope <scope>`: Simplification scope - `function`, `class`, `file` (default), `module`
- `--strategy <strategy>`: Focus strategy - `extract-methods`, `reduce-complexity`, `improve-naming`, `all` (default)
- `--preserve-performance`: Ensure performance characteristics are maintained
- `--include-tests`: Update and simplify related test code
- `--dry-run`: Show proposed changes without applying them
- `--complexity-threshold <number>`: Target maximum cyclomatic complexity (default: 10)

1. **Code Complexity Analysis**
   ```markdown
   ## Complexity Assessment

   ### Current Complexity Metrics
   - **Cyclomatic Complexity**: ${CURRENT_COMPLEXITY}
   - **Cognitive Complexity**: ${COGNITIVE_COMPLEXITY}
   - **Lines of Code**: ${LOC}
   - **Nested Levels**: ${NESTING_DEPTH}
   - **Function Length**: ${FUNCTION_LENGTH}

   ### Complexity Hotspots Identified
   - **Deep Nesting**: Functions with more than 3 levels of indentation
   - **Long Functions**: Functions exceeding 50 lines
   - **Complex Conditionals**: Multiple AND/OR operations in single condition
   - **Nested Loops**: Loops within loops within loops
   - **Large Classes**: Classes with excessive responsibilities

   ### Maintainability Impact
   - **Bug Risk**: Higher complexity correlates with increased bug likelihood
   - **Development Speed**: Complex code slows down feature development
   - **Testing Difficulty**: Complex logic is harder to test comprehensively
   - **Knowledge Transfer**: New team members struggle with complex code
   ```

2. **Simplification Strategy Selection**
   ```markdown
   ## Refactoring Approach

   ### Extract Methods Strategy
   #### When to Apply
   - Functions longer than 20-30 lines
   - Code blocks with clear single responsibilities
   - Repeated code patterns
   - Complex calculations or business logic

   #### Benefits
   - Improved readability through descriptive method names
   - Enhanced testability of individual components
   - Reduced duplication through method reuse
   - Better separation of concerns

   ### Reduce Complexity Strategy
   #### When to Apply
   - Cyclomatic complexity greater than 10
   - Deep nesting levels (more than 3-4 levels)
   - Complex conditional expressions
   - Multiple responsibilities in single function

   #### Techniques
   - Early return patterns to reduce nesting
   - Guard clauses for input validation
   - Strategy pattern for complex conditionals
   - State machines for complex logic flows

   ### Improve Naming Strategy
   #### When to Apply
   - Unclear or misleading variable/function names
   - Generic names (data, temp, info, manager)
   - Abbreviated names without clear meaning
   - Names that don't reflect current purpose

   #### Guidelines
   - Use intention-revealing names
   - Prefer longer descriptive names over comments
   - Use domain-specific terminology
   - Make boolean names interrogative (is, has, can, should)
   ```

3. **Method Extraction and Decomposition**
   ```markdown
   ## Function Decomposition

   ### Large Function Breakdown
   #### Original Structure Analysis
   - Identify distinct responsibilities within function
   - Locate natural breaking points in logic flow
   - Find repeated code patterns
   - Identify side effects and dependencies

   #### Extraction Process
   1. **Single Responsibility Extraction**
      - Extract each responsibility into separate method
      - Ensure each method has single, clear purpose
      - Maintain logical flow in main function

   2. **Parameter Optimization**
      - Minimize parameter count (max 3-4 parameters)
      - Use objects for complex parameter sets
      - Consider builder patterns for complex configurations

   3. **Return Value Simplification**
      - Prefer single return type when possible
      - Use result objects for complex return values
      - Consider async patterns for better composability

   ### Class Decomposition
   #### Large Class Breakdown
   - Identify cohesive groups of methods and properties
   - Extract specialized classes for distinct responsibilities
   - Use composition over inheritance
   - Apply SOLID principles for better structure
   ```

4. **Conditional Logic Simplification**
   ```markdown
   ## Complex Conditional Refactoring

   ### Early Return Pattern
   #### Transform Deep Nesting
   - Replace nested if-else with guard clauses
   - Handle error cases first and return early
   - Reduce indentation levels for happy path
   - Improve readability through linear flow

   ### Boolean Expression Simplification
   #### Complex Condition Breakdown
   - Extract complex boolean expressions into well-named variables
   - Use De Morgan's laws to simplify negative conditions
   - Replace magic numbers with named constants
   - Group related conditions logically

   ### Polymorphism Over Conditionals
   #### Strategy Pattern Application
   - Replace long if-else chains with strategy objects
   - Use factory patterns for object creation based on type
   - Implement visitor pattern for complex type-based operations
   - Apply command pattern for complex action selection

   ### State Machine Implementation
   #### Complex State Logic
   - Model state transitions explicitly
   - Use state pattern for complex state-dependent behavior
   - Separate state management from business logic
   - Make state changes predictable and testable
   ```

5. **Loop and Iteration Improvements**
   ```markdown
   ## Iteration Pattern Optimization

   ### Functional Programming Patterns
   #### Higher-Order Function Usage
   - Replace manual loops with map, filter, reduce operations
   - Use functional composition for complex transformations
   - Leverage language-specific iteration utilities
   - Prefer declarative over imperative style

   ### Performance-Conscious Simplification
   #### Efficient Iteration Patterns
   - Use early termination where appropriate
   - Minimize memory allocation in tight loops
   - Consider lazy evaluation for large datasets
   - Profile before and after performance-critical changes

   ### Nested Loop Elimination
   #### Flattening Strategies
   - Extract inner loops into separate methods
   - Use data structure preprocessing to avoid nested iteration
   - Consider algorithmic improvements (O(n²) to O(n log n))
   - Apply memoization for expensive repeated calculations
   ```

6. **Data Structure and Type Improvements**
   ```markdown
   ## Data Organization Enhancement

   ### Type Safety Improvements
   #### Strong Typing Application
   - Replace primitive obsession with domain types
   - Use enums instead of magic strings/numbers
   - Implement value objects for complex data
   - Apply type constraints to prevent invalid states

   ### Data Structure Optimization
   #### Appropriate Collection Usage
   - Choose optimal data structures for access patterns
   - Use immutable structures where appropriate
   - Implement proper encapsulation for complex data
   - Apply builder patterns for complex object construction

   ### Interface Simplification
   #### API Design Improvement
   - Minimize public interface surface area
   - Use composition over complex inheritance hierarchies
   - Apply principle of least privilege to method visibility
   - Design for extensibility without complexity
   ```

7. **Error Handling Simplification**
   ```markdown
   ## Error Management Streamlining

   ### Consistent Error Handling
   #### Pattern Standardization
   - Implement consistent error handling patterns
   - Use result types or option types where appropriate
   - Centralize error logging and reporting
   - Apply fail-fast principles for input validation

   ### Exception Management
   #### Simplified Exception Flow
   - Replace try-catch blocks with error types where possible
   - Use specific exception types instead of generic ones
   - Implement proper error recovery strategies
   - Document expected error conditions clearly

   ### Validation Simplification
   #### Input Validation Streamlining
   - Extract validation logic into dedicated validators
   - Use declarative validation frameworks where available
   - Implement chain-of-responsibility for complex validation
   - Provide clear, actionable error messages
   ```

8. **Testing Integration and Improvement**
   ```markdown
   ## Test Code Simplification

   ### Test Structure Enhancement
   #### Test Organization
   - Group related tests using nested describe blocks
   - Extract common test setup into helper methods
   - Use descriptive test names that explain behavior
   - Apply arrange-act-assert pattern consistently

   ### Test Data Management
   #### Test Data Simplification
   - Use factory methods for test object creation
   - Implement builder patterns for complex test scenarios
   - Centralize test data management
   - Use property-based testing for edge case coverage

   ### Assertion Improvements
   #### Clear Test Assertions
   - Use domain-specific assertion methods
   - Implement custom matchers for complex conditions
   - Provide clear failure messages
   - Test one concept per test method
   ```

9. **Documentation and Comments Strategy**
   ```markdown
   ## Documentation Simplification

   ### Comment Necessity Evaluation
   #### When to Comment
   - Complex business rules that aren't obvious from code
   - Non-obvious performance optimizations
   - Workarounds for external system limitations
   - Public API documentation

   #### When to Refactor Instead of Comment
   - Complex code that could be simplified
   - Variable or method names that need explanation
   - Business logic that could be extracted to well-named methods
   - Magic numbers that could be named constants

   ### Self-Documenting Code
   #### Code as Documentation
   - Use intention-revealing names for variables and methods
   - Structure code to tell a story
   - Apply consistent coding patterns and conventions
   - Make code flow match mental model of the domain
   ```

10. **Quality Assurance and Validation**
    ```markdown
    ## Simplification Validation

    ### Functionality Preservation
    #### Testing Strategy
    - Run complete test suite before and after changes
    - Add characterization tests for legacy code without tests
    - Verify edge cases and error conditions still work
    - Test performance-critical paths with benchmarks

    ### Complexity Measurement
    #### Metrics Tracking
    - Measure cyclomatic complexity reduction
    - Track cognitive complexity improvements
    - Monitor code coverage changes
    - Assess maintainability index improvements

    ### Code Review Process
    #### Quality Gates
    - Peer review of all simplification changes
    - Verify business logic understanding is preserved
    - Confirm naming improvements enhance clarity
    - Validate architectural decisions support long-term goals

    ### Performance Validation
    #### Performance Testing
    - Benchmark critical paths before and after changes
    - Monitor memory usage patterns
    - Verify no regression in response times
    - Test with realistic data volumes
    ```

11. **Language-Specific Simplification Patterns**
    ```markdown
    ## Language-Specific Guidelines

    ### Functional Languages
    #### Immutability and Pure Functions
    - Prefer pure functions over stateful operations
    - Use immutable data structures by default
    - Leverage function composition for complex operations
    - Apply monadic patterns for error handling

    ### Object-Oriented Languages
    #### OOP Best Practices
    - Apply SOLID principles for class design
    - Use composition over inheritance
    - Implement proper encapsulation
    - Apply design patterns appropriately, not excessively

    ### Procedural Languages
    #### Structured Programming
    - Use structured control flow (avoid goto)
    - Group related functions in modules
    - Minimize global state
    - Apply consistent error handling patterns

    ### Modern Language Features
    #### Language-Specific Improvements
    - Use pattern matching where available
    - Leverage async/await for cleaner asynchronous code
    - Apply destructuring for cleaner variable assignment
    - Use type inference to reduce verbosity without losing clarity
    ```

12. **Refactoring Safety and Risk Management**
    ```markdown
    ## Safe Refactoring Practices

    ### Incremental Changes
    #### Step-by-Step Approach
    - Make small, focused changes
    - Commit after each logical improvement
    - Run tests after each change
    - Use feature flags for risky changes

    ### Rollback Preparedness
    #### Risk Mitigation
    - Maintain clean git history for easy rollback
    - Document reasons for each change
    - Keep original version accessible during transition
    - Plan rollback procedures for production deployments

    ### Change Impact Assessment
    #### Impact Analysis
    - Identify all code that depends on changed interfaces
    - Update documentation affected by changes
    - Consider backward compatibility requirements
    - Plan communication for breaking changes
    ```

## Usage Examples

```bash
# Simplify entire file with all strategies
/simplify-code src/complex-service.js

# Focus on method extraction only
/simplify-code --strategy extract-methods src/large-controller.py

# Simplify with performance preservation
/simplify-code --preserve-performance --scope function calculateComplexMetrics

# Dry run to see proposed changes
/simplify-code --dry-run --complexity-threshold 5 src/legacy-code.java

# Include test simplification
/simplify-code --include-tests src/service.ts

# Focus on naming improvements
/simplify-code --strategy improve-naming src/utils/
```

**Simplification Quality Standards:**
- Preserve all existing functionality
- Maintain or improve performance characteristics
- Increase code readability and maintainability
- Follow language-specific best practices and idioms
- Ensure comprehensive test coverage
- Document significant architectural changes
- Apply consistent coding standards throughout
