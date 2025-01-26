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
+ main.c: Entry point of the program.
+ prompt.c: Handles the prompt display and user input.
+ execute.c: Executes commands.
+ builtins.c: Implements built-in commands.
+ helpers.c: Helper functions for string manipulation and other utilities.

## Authors
Emmanuel Anyira


## License
This project is licensed under the MIT License - see the LICENSE file for details.

Feel free to customize this template to align with your project's specifics and to provide clear, concise information to users and collaborators.
::contentReference[oaicite:0]{index=0}

