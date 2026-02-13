# Usage Examples

Comprehensive examples for using Simple Shell.

## Table of Contents

1. [Basic Command Execution](#basic-command-execution)
2. [Built-in Commands](#built-in-commands)
3. [Working with Directories](#working-with-directories)
4. [Environment Variables](#environment-variables)
5. [Command Chaining](#command-chaining)
6. [Advanced Usage](#advanced-usage)
7. [Practical Scenarios](#practical-scenarios)

## Basic Command Execution

### Running Simple Commands

```bash
$ ./hsh
$ ls
AUTHORS    README.md    aux_help.c    main.c
$ pwd
/home/user/simple_shell
$ date
Wed Feb 13 12:00:00 UTC 2026
$ whoami
user
$ exit
```

### Commands with Arguments

```bash
$ ./hsh
$ ls -l
total 128
-rw-r--r-- 1 user user  3119 Feb 13 12:00 README.md
-rw-r--r-- 1 user user  2884 Feb 13 12:00 main.c
$ ls -la /tmp
total 12
drwxrwxrwt 2 root root 4096 Feb 13 12:00 .
drwxr-xr-x 20 root root 4096 Feb 13 12:00 ..
$ echo "Hello, World!"
Hello, World!
$ exit
```

### Using Absolute Paths

```bash
$ ./hsh
$ /bin/ls
AUTHORS    README.md    main.c
$ /usr/bin/env
HOME=/home/user
PATH=/usr/bin:/bin
$ /bin/echo "Testing absolute paths"
Testing absolute paths
$ exit
```

## Built-in Commands

### exit - Exit the Shell

```bash
# Exit with default status (0)
$ ./hsh
$ exit

# Exit with specific status code
$ ./hsh
$ exit 0
$ echo $?    # Check exit status
0

# Exit with error code
$ ./hsh
$ exit 127
$ echo $?
127
```

### env - Display Environment Variables

```bash
$ ./hsh
$ env
USER=user
HOME=/home/user
PATH=/usr/bin:/bin
SHELL=/bin/bash
$ exit
```

### cd - Change Directory

```bash
$ ./hsh
$ pwd
/home/user/simple_shell

# Go to specific directory
$ cd /tmp
$ pwd
/tmp

# Go to home directory
$ cd
$ pwd
/home/user

# Go to home directory (alternative)
$ cd ~
$ pwd
/home/user

# Go to previous directory
$ cd /tmp
$ cd /var
$ cd -
/tmp
$ pwd
/tmp

# Relative paths
$ cd ..
$ pwd
/

$ exit
```

### setenv - Set Environment Variable

```bash
$ ./hsh
$ setenv MY_VAR "Hello World"
$ env | grep MY_VAR
MY_VAR=Hello World

$ setenv PATH "/usr/local/bin:/usr/bin:/bin"
$ env | grep PATH
PATH=/usr/local/bin:/usr/bin:/bin

$ exit
```

### unsetenv - Remove Environment Variable

```bash
$ ./hsh
$ setenv TEMP_VAR "temporary"
$ env | grep TEMP_VAR
TEMP_VAR=temporary

$ unsetenv TEMP_VAR
$ env | grep TEMP_VAR
(no output - variable removed)

$ exit
```

### help - Get Help

```bash
$ ./hsh
$ help
Simple Shell Help
Available commands: exit, env, cd, setenv, unsetenv, help

$ help cd
cd: Change the shell working directory
Usage: cd [dir]

$ help exit
exit: Exit the shell
Usage: exit [n]

$ exit
```

## Working with Directories

### Navigation Examples

```bash
$ ./hsh
$ pwd
/home/user

# Create and navigate to directories
$ cd projects
$ pwd
/home/user/projects

$ cd simple_shell
$ pwd
/home/user/projects/simple_shell

# Use .. to go up
$ cd ..
$ pwd
/home/user/projects

$ cd ../..
$ pwd
/home

# Jump to root
$ cd /
$ pwd
/

# Return home
$ cd
$ pwd
/home/user

$ exit
```

### Directory Listing

```bash
$ ./hsh
$ ls
file1.txt    file2.txt    directory1

$ ls -l
-rw-r--r-- 1 user user  100 Feb 13 12:00 file1.txt
-rw-r--r-- 1 user user  200 Feb 13 12:00 file2.txt
drwxr-xr-x 2 user user 4096 Feb 13 12:00 directory1

$ ls -la
total 20
drwxr-xr-x 3 user user 4096 Feb 13 12:00 .
drwxr-xr-x 5 user user 4096 Feb 13 12:00 ..
-rw-r--r-- 1 user user  100 Feb 13 12:00 file1.txt

$ ls /usr/bin
(lists files in /usr/bin)

$ exit
```

## Environment Variables

### Viewing Variables

```bash
$ ./hsh
# View all environment variables
$ env

# View specific variables
$ env | grep HOME
HOME=/home/user

$ env | grep PATH
PATH=/usr/bin:/bin

$ exit
```

### Setting and Using Variables

```bash
$ ./hsh
# Set custom variable
$ setenv PROJECT_NAME "Simple Shell"
$ setenv VERSION "1.0.0"
$ setenv DEBUG "true"

# View them
$ env | grep PROJECT
PROJECT_NAME=Simple Shell

$ env | grep VERSION
VERSION=1.0.0

# Remove when done
$ unsetenv DEBUG

$ exit
```

### Modifying PATH

```bash
$ ./hsh
# View current PATH
$ env | grep PATH
PATH=/usr/bin:/bin

# Add directory to PATH
$ setenv PATH "/home/user/bin:/usr/bin:/bin"

# Verify
$ env | grep PATH
PATH=/home/user/bin:/usr/bin:/bin

$ exit
```

## Command Chaining

### Using Semicolon (;)

```bash
$ ./hsh
# Run multiple commands sequentially
$ echo "First" ; echo "Second" ; echo "Third"
First
Second
Third

$ cd /tmp ; pwd ; ls
/tmp
(files in /tmp)

$ exit
```

### Logical AND (&&)

```bash
$ ./hsh
# Second command runs only if first succeeds
$ echo "Success" && echo "This runs"
Success
This runs

$ ls /nonexistent && echo "Won't run"
ls: cannot access '/nonexistent': No such file or directory
(second command doesn't run)

$ cd /tmp && pwd
/tmp

$ exit
```

### Logical OR (||)

```bash
$ ./hsh
# Second command runs only if first fails
$ ls /nonexistent || echo "First failed, so this runs"
ls: cannot access '/nonexistent': No such file or directory
First failed, so this runs

$ echo "Success" || echo "Won't run"
Success
(second command doesn't run)

$ exit
```

### Combining Operators

```bash
$ ./hsh
# Complex command chains
$ cd /tmp && pwd || echo "cd failed"
/tmp

$ cd /nonexistent || echo "cd failed" && pwd
cd failed
/home/user

$ echo "one" ; echo "two" && echo "three" || echo "four"
one
two
three

$ exit
```

## Advanced Usage

### Variable Expansion

```bash
$ ./hsh
# $? - Exit status of last command
$ ls
(files listed)
$ echo $?
0

$ ls /nonexistent
ls: cannot access '/nonexistent': No such file or directory
$ echo $?
2

# $$ - Current shell PID
$ echo $$
12345

$ exit
```

### Comments

```bash
$ ./hsh
# Lines starting with # are ignored
$ # This is a comment
$ echo "test"    # Comment after command
test

$ ls # List files
(files listed)

$ exit
```

### Error Handling

```bash
$ ./hsh
# Command not found
$ nonexistent_command
./hsh: 1: nonexistent_command: not found

# Permission denied
$ /root/private_file
./hsh: 1: /root/private_file: Permission denied

# Invalid directory
$ cd /nonexistent_dir
cd: can't cd to /nonexistent_dir

$ exit
```

## Practical Scenarios

### Scenario 1: Project Setup

```bash
$ ./hsh
# Navigate to projects directory
$ cd ~/projects

# Create and enter project directory
$ cd new_project

# Check current location
$ pwd
/home/user/projects/new_project

# Set project variables
$ setenv PROJECT_ROOT "/home/user/projects/new_project"
$ setenv BUILD_TYPE "debug"

# Verify setup
$ env | grep PROJECT
PROJECT_ROOT=/home/user/projects/new_project
BUILD_TYPE=debug

$ exit
```

### Scenario 2: File Management

```bash
$ ./hsh
# List files
$ ls -l

# Navigate directories
$ cd documents

# Check contents
$ ls

# Go back
$ cd -

# Multiple operations
$ pwd ; ls ; cd .. ; pwd
/home/user/documents
(files)
/home/user

$ exit
```

### Scenario 3: Environment Configuration

```bash
$ ./hsh
# Set up development environment
$ setenv EDITOR "vim"
$ setenv LANG "en_US.UTF-8"
$ setenv PATH "/usr/local/bin:/usr/bin:/bin"

# Verify configuration
$ env | grep EDITOR
EDITOR=vim

$ env | grep LANG
LANG=en_US.UTF-8

$ exit
```

### Scenario 4: Quick Testing

```bash
$ ./hsh
# Test multiple commands quickly
$ echo "test1" && echo "test2" && echo "test3"
test1
test2
test3

# Test with error handling
$ ls /tmp && echo "Success" || echo "Failed"
(contents of /tmp)
Success

$ ls /nonexistent && echo "Success" || echo "Failed"
ls: cannot access '/nonexistent': No such file or directory
Failed

$ exit
```

### Scenario 5: Directory Traversal

```bash
$ ./hsh
# Save current directory
$ pwd
/home/user/project

# Go somewhere
$ cd /tmp
$ pwd
/tmp

# Go back
$ cd -
/home/user/project

# Quick navigation
$ cd .. ; pwd ; cd - ; pwd
/home/user
/home/user/project

$ exit
```

## Non-Interactive Mode

### Piping Commands

```bash
# Single command
$ echo "ls -l" | ./hsh

# Multiple commands
$ echo -e "pwd\nls\nexit" | ./hsh

# With command chaining
$ echo "ls && pwd || echo failed" | ./hsh
```

### From File

```bash
# Create command file
$ cat > commands.txt << EOF
pwd
ls -la
cd /tmp
pwd
exit
EOF

# Execute from file
$ cat commands.txt | ./hsh
```

### Script Integration

```bash
#!/bin/bash
# Example wrapper script

# Run shell commands
echo "ls" | ./hsh
echo "pwd" | ./hsh

# Capture output
OUTPUT=$(echo "pwd" | ./hsh)
echo "Current directory: $OUTPUT"
```

## Tips and Tricks

### Quick Commands

```bash
# Check if command exists
$ which ls
/bin/ls

# View PATH
$ env | grep PATH

# Quick directory check
$ pwd ; ls

# Chain with error checking
$ cd /target && ls || echo "Failed to access"
```

### Efficiency

```bash
# Group related commands
$ cd /tmp ; ls ; pwd

# Use && for dependent commands
$ cd project && ls src

# Use || for fallback
$ cd /opt || cd /tmp
```

---

**More examples?** See [TESTING.md](TESTING.md) for test examples and [DEVELOPMENT.md](DEVELOPMENT.md) for development use cases.
