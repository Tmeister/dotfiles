# Investigation and Research Command

Conduct thorough investigation of a topic, technology, or approach using codebase analysis and web research to determine optimal solutions with up-to-date information.

## Instructions

Investigate and provide comprehensive analysis on: **$ARGUMENTS**

**Flags:**
- `--depth <level>`: Investigation depth - `surface`, `standard` (default), `comprehensive`
- `--focus <area>`: Focus area - `technical`, `business`, `security`, `performance`, `all` (default)
- `--timeframe <period>`: Research timeframe - `recent` (6 months), `current` (1 year, default), `historical` (all time)
- `--format <format>`: Output format - `markdown` (default), `json`, `summary`
- `--include-code`: Include code examples and implementation details
- `--output <file>`: Save investigation to file (optional)

1. **Investigation Scope and Context Analysis**
   ```markdown
   ## Investigation Parameters
   
   **Topic**: ${INVESTIGATION_TOPIC}
   **Scope**: ${SCOPE_DEFINITION}
   **Focus Areas**: ${FOCUS_AREAS}
   **Target Audience**: ${AUDIENCE}
   **Decision Timeline**: ${TIMELINE}
   
   ### Key Questions to Answer
   - ${QUESTION_1}
   - ${QUESTION_2}
   - ${QUESTION_3}
   
   ### Success Criteria
   - ${SUCCESS_CRITERION_1}
   - ${SUCCESS_CRITERION_2}
   - ${SUCCESS_CRITERION_3}
   ```

2. **Codebase Analysis Phase**
   ```markdown
   ## Current State Analysis
   
   ### Existing Implementation Scan
   - Search for relevant patterns and implementations
   - Identify current approaches and technologies
   - Document existing solutions and their effectiveness
   - Analyze architectural decisions and trade-offs
   
   ### Technology Stack Assessment
   - Catalog current dependencies and versions
   - Evaluate compatibility requirements
   - Identify potential migration challenges
   - Document performance baselines
   
   ### Code Quality Evaluation
   - Review test coverage for related functionality
   - Analyze documentation completeness
   - Identify technical debt areas
   - Assess maintainability factors
   ```

3. **Web Research and Information Gathering**
   ```markdown
   ## External Research Phase
   
   ### Industry Standards and Best Practices
   - Research current industry standards and practices
   - Identify emerging trends and patterns
   - Review official documentation and specifications
   - Analyze vendor recommendations and guidance
   
   ### Technology Comparison and Evaluation
   - Compare alternative solutions and approaches
   - Review benchmarks and performance studies
   - Analyze feature matrices and capabilities
   - Evaluate licensing and cost implications
   
   ### Community Insights and Adoption
   - Review community discussions and feedback
   - Analyze adoption patterns and trends
   - Identify common pitfalls and challenges
   - Collect expert opinions and recommendations
   ```

4. **Comprehensive Analysis Framework**
   ```markdown
   ## Multi-Dimensional Evaluation
   
   ### Technical Assessment
   #### Performance Characteristics
   - Throughput and latency metrics
   - Resource utilization patterns
   - Scalability limitations and capabilities
   - Reliability and fault tolerance
   
   #### Integration Considerations
   - Compatibility with existing systems
   - API design and extensibility
   - Deployment and operational requirements
   - Monitoring and observability features
   
   #### Security Implications
   - Security model and threat mitigation
   - Compliance and regulatory considerations
   - Audit trail and logging capabilities
   - Access control and authentication methods
   
   ### Business Impact Analysis
   #### Cost-Benefit Evaluation
   - Implementation and maintenance costs
   - Training and skill development requirements
   - Time-to-market implications
   - Return on investment projections
   
   #### Risk Assessment
   - Technical risks and mitigation strategies
   - Business continuity considerations
   - Vendor lock-in and exit strategies
   - Future-proofing and longevity factors
   
   #### Strategic Alignment
   - Alignment with business objectives
   - Impact on competitive positioning
   - Scalability for future growth
   - Innovation and differentiation potential
   ```

5. **Options Analysis and Comparison**
   ```markdown
   ## Solution Options Evaluation
   
   ### Option 1: ${OPTION_1_NAME}
   
   #### Overview
   ${OPTION_1_DESCRIPTION}
   
   #### Strengths
   - ${STRENGTH_1}
   - ${STRENGTH_2}
   - ${STRENGTH_3}
   
   #### Weaknesses
   - ${WEAKNESS_1}
   - ${WEAKNESS_2}
   - ${WEAKNESS_3}
   
   #### Implementation Complexity
   **Effort Level**: ${EFFORT_LEVEL}
   **Timeline**: ${IMPLEMENTATION_TIMELINE}
   **Prerequisites**: ${PREREQUISITES}
   
   #### Real-World Evidence
   - **Adoption**: ${ADOPTION_METRICS}
   - **Case Studies**: ${CASE_STUDIES}
   - **Performance Data**: ${PERFORMANCE_DATA}
   
   ### Option 2: ${OPTION_2_NAME}
   [Similar structure for each option]
   
   ### Comparison Matrix
   | Criteria | Option 1 | Option 2 | Option 3 |
   |----------|----------|----------|----------|
   | Performance | ${SCORE_1} | ${SCORE_2} | ${SCORE_3} |
   | Complexity | ${SCORE_1} | ${SCORE_2} | ${SCORE_3} |
   | Cost | ${SCORE_1} | ${SCORE_2} | ${SCORE_3} |
   | Maturity | ${SCORE_1} | ${SCORE_2} | ${SCORE_3} |
   | Community | ${SCORE_1} | ${SCORE_2} | ${SCORE_3} |
   ```

6. **Evidence-Based Recommendation**
   ```markdown
   ## Executive Summary and Recommendation
   
   ### Key Findings
   - ${KEY_FINDING_1}
   - ${KEY_FINDING_2}
   - ${KEY_FINDING_3}
   
   ### Recommended Solution: ${RECOMMENDED_SOLUTION}
   
   #### Rationale
   1. **${REASON_1}**: ${DETAILED_EXPLANATION_1}
   2. **${REASON_2}**: ${DETAILED_EXPLANATION_2}
   3. **${REASON_3}**: ${DETAILED_EXPLANATION_3}
   
   #### Supporting Evidence
   - **Performance**: ${PERFORMANCE_EVIDENCE}
   - **Reliability**: ${RELIABILITY_EVIDENCE}
   - **Community**: ${COMMUNITY_EVIDENCE}
   - **Strategic Fit**: ${STRATEGIC_EVIDENCE}
   
   #### Confidence Level: ${CONFIDENCE_LEVEL}
   **Basis**: ${CONFIDENCE_BASIS}
   ```

7. **Implementation Strategy and Migration Path**
   ```markdown
   ## Implementation Roadmap
   
   ### Phase 1: Preparation and Planning (${PHASE_1_DURATION})
   #### Objectives
   - ${PHASE_1_OBJECTIVE_1}
   - ${PHASE_1_OBJECTIVE_2}
   
   #### Key Activities
   - ${PHASE_1_ACTIVITY_1}
   - ${PHASE_1_ACTIVITY_2}
   
   #### Deliverables
   - ${PHASE_1_DELIVERABLE_1}
   - ${PHASE_1_DELIVERABLE_2}
   
   ### Phase 2: Pilot Implementation (${PHASE_2_DURATION})
   #### Objectives
   - ${PHASE_2_OBJECTIVE_1}
   - ${PHASE_2_OBJECTIVE_2}
   
   #### Success Metrics
   - ${METRIC_1}: ${TARGET_1}
   - ${METRIC_2}: ${TARGET_2}
   
   ### Phase 3: Full Deployment (${PHASE_3_DURATION})
   #### Rollout Strategy
   - ${ROLLOUT_APPROACH}
   - ${ROLLBACK_PLAN}
   
   #### Training and Documentation
   - ${TRAINING_PLAN}
   - ${DOCUMENTATION_REQUIREMENTS}
   ```

8. **Risk Analysis and Mitigation**
   ```markdown
   ## Risk Assessment and Mitigation
   
   ### High-Risk Factors
   #### Risk: ${HIGH_RISK_1}
   - **Probability**: ${PROBABILITY_1}
   - **Impact**: ${IMPACT_1}
   - **Mitigation**: ${MITIGATION_1}
   - **Contingency**: ${CONTINGENCY_1}
   
   ### Medium-Risk Factors
   #### Risk: ${MEDIUM_RISK_1}
   - **Probability**: ${PROBABILITY_2}
   - **Impact**: ${IMPACT_2}
   - **Mitigation**: ${MITIGATION_2}
   
   ### Risk Monitoring
   - **Early Warning Indicators**: ${WARNING_INDICATORS}
   - **Review Frequency**: ${REVIEW_FREQUENCY}
   - **Escalation Criteria**: ${ESCALATION_CRITERIA}
   ```

9. **Quality Assurance and Validation**
   ```markdown
   ## Investigation Quality Framework
   
   ### Information Source Validation
   - **Primary Sources**: Official documentation, specifications, research papers
   - **Secondary Sources**: Industry analyses, expert opinions, case studies
   - **Community Sources**: Forums, discussions, user experiences
   - **Verification**: Cross-reference multiple sources, fact-checking
   
   ### Bias and Limitation Assessment
   - **Vendor Bias**: Identified vendor-sponsored content
   - **Recency Bias**: Balanced recent vs. historical information
   - **Selection Bias**: Comprehensive option coverage
   - **Confirmation Bias**: Challenged preconceptions
   
   ### Evidence Quality Levels
   - **High Confidence**: Multiple authoritative sources, empirical data
   - **Medium Confidence**: Limited sources, theoretical analysis
   - **Low Confidence**: Single source, anecdotal evidence
   - **Uncertain**: Conflicting information, insufficient data
   ```

10. **Future Considerations and Monitoring**
    ```markdown
    ## Long-Term Strategy and Monitoring
    
    ### Technology Evolution Tracking
    - **Roadmap Monitoring**: Track vendor roadmaps and development plans
    - **Community Trends**: Monitor adoption patterns and community health
    - **Competitive Landscape**: Watch for new entrants and innovations
    - **Standards Evolution**: Track relevant industry standards
    
    ### Decision Review Framework
    - **Review Triggers**: Performance degradation, new alternatives, business changes
    - **Review Frequency**: Quarterly assessments, annual comprehensive review
    - **Success Metrics**: KPIs to track solution effectiveness
    - **Exit Criteria**: Conditions that would trigger solution change
    
    ### Continuous Improvement
    - **Feedback Loops**: User feedback, performance monitoring, lessons learned
    - **Optimization Opportunities**: Configuration tuning, feature adoption
    - **Skill Development**: Training needs, knowledge gaps, expertise building
    ```

11. **Specialized Investigation Templates**

    **Technology Adoption Template:**
    ```markdown
    ### Technology Maturity Assessment
    - **Development Stage**: Alpha, Beta, Stable, Mature, Legacy
    - **Community Size**: Active contributors, user base, ecosystem
    - **Corporate Support**: Vendor backing, commercial offerings
    - **Documentation Quality**: Completeness, accuracy, examples
    
    ### Integration Analysis
    - **Compatibility**: Version requirements, dependency conflicts
    - **Migration Path**: Upgrade strategy, data migration, rollback
    - **Operational Impact**: Deployment changes, monitoring requirements
    ```

    **Security Investigation Template:**
    ```markdown
    ### Security Posture Evaluation
    - **Threat Model**: Attack vectors, vulnerability assessment
    - **Compliance**: Regulatory requirements, industry standards
    - **Audit Trail**: Logging, monitoring, forensic capabilities
    - **Access Control**: Authentication, authorization, privilege management
    
    ### Security Implementation
    - **Best Practices**: Secure configuration, hardening guidelines
    - **Monitoring**: Security event detection, incident response
    - **Validation**: Security testing, penetration testing, code review
    ```

    **Performance Investigation Template:**
    ```markdown
    ### Performance Characteristics
    - **Baseline Metrics**: Current performance measurements
    - **Benchmark Comparisons**: Industry standards, competitive analysis
    - **Scaling Patterns**: Linear, exponential, plateau characteristics
    - **Resource Requirements**: CPU, memory, storage, network
    
    ### Optimization Opportunities
    - **Configuration Tuning**: Parameter optimization, caching strategies
    - **Architecture Improvements**: Design patterns, infrastructure changes
    - **Monitoring Strategy**: Performance metrics, alerting thresholds
    ```

## Usage Examples

```bash
# General technology investigation
/investigate "What's the best approach for real-time data processing in our microservices architecture?"

# Security-focused investigation
/investigate --focus security "Should we implement OAuth 2.1 or stick with our current JWT approach?"

# Performance-specific research
/investigate --focus performance --include-code "How can we optimize our database query performance?"

# Comprehensive business and technical analysis
/investigate --depth comprehensive "Evaluate migrating from REST to GraphQL for our API layer"

# Recent trends and emerging technologies
/investigate --timeframe recent "What are the latest trends in containerization and orchestration?"

# Quick surface-level overview
/investigate --depth surface --format summary "Compare Redis vs Memcached for caching"
```

**Investigation Quality Standards:**
- Prioritize authoritative and recent sources
- Provide balanced analysis with multiple perspectives
- Include concrete evidence and real-world examples
- Acknowledge uncertainties and limitations
- Focus on actionable recommendations
- Consider both technical and business implications
- Validate claims through multiple sources