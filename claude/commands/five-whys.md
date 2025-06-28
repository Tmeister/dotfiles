# Five Whys Root Cause Analysis

Use the Five Whys technique to systematically identify the root cause of problems through iterative questioning.

## Instructions

Conduct a Five Whys analysis to identify root causes: **$ARGUMENTS**

**Flags:**
- `--template <type>`: Use specific template (incident, bug, process, performance, user-experience)
- `--depth <number>`: Number of "why" iterations (default: 5, max: 10)
- `--collaborative`: Generate questions for team discussion
- `--output <file>`: Save analysis to file
- `--format <format>`: Output format - `markdown` (default), `json`, `yaml`
- `--include-actions`: Include recommended corrective actions
- `--severity <level>`: Problem severity (low, medium, high, critical)

1. **Problem Definition and Context Gathering**
   ```markdown
   ## Problem Statement

   **Date**: ${DATE}
   **Reporter**: ${REPORTER}
   **Severity**: ${SEVERITY}
   **System/Component**: ${COMPONENT}

   ### Initial Problem Description
   ${PROBLEM_DESCRIPTION}

   ### Observable Symptoms
   - ${SYMPTOM_1}
   - ${SYMPTOM_2}
   - ${SYMPTOM_3}

   ### Context and Environment
   - **When did it occur**: ${TIMESTAMP}
   - **Frequency**: ${FREQUENCY}
   - **Affected users/systems**: ${SCOPE}
   - **Environment**: ${ENVIRONMENT}
   - **Recent changes**: ${RECENT_CHANGES}
   ```

2. **Five Whys Analysis Framework**
   ```markdown
   ## Five Whys Analysis

   ### Problem Statement
   ${CLEARLY_DEFINED_PROBLEM}

   ### Why #1: Why did this problem occur?
   **Answer**: ${ANSWER_1}
   **Evidence**: ${EVIDENCE_1}
   **Data Sources**: ${DATA_SOURCES_1}

   ### Why #2: Why did ${ANSWER_1}?
   **Answer**: ${ANSWER_2}
   **Evidence**: ${EVIDENCE_2}
   **Data Sources**: ${DATA_SOURCES_2}

   ### Why #3: Why did ${ANSWER_2}?
   **Answer**: ${ANSWER_3}
   **Evidence**: ${EVIDENCE_3}
   **Data Sources**: ${DATA_SOURCES_3}

   ### Why #4: Why did ${ANSWER_3}?
   **Answer**: ${ANSWER_4}
   **Evidence**: ${EVIDENCE_4}
   **Data Sources**: ${DATA_SOURCES_4}

   ### Why #5: Why did ${ANSWER_4}?
   **Answer**: ${ANSWER_5}
   **Evidence**: ${EVIDENCE_5}
   **Data Sources**: ${DATA_SOURCES_5}

   ### Root Cause Identified
   **Root Cause**: ${ROOT_CAUSE}
   **Confidence Level**: ${CONFIDENCE_LEVEL}
   **Supporting Evidence**: ${SUPPORTING_EVIDENCE}
   ```

3. **Guided Question Templates**

   **Incident Response Template:**
   ```markdown
   ### Why #1: Why did the incident occur?
   Focus on: Immediate trigger, system failure, user action

   ### Why #2: Why was the system vulnerable to this trigger?
   Focus on: Missing safeguards, inadequate monitoring, design flaws

   ### Why #3: Why weren't these vulnerabilities identified earlier?
   Focus on: Testing gaps, monitoring blind spots, review processes

   ### Why #4: Why do these process gaps exist?
   Focus on: Resource constraints, training, priorities, communication

   ### Why #5: Why haven't these systemic issues been addressed?
   Focus on: Organizational culture, leadership, strategy, incentives
   ```

   **Bug Analysis Template:**
   ```markdown
   ### Why #1: Why did this bug occur?
   Focus on: Code logic, data conditions, environment factors

   ### Why #2: Why wasn't this caught during development?
   Focus on: Testing coverage, code review, local testing

   ### Why #3: Why do these quality gaps exist?
   Focus on: Development practices, tooling, time pressures

   ### Why #4: Why aren't quality practices consistently followed?
   Focus on: Training, enforcement, team culture, incentives

   ### Why #5: Why isn't quality prioritized appropriately?
   Focus on: Business priorities, resource allocation, leadership
   ```

   **Performance Issue Template:**
   ```markdown
   ### Why #1: Why is performance degraded?
   Focus on: Resource usage, bottlenecks, load patterns

   ### Why #2: Why are these bottlenecks present?
   Focus on: Architecture decisions, scaling limitations, code efficiency

   ### Why #3: Why weren't these limitations anticipated?
   Focus on: Capacity planning, load testing, monitoring

   ### Why #4: Why are these practices inadequate?
   Focus on: Skills, tools, processes, priorities

   ### Why #5: Why haven't these capabilities been developed?
   Focus on: Investment, strategy, organizational learning
   ```

4. **Evidence Gathering and Validation**
   ```markdown
   ## Evidence Collection Strategy

   ### Technical Evidence Sources
   - System logs and error messages
   - Performance metrics and monitoring data
   - Database query results and analytics
   - Application metrics and dashboards
   - Version control history and recent changes
   - Network connectivity and service status
   - Configuration settings and environment variables

   ### Process Evidence Sources
   - Documentation and procedures
   - Communication records and decisions
   - Timeline of events and actions taken
   - Previous incident reports and patterns
   - Training records and knowledge base
   - Review processes and approval chains
   ```

5. **Data Collection Guidelines**
   ```markdown
   ## Evidence Requirements for Each "Why"

   ### Quantitative Evidence
   - Error rates and frequency
   - Performance metrics
   - System resource utilization
   - User behavior data
   - Timeline of events

   ### Qualitative Evidence
   - User feedback and reports
   - Team observations
   - Process documentation
   - Communication records
   - Decision history

   ### Validation Methods
   - Cross-reference multiple data sources
   - Interview relevant stakeholders
   - Review system documentation
   - Analyze historical patterns
   - Test hypotheses where possible
   ```

6. **Root Cause Categorization**
   ```markdown
   ## Root Cause Categories

   ### Technical Causes
   - **Code Issues**: Logic errors, race conditions, memory leaks
   - **Infrastructure**: Hardware failures, network issues, capacity
   - **Configuration**: Settings, environment variables, deployment
   - **Dependencies**: Third-party services, libraries, APIs

   ### Process Causes
   - **Development**: Code review, testing, deployment processes
   - **Operations**: Monitoring, incident response, maintenance
   - **Communication**: Documentation, knowledge sharing, coordination
   - **Quality Assurance**: Testing practices, standards, validation

   ### Human Causes
   - **Skills**: Knowledge gaps, training needs, experience
   - **Workload**: Time pressure, resource constraints, priorities
   - **Communication**: Unclear requirements, assumptions, handoffs
   - **Decision-Making**: Information availability, authority, timing

   ### Organizational Causes
   - **Culture**: Risk tolerance, learning orientation, blame culture
   - **Structure**: Team organization, responsibilities, accountability
   - **Strategy**: Priorities, investment, long-term planning
   - **Incentives**: Performance metrics, rewards, consequences
   ```

7. **Systematic Analysis Process**
   ```markdown
   ## Analysis Methodology

   ### Information Gathering Phase
   1. **Stakeholder Perspectives**
      - Problem reporter viewpoint
      - System owner/maintainer insights
      - Subject matter expert knowledge
      - Recent contributor context

   2. **Evidence Collection**
      - Problem description and scope
      - Timeline of events and triggers
      - Relevant data sources and logs
      - System documentation and specifications

   ### Analysis Execution

   #### Phase 1: Initial Assessment
   - Generate multiple potential "why" answers for each level
   - Consider different perspectives and viewpoints
   - Avoid premature convergence on single explanations

   #### Phase 2: Evidence-Based Validation
   - Cross-reference answers with available data
   - Identify conflicting information or gaps
   - Seek additional evidence where needed

   #### Phase 3: Pattern Recognition
   - Look for common themes across answers
   - Identify systemic vs. isolated causes
   - Consider historical patterns and precedents

   #### Phase 4: Root Cause Synthesis
   - Converge on most supported explanations
   - Document alternative theories and uncertainties
   - Plan validation and follow-up actions
   ```

8. **Action Planning and Follow-up**
   ```markdown
   ## Corrective Actions

   ### Immediate Actions (24-48 hours)
   - **Action**: ${IMMEDIATE_ACTION_1}
   - **Owner**: ${OWNER_1}
   - **Due Date**: ${DUE_DATE_1}
   - **Success Criteria**: ${SUCCESS_CRITERIA_1}

   ### Short-term Actions (1-4 weeks)
   - **Action**: ${SHORT_TERM_ACTION_1}
   - **Owner**: ${OWNER_2}
   - **Due Date**: ${DUE_DATE_2}
   - **Success Criteria**: ${SUCCESS_CRITERIA_2}

   ### Long-term Actions (1-6 months)
   - **Action**: ${LONG_TERM_ACTION_1}
   - **Owner**: ${OWNER_3}
   - **Due Date**: ${DUE_DATE_3}
   - **Success Criteria**: ${SUCCESS_CRITERIA_3}

   ### Preventive Measures
   - **Detection**: How will we catch this earlier?
   - **Prevention**: How will we prevent recurrence?
   - **Monitoring**: What metrics will we track?
   - **Validation**: How will we verify effectiveness?
   ```

9. **Quality Assurance and Validation**
   ```markdown
   ## Analysis Quality Checklist

   ### Completeness
   - [ ] Problem clearly defined and scoped
   - [ ] Each "why" has supporting evidence
   - [ ] Root cause addresses the original problem
   - [ ] Action plan covers all identified causes

   ### Accuracy
   - [ ] Evidence is factual and verifiable
   - [ ] Logic chain is coherent and connected
   - [ ] Assumptions are explicitly stated
   - [ ] Alternative explanations considered

   ### Actionability
   - [ ] Root cause is within organization's control
   - [ ] Actions are specific and measurable
   - [ ] Owners and timelines assigned
   - [ ] Success criteria defined

   ### Learning
   - [ ] Insights documented for future reference
   - [ ] Process improvements identified
   - [ ] Knowledge gaps highlighted
   - [ ] Follow-up plan established
   ```

10. **Output Formats and Integration**

    **JSON Format for Automation:**
    ```json
    {
      "analysis": {
        "problem": "string",
        "timestamp": "ISO 8601",
        "severity": "low|medium|high|critical",
        "whys": [
          {
            "level": 1,
            "question": "string",
            "answer": "string",
            "evidence": ["string"],
            "confidence": "low|medium|high"
          }
        ],
        "root_cause": "string",
        "categories": ["technical", "process", "human", "organizational"],
        "actions": [
          {
            "type": "immediate|short_term|long_term",
            "description": "string",
            "owner": "string",
            "due_date": "ISO 8601",
            "priority": "high|medium|low"
          }
        ]
      }
    }
    ```

    **Integration with Issue Tracking:**
    ```markdown
    ### Issue Tracking Integration

    #### GitHub Integration
    - Create issue with Five Whys analysis as body
    - Tag with "root-cause-analysis" label
    - Assign to responsible owner
    - Link to related issues and PRs

    #### Project Management Integration
    - Create tickets for identified action items
    - Set priorities based on impact and effort
    - Track progress on corrective measures
    - Schedule follow-up reviews

    #### Documentation Integration
    - Add analysis to incident management records
    - Update knowledge base with learnings
    - Create or update runbooks and procedures
    - Share insights across teams
    ```

11. **Common Pitfalls and Best Practices**
    ```markdown
    ## Common Pitfalls to Avoid

    ### Stopping Too Early
    - Don't stop at the first plausible explanation
    - Continue until you reach systemic causes
    - Look for patterns across similar incidents

    ### Blame and Finger-Pointing
    - Focus on system failures, not individual blame
    - Use "why did the system allow..." instead of "why did person X..."
    - Create psychological safety for honest discussion

    ### Superficial Analysis
    - Require evidence for each "why" answer
    - Dig deeper than obvious explanations
    - Challenge assumptions and conventional wisdom

    ### Single-Factor Thinking
    - Consider multiple contributing factors
    - Acknowledge complex causation
    - Don't force a single root cause narrative

    ## Best Practices

    ### Before Analysis
    - Define the problem clearly and specifically
    - Gather relevant stakeholders and experts
    - Collect initial evidence and data
    - Set expectations for honest, blame-free discussion

    ### During Analysis
    - Ask "why" questions that build on each other
    - Require evidence for each answer
    - Consider alternative explanations
    - Document assumptions and uncertainties

    ### After Analysis
    - Validate findings with additional evidence
    - Create actionable improvement plans
    - Share learnings across the organization
    - Schedule follow-up reviews
    ```

12. **Templates for Different Domains**

    **User Experience Issues:**
    ```markdown
    ### Why #1: Why are users experiencing this problem?
    ### Why #2: Why does the system behave this way?
    ### Why #3: Why wasn't this user need considered?
    ### Why #4: Why don't we have better user feedback?
    ### Why #5: Why isn't user-centered design prioritized?
    ```

    **Security Incidents:**
    ```markdown
    ### Why #1: Why was the security breach successful?
    ### Why #2: Why were these vulnerabilities present?
    ### Why #3: Why weren't they detected earlier?
    ### Why #4: Why are security practices inadequate?
    ### Why #5: Why isn't security built into our culture?
    ```

    **Business Process Issues:**
    ```markdown
    ### Why #1: Why did the process fail?
    ### Why #2: Why aren't controls effective?
    ### Why #3: Why wasn't this risk identified?
    ### Why #4: Why don't we have better risk management?
    ### Why #5: Why isn't continuous improvement prioritized?
    ```

## Usage Examples

```bash
# Basic Five Whys analysis
/five-whys "Database connection timeouts causing user login failures"

# Use specific template
/five-whys --template incident "Production outage lasted 2 hours"

# Collaborative session
/five-whys --collaborative --output team-analysis.md "API response times degraded"

# Extended analysis with more depth
/five-whys --depth 7 --include-actions "Customer complaints about checkout process"

# High severity incident with comprehensive output
/five-whys --severity critical --format json --output incident-analysis.json "Payment processing completely down"

# Bug analysis template
/five-whys --template bug "Memory leak in background worker process"
```

**Analysis Guidelines:**
- Start with a clear, specific problem statement
- Use evidence to support each "why" answer
- Avoid blame and focus on system improvements
- Continue until you reach actionable root causes
- Create concrete follow-up plans
- Share learnings across the organization
- Review and validate the analysis periodically
