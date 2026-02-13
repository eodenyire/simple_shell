# Simple Shell

## Description

This project is a simple UNIX command interpreter built as part of the [Your Program Name] curriculum. It mimics the basic functionalities of the UNIX shell, allowing users to execute commands, handle arguments, and manage the environment.

## Features

- Display a prompt and wait for user input.
- Execute commands with arguments.
- Handle the `PATH` environment variable to locate executables.
- Implement built-in commands: `exit`, `env`.
- Handle end-of-file (EOF) condition (Ctrl+D).
- Manage errors and edge cases gracefully.

## Requirements

- Allowed editors: `vi`, `vim`, `emacs`.
- All files are compiled on Ubuntu 20.04 LTS using `gcc` with options `-Wall -Werror -Wextra -pedantic -std=gnu89`.
- Code follows the Betty style guide.
- No more than 5 functions per file.
- All header files are include guarded.

## Compilation

To compile the shell, run:

```bash
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh
```
## Usage

After compilation, start the shell with:

```bash
./hsh
```
## In interactive mode, the shell displays a prompt and waits for user input:

```bash
$ ./hsh
$ ls -l
total 64
-rw-r--r-- 1 user user  1518 Jan 26 20:40 README.md
-rwxr-xr-x 1 user user 32768 Jan 26 20:40 hsh
...
$ exit
$
```
## In non-interactive mode, echo commands into the shell:

```bash
$ echo "ls -l" | ./hsh
total 64
-rw-r--r-- 1 user user  1518 Jan 26 20:40 README.md
-rwxr-xr-x 1 user user 32768 Jan 26 20:40 hsh
...
$
```

## Built-in Commands
exit: Exits the shell.
env: Prints the current environment variables.

## Files
+ README.md: Project description and usage.
+ man_1_simple_shell: Manual page for the shell.
+ AUTHORS: List of contributors.
+ main.h: Header file with function prototypes and includes.
+ main.c: Entry point of the program, initialization and cleanup.
+ shell_loop.c: Main shell loop, prompt display and input handling.
+ read_line.c: Reads user input.
+ get_line.c: Custom getline implementation.
+ split.c: Command tokenization and separator handling.
+ exec_line.c: Command line execution coordinator.
+ cmd_exec.c: Command execution with fork/exec.
+ get_builtin.c: Built-in command dispatcher.
+ exit_shell.c: Exit built-in implementation.
+ env1.c, env2.c: Environment variable handling.
+ cd.c, cd_shell.c: Change directory built-in.
+ get_help.c: Help built-in command.
+ aux_help.c, aux_help2.c: Help text for various commands.
+ aux_str.c, aux_str2.c, aux_str3.c: String utility functions.
+ aux_mem.c: Memory management utilities.
+ aux_stdlib.c: Standard library utilities (atoi, itoa).
+ aux_lists.c, aux_lists2.c: Linked list management.
+ aux_error1.c, aux_error2.c: Error message generation.
+ get_error.c: Error handling.
+ get_sigint.c: Signal handling.
+ check_syntax_error.c: Input syntax validation.
+ rep_var.c: Variable replacement and expansion.

## Authors
Emmanuel Anyira


## License
This project is licensed under the MIT License - see the LICENSE file for details.

Feel free to customize this template to align with your project's specifics and to provide clear, concise information to users and collaborators.

