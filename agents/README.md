# Agent Library - Quick Reference

This directory contains 11 specialized agents to accelerate React/TypeScript development workflows.

## How to Use These Agents

Simply reference the agent by name when asking Claude to help with tasks:

```
"Scout, find all modal implementations"
"Atlas, create a plan for adding dark mode"
"Hawk, review my changes"
"Flint, tear this code apart and find everything wrong"
```

## 👥 Meet Your Team

| Name | Role | Personality |
|------|------|-------------|
| **Scout** | Codebase Explorer | Discovers patterns and territory |
| **Atlas** | Implementation Planner | Maps the path forward |
| **Sage** | Architecture Advisor | Wise technical counsel |
| **Ace** | React/TypeScript Expert | Top-tier implementation |
| **Jasper** | Test Engineer | Thorough and solid |
| **Porter** | Migration Specialist | Carries code between worlds |
| **Reed** | Refactoring Engineer | Flexible code shaper |
| **Hawk** | Pull Request Reviewer | Sharp-eyed balanced reviewer |
| **Flint** | Harsh Critic | Uncompromising quality enforcer |
| **Dash** | Performance Optimizer | Speed demon |
| **Forge** | Build & Tooling Specialist | Infrastructure builder |

---

## 📋 Planning Agents (Run First)

### Scout - Codebase Explorer
**Use when**: Starting new work, need to understand existing patterns
**Best for**: Finding similar code, understanding conventions, locating where code should live
```
"Scout, find how we handle forms in this codebase"
```

### Atlas - Implementation Planner
**Use when**: Complex features, need a roadmap before coding
**Best for**: Breaking down work, identifying risks, creating step-by-step plans
```
"Atlas, design a plan for the user settings feature"
```

### Sage - Architecture Advisor
**Use when**: Choosing between multiple technical approaches
**Best for**: Evaluating trade-offs, recommending patterns, validating decisions
```
"Sage, should I use Context or Jotai for this state?"
```

---

## 🛠️ Implementation Agents (Do the Work)

### Ace - React/TypeScript Expert
**Use when**: Building features, implementing components
**Best for**: High-quality code, proper typing, best practices
```
"Ace, implement the UserProfile component"
```

### Jasper - Test Engineer
**Use when**: After implementing features, need test coverage
**Best for**: Unit tests, integration tests, e2e tests, mocks
```
"Jasper, add tests for the authentication flow"
```

### Porter - Migration Specialist
**Use when**: Moving code from another codebase, upgrading patterns
**Best for**: Safe migrations, pattern conversions, preserving functionality
```
"Porter, migrate the PaymentFlow from the legacy app"
```

### Reed - Refactoring Engineer
**Use when**: Code works but is messy, duplicated, or complex
**Best for**: Cleanup, extraction, simplification without breaking behavior
```
"Reed, simplify this 400-line component"
```

---

## ✅ Quality & Optimization Agents

### Hawk - Pull Request Reviewer (Balanced)
**Use when**: Normal PR reviews, constructive feedback
**Best for**: Security audit, best practices validation, test coverage check
```
"Hawk, review my changes for security issues"
```

### Flint - Harsh Critic (Uncompromising)
**Use when**: Critical features, need brutal honesty, self-challenge
**Best for**: Finding every flaw, questioning every decision, zero tolerance
```
"Flint, tear this code apart and tell me everything wrong with it"
```

**Hawk vs Flint:**
- **Hawk** = Balanced, constructive, professional (everyday use)
- **Flint** = Harsh, skeptical, uncompromising (critical code, major releases)

### Dash - Performance Optimizer
**Use when**: App is slow, bundles are large, renders are expensive
**Best for**: Profiling, optimization, code splitting, lazy loading
```
"Dash, fix slow renders on the dashboard"
```

### Forge - Build & Tooling Specialist
**Use when**: Configuring tools, slow builds, CI/CD setup
**Best for**: Vite/Webpack config, TypeScript setup, linting, CI/CD
```
"Forge, optimize our Vite build configuration"
```

---

## 🔄 Common Workflows

### New Feature Development
1. **Scout** → understand existing patterns
2. **Atlas** → create detailed plan
3. **Sage** → validate approach (if needed)
4. **Ace** → implement feature
5. **Jasper** → add test coverage
6. **Hawk** → balanced review before merge
7. **Flint** → harsh critique for critical features (optional)

### Feature Migration
1. **Scout** → understand both old and new codebases
2. **Porter** → plan and execute migration
3. **Jasper** → validate migrated functionality
4. **Hawk** → ensure quality

### Performance Issues
1. **Dash** → profile and identify bottlenecks
2. **Ace** → implement optimizations
3. **Jasper** → ensure no regressions
4. **Hawk** → validate changes

### Code Cleanup
1. **Scout** → find patterns and duplication
2. **Reed** → clean up code structure
3. **Jasper** → ensure behavior unchanged
4. **Hawk** → validate refactoring safety

### Critical Release / Major Feature
1. **Scout** + **Atlas** → understand and plan
2. **Sage** → validate architecture
3. **Ace** → implement with excellence
4. **Jasper** → comprehensive test coverage
5. **Hawk** → initial review
6. **Flint** → brutal final critique before release

---

## 💡 Pro Tips

- **Run planning agents first** - Understanding patterns and creating plans saves time
- **Combine agents** - "Use Codebase Explorer and then Implementation Planner to..."
- **Be specific** - Reference exact files, features, or problems for better results
- **Iterative approach** - Break large tasks into smaller agent-specific chunks
- **Quality gates** - Always end with Test Engineer and Pull Request Reviewer

---

## 📚 Agent Pairing Recommendations

| Primary Agent | Works Best With |
|--------------|-----------------|
| Atlas (Planner) | Scout, Sage |
| Ace (Expert) | Jasper, Hawk |
| Porter (Migration) | Scout, Jasper |
| Reed (Refactoring) | Jasper, Hawk |
| Dash (Performance) | Hawk, Forge |
| Flint (Harsh Critic) | Jasper, Ace, Reed |
