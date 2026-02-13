# System Architecture

Technical documentation of the Simple Shell architecture and design.

## Table of Contents

1. [Overview](#overview)
2. [System Design](#system-design)
3. [Module Structure](#module-structure)
4. [Data Flow](#data-flow)
5. [Key Components](#key-components)
6. [Design Decisions](#design-decisions)
7. [Performance Considerations](#performance-considerations)

## Overview

Simple Shell is a lightweight UNIX command interpreter implemented in C (GNU89 standard). It consists of approximately 2,800 lines of code organized into 35+ files.

### Architecture Principles

- **Modularity**: Separate concerns into distinct files
- **Simplicity**: Keep functions focused and under 40 lines
- **POSIX Compliance**: Follow UNIX standards where applicable
- **Safety**: Prevent memory leaks and buffer overflows
- **Efficiency**: Minimize overhead in command execution

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     User Interface                       │
│                    (Terminal/Pipe)                       │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    Main Shell Loop                       │
│                  (shell_loop.c)                         │
│  ┌────────────┐  ┌────────────┐  ┌───────────────┐    │
│  │   Prompt   │─▶│   Input    │─▶│ Preprocessing │    │
│  └────────────┘  └────────────┘  └───────────────┘    │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   Input Processing                       │
│                                                          │
│  ┌────────────┐  ┌────────────┐  ┌───────────────┐    │
│  │  Tokenize  │─▶│ Parse Args │─▶│Syntax Check   │    │
│  │ (split.c)  │  │  (split.c) │  │(check_syntax) │    │
│  └────────────┘  └────────────┘  └───────────────┘    │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              Command Resolution & Execution              │
│                                                          │
│  ┌────────────┐  ┌────────────┐  ┌───────────────┐    │
│  │  Builtin?  │  │ PATH Search│  │  Fork/Exec    │    │
│  │(get_builtin│─▶│ (_which)   │─▶│  (cmd_exec)   │    │
│  └────────────┘  └────────────┘  └───────────────┘    │
└─────────────────────────────────────────────────────────┘
```

## System Design

### Process Model

```
Parent Process (Shell)
│
├─ Read Input
├─ Parse Commands
├─ Check for Built-ins
│  ├─ If builtin: Execute in parent
│  └─ If external: Fork
│     └─ Child Process
│        ├─ Resolve PATH
│        ├─ execve()
│        └─ Exit
└─ Wait for child (if forked)
```

### Memory Model

```
Stack
├─ Local variables
├─ Function parameters
└─ Return addresses

Heap
├─ Input buffer (malloc)
├─ Argument array (malloc)
├─ Environment copy (malloc)
└─ PATH resolution (malloc)

Static/Global
├─ extern char **environ
└─ Global configuration
```

## Module Structure

### Core Modules

#### 1. Main Entry Point
**File**: `main.c`
```
main()
├─ Initialize data structure
├─ Copy environment
├─ Set up signal handlers
├─ Call shell_loop()
└─ Cleanup and exit
```

#### 2. Shell Loop
**File**: `shell_loop.c`
```
shell_loop()
├─ Display prompt
├─ Read input (read_line)
├─ Remove comments
├─ Check syntax
├─ Variable expansion
├─ Split commands
└─ Execute each command
```

#### 3. Input Processing
**Files**: `read_line.c`, `get_line.c`
```
read_line()
└─ getline() wrapper
    ├─ Read from stdin
    ├─ Handle EOF
    └─ Return input string
```

#### 4. Parsing & Tokenization
**File**: `split.c`
```
split_commands()
├─ Identify separators (;, &&, ||)
├─ Build command list
└─ Build separator list

split_line()
├─ Tokenize on whitespace
└─ Build argument array
```

#### 5. Syntax Checking
**File**: `check_syntax_error.c`
```
check_syntax_error()
├─ Check repeated separators
├─ Check invalid separator placement
└─ Print error messages
```

#### 6. Variable Expansion
**File**: `rep_var.c`
```
rep_var()
├─ Find $ variables
├─ Replace $? (status)
├─ Replace $$ (PID)
└─ Replace $VAR (environment)
```

#### 7. Command Execution
**File**: `cmd_exec.c`
```
cmd_exec()
├─ Check if executable path
├─ Search PATH (_which)
├─ Fork process
├─ Child: execve
└─ Parent: wait for child
```

#### 8. Built-in Commands
**Files**: `get_builtin.c`, `exit_shell.c`, `env1.c`, `cd.c`, etc.
```
get_builtin()
├─ Match command name
└─ Return function pointer

Builtin functions:
├─ exit_shell()
├─ _env()
├─ cd_shell()
├─ _setenv()
├─ _unsetenv()
└─ get_help()
```

### Helper Modules

#### String Utilities
**Files**: `aux_str.c`, `aux_str2.c`, `aux_str3.c`
- _strlen, _strcmp, _strcpy
- _strcat, _strchr, _strspn
- _strdup, _strtok
- String manipulation functions

#### Memory Management
**File**: `aux_mem.c`
- _memcpy
- _realloc
- _reallocdp (realloc for double pointers)

#### Standard Library
**File**: `aux_stdlib.c`
- _atoi (string to integer)
- aux_itoa (integer to string)
- get_len (digit count)

#### List Management
**Files**: `aux_lists.c`, `aux_lists2.c`
- Separator list functions
- Line list functions
- Variable list functions

#### Error Handling
**Files**: `aux_error1.c`, `aux_error2.c`, `get_error.c`
- Error message generation
- Error formatting
- Error display

## Data Flow

### Interactive Mode Flow

```
1. User Input
   └─▶ "ls -la ; pwd && echo done"

2. Read Input
   └─▶ read_line() returns string

3. Preprocessing
   ├─ Remove comments: without_comment()
   └─ Check syntax: check_syntax_error()

4. Variable Expansion
   └─ rep_var() replaces $?, $$, $VAR

5. Command Splitting
   └─ split_commands() creates:
      ├─ Command list: ["ls -la", "pwd", "echo done"]
      └─ Separator list: [';', '&&']

6. Execution Loop
   For each command:
   ├─ split_line() → ["ls", "-la"]
   ├─ get_builtin() checks if builtin
   ├─ If builtin: execute directly
   ├─ If external:
   │  ├─ _which() finds in PATH
   │  ├─ fork()
   │  ├─ execve() in child
   │  └─ wait() in parent
   └─ Check separator logic for next command

7. Status Update
   └─ Update datash->status

8. Loop
   └─ Return to step 1
```

### Non-Interactive Mode Flow

```
1. Pipe Input
   └─▶ echo "ls" | ./hsh

2. Read Input
   └─ read_line() reads from pipe
   └─ EOF detected → exit

3-7. Same as interactive mode

8. Exit
   └─ When EOF reached
```

## Key Components

### Data Structure

```c
typedef struct data
{
    char **av;        /* Argument vector */
    char *input;      /* Current input line */
    char **args;      /* Parsed arguments */
    int status;       /* Last command status */
    int counter;      /* Line counter */
    char **_environ;  /* Environment copy */
    char *pid;        /* Shell PID string */
} data_shell;
```

### Linked Lists

```c
/* Separator list */
typedef struct sep_list_s
{
    char separator;
    struct sep_list_s *next;
} sep_list;

/* Command line list */
typedef struct line_list_s
{
    char *line;
    struct line_list_s *next;
} line_list;

/* Variable list */
typedef struct r_var_list
{
    int len_var;
    char *val;
    int len_val;
    struct r_var_list *next;
} r_var;
```

### Builtin Structure

```c
typedef struct builtin_s
{
    char *name;
    int (*f)(data_shell *datash);
} builtin_t;
```

## Design Decisions

### Why This Architecture?

1. **Modularity**: Easy to maintain and extend
2. **Separation of Concerns**: Each file has a specific purpose
3. **Testability**: Components can be tested independently
4. **Betty Compliance**: Maximum 5 functions per file
5. **Performance**: Minimal overhead in common paths

### PATH Resolution

```
_which() algorithm:
1. Check if command starts with '/' or './'
   ├─ Yes: Try to execute directly
   └─ No: Continue to step 2
2. Get PATH environment variable
3. Split PATH into directories
4. For each directory:
   ├─ Construct full path: dir + "/" + command
   ├─ Check if file exists (stat)
   └─ If exists and executable: return path
5. If not found: return NULL
```

### Command Execution

```
Fork/Exec Pattern:
1. Parent forks child process
2. In child:
   ├─ Resolve command path
   ├─ Call execve()
   └─ If execve fails: exit with error
3. In parent:
   ├─ Wait for child to complete
   └─ Capture exit status
```

### Built-in Execution

```
Builtin commands run in parent:
1. Match command name
2. Call corresponding function
3. Function modifies shell state
4. Returns to main loop
```

## Performance Considerations

### Optimization Strategies

1. **Minimize Allocations**
   - Reuse buffers when possible
   - Free immediately after use

2. **Fast PATH Lookup**
   - Cache last successful PATH
   - Early return for absolute paths

3. **Efficient Tokenization**
   - Single pass parsing
   - In-place string modification

4. **Small Binary**
   - No external dependencies
   - Static linking possible

### Memory Management

```
Allocation Strategy:
- Input buffer: Allocated per read, freed after processing
- Arguments: Allocated per command, freed after execution
- Environment: Copied once at startup, freed at exit
- PATH search: Allocated, freed immediately after use
```

### Time Complexity

| Operation | Complexity | Notes |
|-----------|------------|-------|
| Read input | O(n) | n = input length |
| Tokenize | O(n) | Linear scan |
| PATH search | O(m*k) | m = PATH entries, k = stat calls |
| Builtin lookup | O(1) | Array lookup |
| Fork/exec | O(1) | System call overhead |

## Security Considerations

### Input Validation

- Maximum input length check
- Null terminator verification
- Buffer overflow prevention

### Memory Safety

- All allocations checked for NULL
- Proper cleanup on error paths
- No use-after-free

### Environment Security

- Environment copy (don't modify original)
- Validate environment variable names
- Sanitize user input

## Extension Points

### Adding New Built-ins

1. Implement function in new file
2. Add prototype to `main.h`
3. Add entry to builtin table in `get_builtin.c`
4. Add help text in `aux_help.c`

### Adding New Features

1. Syntax: Modify `check_syntax_error.c`
2. Parsing: Modify `split.c`
3. Execution: Modify `exec_line.c` or `cmd_exec.c`

---

**See also**:
- [API Reference](API_REFERENCE.md) for function details
- [Development Guide](DEVELOPMENT.md) for coding guidelines
