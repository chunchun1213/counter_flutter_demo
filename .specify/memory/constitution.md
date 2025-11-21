<!--
SYNC IMPACT REPORT
==================
Version Change: 1.0.0 → 1.1.0
Change Type: MINOR (New principle added - Documentation Language)
Modified Principles:
  - All principles translated to English (constitution now English-only per user request)
Added Sections:
  - Principle V: Documentation Language (Traditional Chinese requirement for all project docs)
Removed Sections: N/A
Templates Status:
  ✅ plan-template.md - Updated: Added documentation language check to Constitution Check section
  ✅ spec-template.md - Updated: Added zh-TW language requirement note
  ✅ tasks-template.md - Updated: Added zh-TW language requirement note
  ✅ checklist-template.md - Updated: Added documentation language checklist items (CHK029-CHK036)
  ⚠ agent-file-template.md - No update required: Template is auto-generated at runtime
Follow-up TODOs:
  - Team members MUST write all new specs, plans, and tasks in Traditional Chinese (zh-TW)
  - README.md should be converted to Traditional Chinese per new principle V
  - All future user-facing and technical documentation MUST be in Traditional Chinese
  - Code comments remain in developer's preferred language (not mandated by constitution)
  - Commit messages recommended in English for tool compatibility
Runtime Documents:
  ⚠ README.md - Pending: Should be converted to Traditional Chinese per new principle V
Commit Message: docs: amend constitution to v1.1.0 (add documentation language requirement)
-->

# Counter Flutter Demo Constitution

## Core Principles

### I. Code Quality (NON-NEGOTIABLE)

All code must meet the following quality standards:

- **Readability First**: Code must clearly express intent with meaningful naming and appropriate comments
- **Zero Static Analysis Warnings**: All code must pass `flutter analyze` with no warnings or errors
- **Consistent Formatting**: Use `dart format` for automatic formatting; manual format adjustments are not allowed
- **Dependency Injection**: Avoid hardcoded dependencies; use constructor injection or service locator patterns
- **Single Responsibility Principle**: Each class and function should have one clear responsibility
- **Mandatory Code Review**: All changes must be reviewed by at least one team member

**Rationale**: High-quality code reduces maintenance costs, decreases bug rates, and improves team collaboration efficiency. Consistent quality standards ensure long-term project maintainability.

### II. Testing Standards (NON-NEGOTIABLE)

Testing is the core of quality assurance and must follow these guidelines:

- **Test-First Development**: For new features: write tests (describe expected behavior) → tests fail → implement → tests pass
- **Three-Tier Test Pyramid**:
  - **Unit Tests**: Cover all business logic, utility functions, data models (target coverage ≥80%)
  - **Widget Tests**: Verify widget behavior and state management interactions
  - **Integration Tests**: End-to-end tests for critical user journeys (at minimum, cover all P1 user stories)
- **Tests Must Be Repeatable**: Tests should not depend on external state or execution order
- **Fast Feedback**: Unit test suite must complete execution within 30 seconds
- **Mock External Dependencies**: Network, database, and system APIs must use mocks for testing

**Rationale**: Test-first ensures correct requirement understanding. Automated tests provide confidence for refactoring and adding features while preventing regression errors.

### III. User Experience Consistency

Provide smooth, intuitive, and consistent user experience:

- **Design System Adherence**: Use unified design tokens for colors, typography, spacing, border radius, etc.
- **Platform Conventions**: Follow Material Design (Android) and Human Interface Guidelines (iOS) platform standards
- **Responsive Design**: Interface must adapt to different screen sizes (phone, tablet, desktop)
- **Accessibility Support**: Provide semantic labels (Semantics) to support screen readers and keyboard navigation
- **Immediate Feedback**: User actions must provide instant visual feedback (loading indicators, button state changes, etc.)
- **Friendly Error Handling**: Error messages must be clear, actionable, and avoid technical jargon

**Rationale**: Consistent UX reduces learning curve and increases user satisfaction and retention. Following platform conventions ensures the app feels "native."

### IV. Performance Requirements

Applications must maintain high performance standards:

- **Startup Time**: Cold start <3 seconds, hot start <1 second
- **Smoothness**: Maintain 60 FPS (16.67ms/frame); animations and scrolling must be smooth without jank
- **Memory Usage**: Single-page memory usage <150MB; avoid memory leaks
- **Network Optimization**: Use caching strategies, reduce unnecessary network requests, support offline functionality (where applicable)
- **Bundle Size**: APK/IPA size should be minimized; use code splitting and resource optimization
- **Performance Profiling Tools**: Use DevTools regularly to analyze performance bottlenecks

**Rationale**: Performance directly impacts user experience and app ratings. Even low-end devices should provide acceptable performance.

### V. Documentation Language (NON-NEGOTIABLE)

All project documentation must be written in Traditional Chinese to ensure team alignment and stakeholder accessibility:

- **Specifications (spec.md)**: MUST be written in Traditional Chinese (zh-TW)
- **Implementation Plans (plan.md)**: MUST be written in Traditional Chinese (zh-TW)
- **Task Lists (tasks.md)**: MUST be written in Traditional Chinese (zh-TW)
- **User-Facing Documentation**: README.md, user guides, and external documentation MUST be in Traditional Chinese (zh-TW)
- **Technical Documentation**: Architecture docs, ADRs (Architecture Decision Records), quickstart guides MUST be in Traditional Chinese (zh-TW)
- **Constitution Exception**: This constitution document itself is maintained in English as the authoritative governance reference
- **Code Comments**: Developer's choice (not mandated); use what best serves the team
- **Commit Messages**: Recommended in English for international collaboration tools compatibility

**Rationale**: Standardizing documentation language ensures all team members and stakeholders can effectively understand requirements, plans, and project context. Traditional Chinese is chosen as the primary language for this project's stakeholder base.

## Performance Standards

### Performance Monitoring

- Performance analysis must be conducted before the end of each sprint
- Use Flutter DevTools Timeline and Memory tools for analysis
- Record rendering times and memory usage for critical pages

### Performance Budgets

- **Build Time**: Full build <5 minutes
- **Hot Reload**: <2 seconds
- **List Scrolling**: Maintain 60 FPS even with 1000+ items (use ListView.builder or similar optimizations)
- **Image Loading**: Use caching and appropriate image formats/sizes; avoid large images blocking UI

### Performance Optimization Strategies

- Use `const` constructors to reduce rebuilds
- Implement appropriate `shouldRepaint`/`shouldRebuild` logic
- Avoid expensive computations in build methods
- Use `Isolate` for CPU-intensive tasks

## Development Workflow

### Development Process

1. **Requirement Confirmation**: Verify user stories and acceptance criteria from `spec.md` (in Traditional Chinese)
2. **Plan Review**: Check `plan.md` (in Traditional Chinese) to ensure compliance with constitutional principles
3. **Test First**: Write failing tests for new features
4. **Implementation**: Implement features to make tests pass
5. **Code Review**: Submit PR, pass review and all checks
6. **Integration**: Merge to main branch, trigger CI/CD

### Quality Gates

All Pull Requests must pass:

- ✅ `dart analyze` with no errors or warnings
- ✅ `dart format --set-exit-if-changed .` formatting check passes
- ✅ All tests pass (unit, widget, integration)
- ✅ Test coverage meets standards (≥80% for new code)
- ✅ At least one reviewer approval
- ✅ Performance metrics show no regression (critical pages)
- ✅ Documentation in Traditional Chinese (spec.md, plan.md, user-facing docs)

### Branching Strategy

- **main**: Stable production code, protected branch
- **feature/###-feature-name**: Feature development branches, created from main
- **hotfix/###-description**: Emergency fix branches

### Continuous Integration

- Automatically run code analysis, format checks, and tests
- Automatically build preview versions for testing
- Failed builds prevent merging

## Governance

This constitution is the supreme governing principle of the project; all development practices must comply:

- **Constitutional Priority**: When practices conflict with the constitution, the constitution takes precedence
- **Amendment Procedure**: Constitutional amendments require team consensus and documented rationale, including impact analysis of changes
- **Version Control**: Use semantic versioning (MAJOR.MINOR.PATCH)
  - MAJOR: Removal or redefinition of core principles (backward incompatible)
  - MINOR: Addition of new principles or material expansions
  - PATCH: Clarifications, wording improvements, minor corrections
- **Compliance Review**: Code reviews must verify compliance with constitutional principles
- **Exception Handling**: Any deviation from the constitution must be justified in the "Complexity Tracking" table in `plan.md`
- **Runtime Guidance**: Team members should refer to `.specify/templates/agent-file-template.md` for the latest development guidance

**Version**: 1.1.0 | **Ratified**: 2025-11-21 | **Last Amended**: 2025-11-21
