# Development Guide

Complete guide for developing and contributing to Simple Shell.

## Table of Contents

1. [Development Setup](#development-setup)
2. [Coding Standards](#coding-standards)
3. [Development Workflow](#development-workflow)
4. [Testing](#testing)
5. [Debugging](#debugging)
6. [Code Review](#code-review)
7. [Release Process](#release-process)

## Development Setup

### Prerequisites

```bash
# Install development tools
sudo apt-get update
sudo apt-get install -y \
    gcc \
    make \
    git \
    valgrind \
    gdb \
    build-essential

# Verify installations
gcc --version
git --version
valgrind --version
gdb --version
```

### Clone and Setup

```bash
# Fork repository on GitHub first
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/simple_shell.git
cd simple_shell

# Add upstream remote
git remote add upstream https://github.com/eodenyire/simple_shell.git

# Verify remotes
git remote -v
```

### Build from Source

```bash
# Standard build
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh

# Debug build
gcc -Wall -Wextra -pedantic -std=gnu89 -g *.c -o hsh_debug

# Optimized build
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 -O2 *.c -o hsh
```

### IDE/Editor Setup

#### VS Code
```json
{
    "C_Cpp.default.compilerPath": "/usr/bin/gcc",
    "C_Cpp.default.cStandard": "c89",
    "C_Cpp.default.compileCommands": "${workspaceFolder}/compile_commands.json",
    "files.associations": {
        "main.h": "c"
    }
}
```

#### Vim
```vim
" Add to .vimrc
set tabstop=8
set shiftwidth=8
set noexpandtab
syntax on
```

## Coding Standards

### Betty Style Guide

Follow the Betty style guide strictly:

#### File Structure
```c
#include "main.h"

/**
 * function_name - Brief description
 * @param1: Description of param1
 * @param2: Description of param2
 *
 * Detailed description if needed.
 * Can span multiple lines.
 *
 * Return: Description of return value
 */
int function_name(int param1, char *param2)
{
	int local_var;

	if (param1 < 0)
		return (-1);

	local_var = param1 + _strlen(param2);
	return (local_var);
}
```

#### Key Rules

1. **Line Length**: Maximum 80 characters
2. **Function Length**: Maximum 40 lines
3. **Functions Per File**: Maximum 5
4. **Indentation**: Tabs (width 8)
5. **Braces**: K&R style
6. **Spaces**: After keywords (if, while, for)

#### Naming Conventions

```c
/* Variables */
int my_variable;        /* lowercase with underscores */
int counter;            /* descriptive names */

/* Functions */
int my_function(void);  /* lowercase with underscores */

/* Constants */
#define MAX_SIZE 1024   /* UPPERCASE with underscores */

/* Macros */
#define BUFSIZE 1024

/* Structs */
typedef struct my_struct_s
{
	int member;
} my_struct;
```

#### Comments

```c
/* Single line comment */

/**
 * Multi-line comment
 * for complex explanations
 */

/* Function documentation - MANDATORY */
/**
 * function_name - Does something
 * @param: Parameter description
 *
 * Return: What it returns
 */
```

### Code Quality Checks

```bash
# Check Betty style
./check_style.sh

# Check compilation
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh

# Check memory leaks
echo "ls" | valgrind --leak-check=full ./hsh

# Run tests
./test_shell.sh
./test_advanced.sh
```

## Development Workflow

### Creating a New Feature

```bash
# 1. Update main branch
git checkout main
git pull upstream main

# 2. Create feature branch
git checkout -b feature/my-feature

# 3. Make changes
# Edit files...

# 4. Compile and test
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh
./test_shell.sh

# 5. Commit changes
git add file1.c file2.c
git commit -m "Add feature: description

Detailed explanation of changes made.

Fixes #123"

# 6. Push to your fork
git push origin feature/my-feature

# 7. Create Pull Request on GitHub
```

### Fixing a Bug

```bash
# 1. Create bug fix branch
git checkout -b fix/bug-description

# 2. Write test that reproduces bug
# Add to test_shell.sh or test_advanced.sh

# 3. Fix the bug
# Edit code...

# 4. Verify fix
./test_shell.sh
valgrind --leak-check=full ./hsh

# 5. Commit
git commit -am "Fix: bug description

- Describe the bug
- Describe the fix
- Reference issue

Fixes #456"

# 6. Push and create PR
git push origin fix/bug-description
```

### Working with Existing Code

```bash
# Read before modifying
cat main.h              # Understand data structures
cat file.c              # Understand current implementation

# Check function dependencies
grep -r "function_name" *.c

# Run tests before changes
./test_shell.sh

# Make minimal changes
# Edit only what's necessary

# Run tests after changes
./test_shell.sh
./test_advanced.sh
```

## Testing

### Unit Testing

Create test functions for new features:

```bash
# Add to test_shell.sh
echo -n "Testing: new feature... "
output=$(echo "test_command" | ./hsh 2>&1)
if echo "$output" | grep -q "expected"; then
    echo -e "${GREEN}PASSED${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAILED${NC}"
    ((FAILED++))
fi
```

### Integration Testing

Test complete workflows:

```bash
# Multi-command test
echo -e "cmd1\ncmd2\ncmd3\nexit" | ./hsh
```

### Memory Testing

```bash
# Check for memory leaks
echo "ls" | valgrind --leak-check=full ./hsh

# Detailed memory analysis
valgrind --leak-check=full \
         --show-leak-kinds=all \
         --track-origins=yes \
         --log-file=valgrind.log \
         ./hsh

# Check log
cat valgrind.log
```

### Automated Testing

```bash
# Run all tests
./test_shell.sh && ./test_advanced.sh && ./check_style.sh

# Save results
./test_shell.sh > test_results.txt 2>&1
```

## Debugging

### Using GDB

```bash
# Compile with debug symbols
gcc -g -Wall -Wextra -pedantic -std=gnu89 *.c -o hsh_debug

# Start GDB
gdb ./hsh_debug

# Common GDB commands
(gdb) break main              # Set breakpoint
(gdb) break file.c:42         # Break at line
(gdb) run                     # Start program
(gdb) next                    # Next line
(gdb) step                    # Step into function
(gdb) continue                # Continue execution
(gdb) print variable          # Print variable
(gdb) backtrace               # Show call stack
(gdb) quit                    # Exit GDB
```

### Debugging Techniques

#### Print Debugging

```c
/* Add temporary debug output */
fprintf(stderr, "DEBUG: var=%d\n", var);
```

#### Assert Statements

```c
#include <assert.h>

assert(ptr != NULL);
assert(size > 0);
```

#### Valgrind for Memory Issues

```bash
# Memory leaks
valgrind --leak-check=full ./hsh

# Invalid memory access
valgrind --track-origins=yes ./hsh

# Uninitialized values
valgrind --track-origins=yes ./hsh
```

### Common Issues and Solutions

#### Segmentation Fault

```bash
# Run with GDB to find location
gdb ./hsh
(gdb) run
# When it crashes:
(gdb) backtrace
(gdb) print variable_name
```

#### Memory Leak

```bash
# Find leak source
valgrind --leak-check=full --show-leak-kinds=all ./hsh
# Look for "definitely lost" blocks
```

#### Compilation Error

```bash
# Read error carefully
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh

# Fix one error at a time
# Start from the first error
```

## Code Review

### Self-Review Checklist

Before submitting a PR:

- [ ] Code compiles without warnings
- [ ] All tests pass
- [ ] No memory leaks (valgrind clean)
- [ ] Code follows Betty style
- [ ] Functions are documented
- [ ] Edge cases handled
- [ ] Error conditions checked
- [ ] No TODO or FIXME comments
- [ ] Commit messages are clear

### Review Others' Code

When reviewing PRs:

1. **Understand the change**: Read the description
2. **Check tests**: Do tests cover the change?
3. **Review code**: Look for bugs, style issues
4. **Test locally**: Pull and test the changes
5. **Provide feedback**: Be constructive and specific

### Addressing Review Feedback

```bash
# Make requested changes
# Edit files...

# Commit changes
git add changed_files
git commit -m "Address review feedback: description"

# Push to update PR
git push origin feature-branch
```

## Release Process

### Version Numbering

Follow Semantic Versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

### Pre-Release Checklist

- [ ] All tests passing
- [ ] No memory leaks
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version number bumped
- [ ] Code reviewed
- [ ] Tagged in git

### Creating a Release

```bash
# 1. Update version
# Edit relevant files

# 2. Update CHANGELOG.md
# Add release notes

# 3. Commit
git commit -am "Release v1.0.0"

# 4. Create tag
git tag -a v1.0.0 -m "Version 1.0.0"

# 5. Push
git push origin main --tags
```

## Best Practices

### Do's ✅

- Write clear commit messages
- Add tests for new features
- Check for memory leaks
- Follow coding standards
- Document functions
- Handle errors
- Use meaningful names
- Keep functions small
- Test before committing

### Don'ts ❌

- Don't commit without testing
- Don't ignore compiler warnings
- Don't leave debug code
- Don't use magic numbers
- Don't copy-paste code
- Don't skip documentation
- Don't force push after review
- Don't commit large files
- Don't break existing tests

## Tools and Resources

### Essential Tools

```bash
# Compiler
gcc --version

# Debugger
gdb --version

# Memory checker
valgrind --version

# Version control
git --version
```

### Helpful Commands

```bash
# Find function definition
grep -rn "function_name" *.c

# Count lines of code
wc -l *.c *.h

# Check file encoding
file filename.c

# Format code (manual)
# Use tabs, follow Betty

# Generate tags
ctags -R
```

### Documentation

- [Betty Style Guide](https://github.com/holbertonschool/Betty)
- [GNU C Manual](https://www.gnu.org/software/gnu-c-manual/)
- [GDB Manual](https://www.gnu.org/software/gdb/documentation/)
- [Valgrind Manual](http://valgrind.org/docs/manual/manual.html)

## Getting Help

### Resources

1. **Project Documentation**: Check all README files
2. **Issue Tracker**: Search existing issues
3. **Code Comments**: Read inline documentation
4. **Git History**: Check commit messages

### Asking Questions

When asking for help:

1. **Search first**: Check if already answered
2. **Be specific**: Include error messages
3. **Provide context**: What were you trying to do?
4. **Show code**: Share relevant code snippets
5. **Describe environment**: OS, GCC version, etc.

---

**Ready to develop?** See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines!
