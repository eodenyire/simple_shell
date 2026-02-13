# Troubleshooting Guide

Common issues and solutions for Simple Shell.

## Table of Contents

1. [Compilation Issues](#compilation-issues)
2. [Runtime Errors](#runtime-errors)
3. [Built-in Command Issues](#built-in-command-issues)
4. [Memory Issues](#memory-issues)
5. [Test Failures](#test-failures)
6. [Performance Issues](#performance-issues)
7. [Platform-Specific Issues](#platform-specific-issues)

## Compilation Issues

### Error: `gcc: command not found`

**Problem**: GCC compiler is not installed.

**Solution**:
```bash
sudo apt-get update
sudo apt-get install gcc build-essential
```

**Verify**:
```bash
gcc --version
```

---

### Error: Multiple undefined references

**Problem**: Missing source files during compilation.

**Solution**:
```bash
# Make sure you're in the project directory
cd /path/to/simple_shell

# List all C files (should show 30+ files)
ls *.c | wc -l

# Compile with all files
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh
```

---

### Warning: Implicit declaration of function

**Problem**: Missing function prototypes or includes.

**Solution**:
- Check that `main.h` is included at the top of the file
- Verify function prototype exists in `main.h`
- Ensure correct function name spelling

**Example Fix**:
```c
#include "main.h"  /* Add this at the top */
```

---

### Error: Too many errors, compilation terminated

**Problem**: Usually caused by missing header file.

**Solution**:
```bash
# Check main.h exists
ls -l main.h

# Try compiling without -Werror first to see all errors
gcc -Wall -Wextra -pedantic -std=gnu89 *.c -o hsh
```

---

## Runtime Errors

### Shell doesn't start / No prompt appears

**Problem**: Binary not executable or PATH issue.

**Solution**:
```bash
# Make executable
chmod +x hsh

# Run with explicit path
./hsh

# Check if it's running
ps aux | grep hsh
```

---

### Command not found errors for valid commands

**Problem**: PATH environment variable issue.

**Solution**:
```bash
# Check PATH in the shell
echo "env | grep PATH" | ./hsh

# Verify PATH contains /bin and /usr/bin
echo $PATH

# Try with absolute path
echo "/bin/ls" | ./hsh
```

---

### Segmentation fault

**Problem**: Memory access error.

**Debug Steps**:
```bash
# Run with GDB
gdb ./hsh
(gdb) run
# When it crashes:
(gdb) backtrace
(gdb) print variable_name

# Or use valgrind
valgrind --track-origins=yes ./hsh
```

**Common Causes**:
- Dereferencing NULL pointer
- Buffer overflow
- Use-after-free
- Stack overflow

---

### Shell hangs / freezes

**Problem**: Infinite loop or waiting for input.

**Solution**:
```bash
# Press Ctrl+C to interrupt
# Or kill the process
ps aux | grep hsh
kill -9 <PID>
```

**Prevention**:
- Avoid commands that wait for input indefinitely
- Use timeout for testing:
```bash
timeout 5 ./hsh
```

---

## Built-in Command Issues

### `cd` doesn't change directory

**Problem**: cd implementation or environment variable issue.

**Debug**:
```bash
echo -e "cd /tmp\npwd\nexit" | ./hsh
```

**Solution**:
- Check if HOME is set: `echo "env | grep HOME" | ./hsh`
- Use absolute paths
- Check directory exists and has permissions

---

### `exit` doesn't work with status code

**Problem**: Exit status not being set correctly.

**Test**:
```bash
echo "exit 42" | ./hsh
echo $?  # Should print 42
```

**Solution**:
- Verify exit accepts numeric argument
- Check return value handling in main()

---

### `env` prints nothing or incomplete

**Problem**: Environment not being passed correctly.

**Solution**:
```bash
# Test environment passing
echo "env" | ./hsh | wc -l  # Should show many lines

# Check specific variable
echo "env | grep HOME" | ./hsh
```

---

### `setenv`/`unsetenv` don't work

**Problem**: Environment modification not persisting.

**Test**:
```bash
echo -e "setenv TEST value\nenv | grep TEST\nexit" | ./hsh
```

**Common Issue**: Changes only affect child processes, not parent.

---

## Memory Issues

### Memory leaks detected

**Problem**: Memory allocated but not freed.

**Detect**:
```bash
echo -e "ls\npwd\nexit" | valgrind --leak-check=full ./hsh
```

**Common Causes**:
- Malloc without corresponding free
- Lost pointers to allocated memory
- Not freeing on error paths

**Solution Pattern**:
```c
char *ptr = malloc(size);
if (ptr == NULL)
    return (-1);  /* Don't forget to free existing memory! */

/* Use ptr */

free(ptr);  /* Always free */
return (0);
```

---

### Double free or corruption

**Problem**: Freeing same memory twice.

**Solution**:
- Set pointer to NULL after free: `free(ptr); ptr = NULL;`
- Don't free static/stack memory
- Track ownership of pointers

---

### Stack overflow

**Problem**: Too much recursion or large local arrays.

**Solution**:
- Limit recursion depth
- Use heap allocation for large buffers:
```c
/* Bad: */
char buffer[10000];

/* Good: */
char *buffer = malloc(10000);
```

---

## Test Failures

### test_shell.sh fails

**Common Issues**:

1. **Permission denied**
```bash
chmod +x test_shell.sh
./test_shell.sh
```

2. **Binary not found**
```bash
# Compile first
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh
./test_shell.sh
```

3. **Unexpected output format**
- Check shell prompt is "$ " not something else
- Verify no extra debug output

---

### Valgrind reports errors

**Different error types**:

1. **Invalid read/write**
```
Invalid read of size 1
```
- Buffer overflow/underflow
- Check array bounds

2. **Use after free**
```
Invalid read of size X
Address 0x... is 0 bytes inside a block of size X free'd
```
- Don't use pointers after free()

3. **Memory leak**
```
definitely lost: X bytes in Y blocks
```
- Add missing free() calls

---

## Performance Issues

### Shell is slow to start

**Problem**: Unnecessary work during initialization.

**Profile**:
```bash
time ./hsh -c "exit"
```

**Should be**: < 20ms

**Causes**:
- Loading unnecessary files
- Complex initialization
- Large environment

---

### Commands execute slowly

**Problem**: Inefficient PATH search or command execution.

**Test**:
```bash
time echo "ls" | ./hsh
```

**Should be**: < 50ms for simple commands

---

## Platform-Specific Issues

### Ubuntu 22.04: Warnings about deprecation

**Problem**: Newer GCC version shows more warnings.

**Solution**:
```bash
# Compile without -Werror temporarily
gcc -Wall -Wextra -pedantic -std=gnu89 *.c -o hsh
```

---

### macOS: Compilation fails

**Problem**: macOS uses clang, not gcc.

**Solution**:
```bash
# Use clang instead
clang -Wall -Wextra -pedantic -std=gnu89 *.c -o hsh
```

**Note**: Some features may not work identically on macOS.

---

### Windows (WSL): Permission issues

**Problem**: Windows filesystem in WSL.

**Solution**:
```bash
# Move project to Linux filesystem
mkdir -p ~/projects
cd ~/projects
git clone <repo>
cd simple_shell
```

---

## Debug Techniques

### Enable Debug Output

Add to your code temporarily:
```c
fprintf(stderr, "DEBUG: variable = %d\n", variable);
```

### Use GDB

```bash
gcc -g -Wall -Wextra -pedantic -std=gnu89 *.c -o hsh_debug
gdb ./hsh_debug
(gdb) break main
(gdb) run
(gdb) next
(gdb) print variable
(gdb) continue
```

### Use Valgrind

```bash
# Memory leaks
valgrind --leak-check=full ./hsh

# More details
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./hsh

# Generate log
valgrind --leak-check=full --log-file=valgrind.log ./hsh
```

### Add Assertions

```c
#include <assert.h>

assert(ptr != NULL);
assert(size > 0);
```

---

## Getting More Help

### Check Documentation

1. [QUICKSTART.md](QUICKSTART.md) - Getting started
2. [INSTALLATION.md](INSTALLATION.md) - Installation issues
3. [EXAMPLES.md](EXAMPLES.md) - Usage examples
4. [DEVELOPMENT.md](DEVELOPMENT.md) - Development setup

### Report a Bug

If you've found a new issue:

1. Check if it's already reported
2. Collect information:
   - OS version: `lsb_release -a`
   - GCC version: `gcc --version`
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages
3. Open an issue on GitHub with details

### Contact

- GitHub Issues: Best for bugs and features
- Email: For security issues only

---

## Quick Reference

### Essential Commands

```bash
# Compile
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh

# Run tests
./test_shell.sh

# Check memory
valgrind --leak-check=full ./hsh

# Debug
gdb ./hsh
```

### Common Fixes

```bash
# Recompile clean
rm hsh
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh

# Reset to clean state
git clean -fdx
git reset --hard

# Reinstall dependencies
sudo apt-get update
sudo apt-get install --reinstall gcc build-essential
```

---

**Still stuck?** Open an issue on GitHub with your error message and system details!
