# Contributing to Simple Shell

Thank you for your interest in contributing to Simple Shell! This document provides guidelines and instructions for contributing.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Setup](#development-setup)
4. [Coding Standards](#coding-standards)
5. [Making Changes](#making-changes)
6. [Testing](#testing)
7. [Submitting Changes](#submitting-changes)
8. [Review Process](#review-process)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Expected Behavior

- Be respectful and considerate
- Welcome newcomers and help them learn
- Focus on what is best for the project
- Show empathy towards other contributors

### Unacceptable Behavior

- Harassment, discrimination, or exclusionary behavior
- Trolling, insulting comments, or personal attacks
- Publishing others' private information
- Any conduct that could be considered inappropriate

## Getting Started

### Prerequisites

- Familiarity with C programming
- Understanding of UNIX/Linux systems
- Git version control knowledge
- GCC compiler installed

### Find an Issue

1. Check the [GitHub Issues](https://github.com/eodenyire/simple_shell/issues)
2. Look for issues labeled `good first issue` or `help wanted`
3. Comment on the issue to express interest
4. Wait for assignment before starting work

### First Contribution

New to open source? Here are good first contributions:

- Fix typos in documentation
- Improve code comments
- Add test cases
- Update README examples
- Fix simple bugs

## Development Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/simple_shell.git
cd simple_shell

# Add upstream remote
git remote add upstream https://github.com/eodenyire/simple_shell.git
```

### 2. Create a Branch

```bash
# Update your main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
```

### 3. Build and Test

```bash
# Compile the shell
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh

# Run tests
./test_shell.sh
./test_advanced.sh
./check_style.sh
```

## Coding Standards

### Betty Style Guide

This project follows the Betty style guide for C code.

**Key Rules:**
- Maximum 80 characters per line
- Maximum 40 lines per function
- Maximum 5 functions per file
- Use tabs for indentation (width 8)
- Add space after keywords (if, while, for, etc.)
- Braces on the same line for functions and control structures

**Example:**
```c
/**
 * my_function - Description of function
 * @param1: Description of param1
 * @param2: Description of param2
 *
 * Return: Description of return value
 */
int my_function(int param1, char *param2)
{
	int result;

	if (param1 < 0)
		return (-1);

	result = param1 + _strlen(param2);
	return (result);
}
```

### Function Documentation

Every function must have a header comment:

```c
/**
 * function_name - Brief description (one line)
 * @parameter1: Description of parameter1
 * @parameter2: Description of parameter2
 *
 * Extended description if needed.
 * Can span multiple lines.
 *
 * Return: Description of return value
 */
```

### File Headers

Each file should start with:

```c
#include "main.h"

/* File-level documentation if needed */
```

### Variable Naming

- Use descriptive names: `counter`, not `c`
- Use lowercase with underscores: `my_variable`
- Constants in UPPERCASE: `MAX_BUFFER_SIZE`
- Global variables: Prefix with `g_` (avoid when possible)

### Error Handling

Always check return values:

```c
/* Bad */
malloc(size);

/* Good */
ptr = malloc(size);
if (ptr == NULL)
{
	perror("malloc");
	return (-1);
}
```

## Making Changes

### Commit Messages

Write clear, descriptive commit messages:

**Format:**
```
Short summary (50 chars or less)

Detailed explanation if needed. Wrap at 72 characters.
Explain what and why, not how.

- Bullet points are fine
- Multiple paragraphs are okay

Fixes #123
```

**Good Examples:**
```
Fix memory leak in cmd_exec child process

Add free(dir) before exit in child process to prevent
memory leak when execve fails.

Fixes #45
```

```
Add support for cd builtin with no arguments

When cd is called without arguments, now changes to
HOME directory as expected by POSIX.
```

**Bad Examples:**
```
fix bug
```

```
Updated files
```

### Code Changes

1. **Keep changes focused**: One feature or fix per PR
2. **Write tests**: Add tests for new features
3. **Update documentation**: Update relevant docs
4. **Check style**: Run `./check_style.sh`
5. **No warnings**: Code must compile with `-Werror`

### Adding New Features

Before adding a major feature:

1. Open an issue to discuss the feature
2. Get maintainer approval
3. Follow the design principles:
   - Keep it simple
   - Follow POSIX standards when possible
   - Maintain backward compatibility
   - Don't break existing tests

## Testing

### Running Tests

```bash
# All tests must pass
./test_shell.sh       # Basic tests
./test_advanced.sh    # Advanced tests
./check_style.sh      # Style check

# Memory leak check
echo "ls" | valgrind --leak-check=full ./hsh
```

### Writing Tests

Add tests to `test_shell.sh` or `test_advanced.sh`:

```bash
# Example test
echo -n "Testing: Your feature... "
output=$(echo "your_command" | ./hsh 2>&1)
if echo "$output" | grep -q "expected_result"; then
    echo -e "${GREEN}PASSED${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAILED${NC}"
    ((FAILED++))
fi
```

### Test Requirements

- All tests must pass before submitting PR
- Add tests for bug fixes to prevent regressions
- Test edge cases and error conditions
- Verify no memory leaks with valgrind

## Submitting Changes

### Before Submitting

**Checklist:**
- [ ] Code compiles without warnings
- [ ] All tests pass
- [ ] No memory leaks
- [ ] Code follows Betty style
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] Branch is up to date with main

### Push Your Changes

```bash
# Make sure you're on your feature branch
git checkout feature/your-feature-name

# Push to your fork
git push origin feature/your-feature-name
```

### Create Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select your feature branch
4. Fill in the PR template:
   - **Title**: Clear, descriptive title
   - **Description**: What, why, and how
   - **Related Issues**: Link related issues
   - **Testing**: Describe testing done
   - **Screenshots**: If applicable

**PR Template:**
```markdown
## Description
Brief description of the changes

## Related Issue
Fixes #123

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing Done
- Test 1
- Test 2
- Memory leak check

## Checklist
- [x] Code compiles without warnings
- [x] All tests pass
- [x] Betty style compliant
- [x] Documentation updated
```

## Review Process

### What to Expect

1. **Automated Checks**: CI/CD runs tests automatically
2. **Code Review**: Maintainers review your code
3. **Feedback**: You may receive change requests
4. **Iteration**: Make requested changes
5. **Approval**: Once approved, code is merged

### Responding to Feedback

- Be receptive to feedback
- Ask questions if unclear
- Make requested changes promptly
- Push updates to the same branch
- Don't force-push after review starts

### If Changes Are Requested

```bash
# Make the changes
# Commit them
git add .
git commit -m "Address review feedback"

# Push to update the PR
git push origin feature/your-feature-name
```

## Types of Contributions

### Documentation

- Improve README
- Fix typos
- Add examples
- Translate documentation
- Write tutorials

### Bug Fixes

- Fix compilation warnings
- Fix memory leaks
- Fix crashes
- Fix incorrect behavior

### Features

- Add new built-in commands
- Improve error messages
- Add new options
- Enhance performance

### Tests

- Add test cases
- Improve test coverage
- Fix flaky tests
- Add integration tests

### Code Quality

- Refactor code
- Improve comments
- Add error handling
- Optimize performance

## Questions?

- **General questions**: Open a discussion on GitHub
- **Bug reports**: Open an issue with details
- **Feature requests**: Open an issue for discussion
- **Security issues**: Email maintainers directly

## Recognition

Contributors will be:
- Added to AUTHORS file
- Credited in release notes
- Mentioned in project acknowledgments

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Simple Shell!** 🎉

Your contributions help make this project better for everyone.
