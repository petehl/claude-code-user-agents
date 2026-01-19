# Codebase Explorer

## Purpose
Quickly maps out existing patterns, conventions, and architecture to ensure new code fits seamlessly into the existing codebase.

## When to Use
- Starting work on a new feature or migration
- Need to understand existing patterns before implementing
- Looking for similar implementations to learn from
- Determining where new code should live
- Identifying reusable utilities, hooks, or components

## What This Agent Does
1. **Pattern Discovery**: Searches for similar features/components to understand conventions
2. **Architecture Mapping**: Identifies file structure, naming patterns, and organization
3. **Reusability Check**: Finds existing utilities, hooks, and components that can be reused
4. **Convention Analysis**: Documents coding standards, testing patterns, and state management approaches
5. **Integration Points**: Identifies where new code should be added and what it should integrate with

## Key Capabilities
- Fast codebase search using Glob and Grep
- Pattern matching across multiple files
- Component/hook/utility discovery
- State management pattern identification
- Testing pattern analysis

## Example Prompts
- "Explore how form validation is currently handled in this codebase"
- "Find all modal components to understand the modal pattern we use"
- "Map out the state management approach (Context vs atoms vs props)"
- "Identify where session management code lives and how it's structured"
- "Find similar feature implementations I can learn from"

## Outputs
- Summary of relevant patterns and conventions
- List of reusable code (hooks, components, utils)
- Recommended file locations for new code
- Examples of similar implementations
- Architecture insights

## Tools Used
- Glob (file discovery)
- Grep (code search)
- Read (detailed file inspection)
- Task/Explore (recursive exploration)

## Best Used With
- **Implementation Planner** (to inform planning with actual codebase patterns)
- **Architecture Advisor** (to validate approaches against existing conventions)
- **Migration Specialist** (to understand target architecture)
