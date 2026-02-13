# Quick Start Guide

Get up and running with Simple Shell in less than 5 minutes!

## Prerequisites

- Ubuntu 20.04 LTS (or compatible Linux distribution)
- GCC compiler
- Make (optional)
- Git (for cloning the repository)

## Quick Installation

### 1. Clone the Repository

```bash
git clone https://github.com/eodenyire/simple_shell.git
cd simple_shell
```

### 2. Compile the Shell

```bash
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh
```

### 3. Run the Shell

```bash
./hsh
```

That's it! You now have a working shell. 🎉

## First Commands

Try these basic commands:

```bash
$ pwd                    # Show current directory
$ ls                     # List files
$ echo "Hello World"     # Print text
$ env                    # Show environment variables
$ exit                   # Exit the shell
```

## Interactive vs Non-Interactive Mode

### Interactive Mode (Terminal)
```bash
$ ./hsh
$ ls -la
$ pwd
$ exit
```

### Non-Interactive Mode (Pipe commands)
```bash
$ echo "ls -la" | ./hsh
$ echo -e "pwd\nls\nexit" | ./hsh
```

## Built-in Commands

| Command | Description | Example |
|---------|-------------|---------|
| `exit` | Exit the shell | `exit` or `exit 0` |
| `env` | Display environment variables | `env` |
| `cd` | Change directory | `cd /tmp` |
| `setenv` | Set environment variable | `setenv VAR value` |
| `unsetenv` | Unset environment variable | `unsetenv VAR` |
| `help` | Show help for commands | `help cd` |

## Quick Examples

### Navigate directories
```bash
$ cd /tmp          # Go to /tmp
$ pwd              # Show current location
$ cd -             # Go back to previous directory
$ cd               # Go to home directory
```

### Work with environment variables
```bash
$ env              # Show all variables
$ setenv MY_VAR test_value
$ env | grep MY_VAR
$ unsetenv MY_VAR
```

### Chain commands
```bash
$ ls ; pwd         # Run both commands
$ echo "first" && echo "second"    # Run second if first succeeds
$ false_cmd || echo "fallback"     # Run second if first fails
```

## Testing Your Installation

Run the test suites to verify everything works:

```bash
# Basic tests
./test_shell.sh

# Advanced tests
./test_advanced.sh

# Style check
./check_style.sh
```

All tests should pass! ✓

## Getting Help

- **Man page**: `man ./man_1_simple_shell`
- **Built-in help**: `help` or `help <command>`
- **Full documentation**: See README.md
- **Troubleshooting**: See TROUBLESHOOTING.md

## Next Steps

Now that you have the shell running, explore more:

- Read [EXAMPLES.md](EXAMPLES.md) for more usage examples
- Check [ARCHITECTURE.md](ARCHITECTURE.md) to understand how it works
- See [CONTRIBUTING.md](CONTRIBUTING.md) if you want to contribute
- Review [API_REFERENCE.md](API_REFERENCE.md) for function details

---

**Need more details?** See the full [Installation Guide](INSTALLATION.md) for advanced setup options.
