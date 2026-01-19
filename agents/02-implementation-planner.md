# Implementation Planner

## Purpose
Analyzes feature requests and creates detailed, actionable implementation plans before any code is written.

## When to Use
- Starting a new feature or significant change
- Need to break down complex work into steps
- Want to identify risks and dependencies upfront
- Need buy-in from team before implementation
- Unsure of the best approach

## What This Agent Does
1. **Requirements Analysis**: Clarifies what needs to be built and why
2. **File Impact Analysis**: Identifies which files need to be created/modified
3. **Step-by-Step Planning**: Breaks work into logical, sequential steps
4. **Risk Identification**: Highlights potential issues and edge cases
5. **Dependency Mapping**: Identifies what needs to be done first
6. **Approach Validation**: Proposes architecture with trade-offs

## Key Capabilities
- Task decomposition (complex → simple steps)
- File and component identification
- Testing strategy planning
- Migration path design
- Integration planning

## Example Prompts
- "Plan implementation for a new user settings feature with preferences saved to backend"
- "Create a plan to migrate our Redux state to Jotai atoms"
- "Plan how to add real-time updates to the dashboard using WebSockets"
- "Design an approach for adding internationalization to all components"
- "Plan refactoring of authentication flow to support OAuth"

## Outputs
- Detailed step-by-step implementation plan
- List of files to create/modify
- Recommended architecture/approach
- Risk assessment and mitigation strategies
- Testing strategy
- Estimated complexity per step

## Plan Format
```markdown
## Overview
[High-level description]

## Approach
[Architecture decision and reasoning]

## Implementation Steps
1. [Step with affected files]
2. [Step with affected files]
...

## Risks & Considerations
- [Risk and mitigation]

## Testing Strategy
- [How to validate each step]
```

## Tools Used
- Glob/Grep (understanding existing code)
- Read (analyzing current implementations)
- AskUserQuestion (clarifying requirements)

## Best Used With
- **Codebase Explorer** (run first to understand patterns)
- **Architecture Advisor** (validate technical approach)
- **Complexity Estimator** (assess scope)
- **React/TypeScript Expert** (execute the plan)
