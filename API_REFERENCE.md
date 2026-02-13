# API Reference

Complete function documentation for Simple Shell.

## Table of Contents

1. [Main Functions](#main-functions)
2. [String Functions](#string-functions)
3. [Memory Functions](#memory-functions)
4. [Built-in Commands](#built-in-commands)
5. [Command Execution](#command-execution)
6. [Helper Functions](#helper-functions)
7. [Data Structures](#data-structures)

## Main Functions

### main()
**File**: `main.c`

```c
int main(int ac, char **av);
```

**Description**: Entry point of the shell program.

**Parameters**:
- `ac`: Argument count (unused)
- `av`: Argument vector (program name and arguments)

**Returns**: Exit status (0 on success, non-zero on error)

**Behavior**:
1. Initializes data structure
2. Sets up signal handlers
3. Copies environment
4. Enters main shell loop
5. Cleans up and exits

---

### shell_loop()
**File**: `shell_loop.c`

```c
void shell_loop(data_shell *datash);
```

**Description**: Main shell loop that handles input and execution.

**Parameters**:
- `datash`: Pointer to shell data structure

**Returns**: void

**Behavior**:
1. Displays prompt in interactive mode
2. Reads user input
3. Removes comments
4. Checks syntax errors
5. Expands variables
6. Splits and executes commands
7. Repeats until exit condition

---

### exec_line()
**File**: `exec_line.c`

```c
int exec_line(data_shell *datash);
```

**Description**: Executes a single command line.

**Parameters**:
- `datash`: Pointer to shell data structure with parsed command

**Returns**:
- `0`: Exit shell
- `1`: Continue

---

## String Functions

### _strlen()
**File**: `aux_str2.c`

```c
int _strlen(const char *s);
```

**Description**: Calculates the length of a string.

**Parameters**:
- `s`: String to measure

**Returns**: Length of string (number of characters before null terminator)

**Example**:
```c
int len = _strlen("hello");  /* returns 5 */
```

---

### _strcmp()
**File**: `aux_str.c`

```c
int _strcmp(char *s1, char *s2);
```

**Description**: Compares two strings.

**Parameters**:
- `s1`: First string
- `s2`: Second string

**Returns**:
- `0`: Strings are equal
- `1`: s1 > s2
- `-1`: s1 < s2

**Example**:
```c
if (_strcmp(cmd, "exit") == 0)
    /* command is "exit" */
```

---

### _strcpy()
**File**: `aux_str.c`

```c
char *_strcpy(char *dest, char *src);
```

**Description**: Copies a string from src to dest.

**Parameters**:
- `dest`: Destination buffer
- `src`: Source string

**Returns**: Pointer to dest

**Warning**: Ensure dest has enough space for src + null terminator

---

### _strcat()
**File**: `aux_str.c`

```c
char *_strcat(char *dest, const char *src);
```

**Description**: Concatenates src to end of dest.

**Parameters**:
- `dest`: Destination string (modified)
- `src`: Source string (appended)

**Returns**: Pointer to dest

**Warning**: Ensure dest has enough space

---

### _strchr()
**File**: `aux_str.c`

```c
char *_strchr(char *s, char c);
```

**Description**: Locates first occurrence of character in string.

**Parameters**:
- `s`: String to search
- `c`: Character to find

**Returns**:
- Pointer to first occurrence of c in s
- `NULL` if not found

---

### _strdup()
**File**: `aux_str2.c`

```c
char *_strdup(const char *s);
```

**Description**: Duplicates a string (allocates new memory).

**Parameters**:
- `s`: String to duplicate

**Returns**:
- Pointer to new string (must be freed)
- `NULL` on allocation failure

**Example**:
```c
char *copy = _strdup("hello");
/* use copy */
free(copy);
```

---

### _strtok()
**File**: `aux_str2.c`

```c
char *_strtok(char str[], const char *delim);
```

**Description**: Tokenizes a string (modifies input).

**Parameters**:
- `str`: String to tokenize (first call) or NULL (subsequent calls)
- `delim`: Delimiter characters

**Returns**: Pointer to next token or NULL

**Warning**: Modifies input string

**Example**:
```c
char input[] = "ls -l -a";
char *token = _strtok(input, " ");  /* "ls" */
token = _strtok(NULL, " ");         /* "-l" */
token = _strtok(NULL, " ");         /* "-a" */
```

---

## Memory Functions

### _realloc()
**File**: `aux_mem.c`

```c
void *_realloc(void *ptr, unsigned int old_size, unsigned int new_size);
```

**Description**: Reallocates memory block.

**Parameters**:
- `ptr`: Pointer to current block
- `old_size`: Current size
- `new_size`: New size

**Returns**: Pointer to new block or NULL

---

### _reallocdp()
**File**: `aux_mem.c`

```c
char **_reallocdp(char **ptr, unsigned int old_size, unsigned int new_size);
```

**Description**: Reallocates double pointer (array of strings).

**Parameters**:
- `ptr`: Array to reallocate
- `old_size`: Current size
- `new_size`: New size

**Returns**: Pointer to new array or NULL

---

## Built-in Commands

### exit_shell()
**File**: `exit_shell.c`

```c
int exit_shell(data_shell *datash);
```

**Description**: Exits the shell with optional status.

**Parameters**:
- `datash`: Shell data structure

**Returns**: (doesn't return if successful)

**Usage**: `exit` or `exit <status>`

---

### _env()
**File**: `env1.c`

```c
int _env(data_shell *datash);
```

**Description**: Prints environment variables.

**Parameters**:
- `datash`: Shell data structure

**Returns**: Always 1

**Usage**: `env`

---

### cd_shell()
**File**: `cd_shell.c`

```c
int cd_shell(data_shell *datash);
```

**Description**: Changes current directory.

**Parameters**:
- `datash`: Shell data structure (args[1] contains target directory)

**Returns**: Always 1

**Usage**:
- `cd` - go to HOME
- `cd <dir>` - go to directory
- `cd -` - go to previous directory
- `cd ~` - go to HOME

---

### _setenv()
**File**: `env2.c`

```c
int _setenv(data_shell *datash);
```

**Description**: Sets or modifies environment variable.

**Parameters**:
- `datash`: Shell data (args[1]=name, args[2]=value)

**Returns**: Always 1

**Usage**: `setenv VAR value`

---

### _unsetenv()
**File**: `env2.c`

```c
int _unsetenv(data_shell *datash);
```

**Description**: Removes environment variable.

**Parameters**:
- `datash`: Shell data (args[1]=name)

**Returns**: Always 1

**Usage**: `unsetenv VAR`

---

### get_help()
**File**: `get_help.c`

```c
int get_help(data_shell *datash);
```

**Description**: Displays help information.

**Parameters**:
- `datash`: Shell data (args[1]=command name or NULL)

**Returns**: Always 1

**Usage**: `help` or `help <command>`

---

## Command Execution

### cmd_exec()
**File**: `cmd_exec.c`

```c
int cmd_exec(data_shell *datash);
```

**Description**: Executes external commands using fork/exec.

**Parameters**:
- `datash`: Shell data with parsed command

**Returns**: Always 1

**Behavior**:
1. Checks if command is executable path
2. Searches PATH if needed
3. Forks child process
4. Executes command in child
5. Waits for child in parent
6. Updates status

---

### _which()
**File**: `cmd_exec.c`

```c
char *_which(char *cmd, char **_environ);
```

**Description**: Locates command in PATH.

**Parameters**:
- `cmd`: Command name
- `_environ`: Environment array

**Returns**:
- Full path to command
- `NULL` if not found

**Behavior**:
1. Gets PATH from environment
2. Splits PATH into directories
3. Checks each directory for command
4. Returns first match

---

### is_executable()
**File**: `cmd_exec.c`

```c
int is_executable(data_shell *datash);
```

**Description**: Checks if command is an executable path.

**Parameters**:
- `datash`: Shell data

**Returns**:
- `0`: Not an executable path
- `>0`: Offset to start of path
- `-1`: Error

---

### get_builtin()
**File**: `get_builtin.c`

```c
int (*get_builtin(char *cmd))(data_shell *datash);
```

**Description**: Returns function pointer for built-in command.

**Parameters**:
- `cmd`: Command name

**Returns**:
- Function pointer if builtin
- `NULL` if not builtin

**Example**:
```c
int (*builtin)(data_shell *) = get_builtin("exit");
if (builtin != NULL)
    builtin(datash);
```

---

## Helper Functions

### split_line()
**File**: `split.c`

```c
char **split_line(char *input);
```

**Description**: Tokenizes input into arguments.

**Parameters**:
- `input`: Input string (modified)

**Returns**: Array of argument strings (NULL-terminated)

**Example**:
```c
char input[] = "ls -l -a";
char **args = split_line(input);
/* args[0] = "ls", args[1] = "-l", args[2] = "-a", args[3] = NULL */
```

---

### split_commands()
**File**: `split.c`

```c
int split_commands(data_shell *datash, char *input);
```

**Description**: Splits input into commands by separators.

**Parameters**:
- `datash`: Shell data
- `input`: Input string

**Returns**:
- `0`: Exit requested
- `1`: Continue

**Separators**: `;`, `&&`, `||`

---

### rep_var()
**File**: `rep_var.c`

```c
char *rep_var(char *input, data_shell *datash);
```

**Description**: Replaces variables in input string.

**Parameters**:
- `input`: Input with variables
- `datash`: Shell data for variable values

**Returns**: New string with variables replaced

**Variables**:
- `$?`: Last exit status
- `$$`: Shell PID
- `$VAR`: Environment variable

**Example**:
```c
/* input: "Status: $? PID: $$" */
/* output: "Status: 0 PID: 12345" */
```

---

### check_syntax_error()
**File**: `check_syntax_error.c`

```c
int check_syntax_error(data_shell *datash, char *input);
```

**Description**: Checks for syntax errors in input.

**Parameters**:
- `datash`: Shell data
- `input`: Input string

**Returns**:
- `0`: No errors
- `1`: Syntax error found

**Checks**:
- Repeated separators
- Invalid separator placement
- Leading separators

---

### _getenv()
**File**: `env1.c`

```c
char *_getenv(const char *name, char **_environ);
```

**Description**: Gets value of environment variable.

**Parameters**:
- `name`: Variable name
- `_environ`: Environment array

**Returns**:
- Pointer to value
- `NULL` if not found

**Example**:
```c
char *home = _getenv("HOME", environ);
```

---

### aux_itoa()
**File**: `aux_stdlib.c`

```c
char *aux_itoa(int n);
```

**Description**: Converts integer to string.

**Parameters**:
- `n`: Integer to convert

**Returns**: String representation (must be freed)

---

### _atoi()
**File**: `aux_stdlib.c`

```c
int _atoi(char *s);
```

**Description**: Converts string to integer.

**Parameters**:
- `s`: String to convert

**Returns**: Integer value

---

## Data Structures

### data_shell
**File**: `main.h`

```c
typedef struct data
{
    char **av;        /* Argument vector from main */
    char *input;      /* Current input line */
    char **args;      /* Parsed command arguments */
    int status;       /* Exit status of last command */
    int counter;      /* Line/command counter */
    char **_environ;  /* Environment variables (copy) */
    char *pid;        /* Shell process ID (string) */
} data_shell;
```

**Usage**: Primary data structure passed through shell

---

### builtin_t
**File**: `main.h`

```c
typedef struct builtin_s
{
    char *name;                         /* Command name */
    int (*f)(data_shell *datash);      /* Function pointer */
} builtin_t;
```

**Usage**: Maps builtin command names to functions

---

## Error Functions

### get_error()
**File**: `get_error.c`

```c
int get_error(data_shell *datash, int eval);
```

**Description**: Generates and prints error message.

**Parameters**:
- `datash`: Shell data
- `eval`: Error code

**Returns**: Error code

---

### error_not_found()
**File**: `aux_error1.c`

```c
char *error_not_found(data_shell *datash);
```

**Description**: Generates "command not found" error.

**Parameters**:
- `datash`: Shell data

**Returns**: Error string

---

## Signal Handling

### get_sigint()
**File**: `get_sigint.c`

```c
void get_sigint(int sig);
```

**Description**: Handles SIGINT signal (Ctrl+C).

**Parameters**:
- `sig`: Signal number

**Returns**: void

**Behavior**: Prints newline and prompt

---

## Usage Examples

### Example 1: Using String Functions

```c
char str1[] = "hello";
char str2[] = "world";
char buffer[20];

_strcpy(buffer, str1);      /* buffer = "hello" */
_strcat(buffer, " ");       /* buffer = "hello " */
_strcat(buffer, str2);      /* buffer = "hello world" */

if (_strcmp(buffer, "hello world") == 0)
    printf("Match!\n");
```

### Example 2: Executing Built-in

```c
data_shell datash;
/* initialize datash */

datash.args[0] = "cd";
datash.args[1] = "/tmp";
datash.args[2] = NULL;

int (*builtin)(data_shell *) = get_builtin("cd");
if (builtin != NULL)
    builtin(&datash);
```

### Example 3: Variable Expansion

```c
data_shell datash;
datash.status = 42;
datash.pid = "12345";

char *input = _strdup("Last status: $?");
char *expanded = rep_var(input, &datash);
/* expanded = "Last status: 42" */

free(input);
free(expanded);
```

---

**See also**:
- [Architecture Documentation](ARCHITECTURE.md) for system design
- [Examples](EXAMPLES.md) for usage examples
- [Development Guide](DEVELOPMENT.md) for coding guidelines
