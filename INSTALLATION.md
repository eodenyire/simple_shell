# Installation Guide

Complete installation instructions for Simple Shell.

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Dependencies](#dependencies)
3. [Installation Methods](#installation-methods)
4. [Compilation Options](#compilation-options)
5. [Verification](#verification)
6. [Uninstallation](#uninstallation)
7. [Troubleshooting](#troubleshooting)

## System Requirements

### Minimum Requirements
- **OS**: Ubuntu 20.04 LTS or compatible Linux distribution
- **Compiler**: GCC 9.3.0 or higher
- **RAM**: 512 MB
- **Disk Space**: 10 MB
- **Architecture**: x86_64, i386, ARM

### Recommended Requirements
- **OS**: Ubuntu 20.04 LTS or 22.04 LTS
- **Compiler**: GCC 11.0 or higher
- **RAM**: 1 GB or more
- **Disk Space**: 50 MB (for development tools)

### Supported Platforms
- ✓ Ubuntu 20.04 LTS
- ✓ Ubuntu 22.04 LTS
- ✓ Debian 10+
- ✓ Linux Mint 20+
- ✓ Any Linux distribution with GCC and standard C library

## Dependencies

### Required
- **GCC** - GNU Compiler Collection
- **GNU C Library** (glibc) - Standard C library

### Optional (for development/testing)
- **Valgrind** - Memory leak detection
- **Betty** - Code style checker
- **Git** - Version control
- **Make** - Build automation (optional)

### Installing Dependencies

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y gcc build-essential
```

#### For Testing Tools
```bash
sudo apt-get install -y valgrind git
```

## Installation Methods

### Method 1: Standard Installation (Recommended)

1. **Clone the repository**
```bash
git clone https://github.com/eodenyire/simple_shell.git
cd simple_shell
```

2. **Compile**
```bash
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh
```

3. **Verify installation**
```bash
./hsh --version 2>&1 || echo "Shell compiled successfully"
echo "ls" | ./hsh
```

### Method 2: Download Release (if available)

```bash
wget https://github.com/eodenyire/simple_shell/releases/latest/download/simple_shell.tar.gz
tar -xzf simple_shell.tar.gz
cd simple_shell
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh
```

### Method 3: Install to System Path (Advanced)

```bash
# After compilation
sudo cp hsh /usr/local/bin/simple_shell
sudo chmod +x /usr/local/bin/simple_shell

# Copy man page
sudo mkdir -p /usr/local/share/man/man1
sudo cp man_1_simple_shell /usr/local/share/man/man1/simple_shell.1
sudo mandb

# Now accessible system-wide
simple_shell
```

## Compilation Options

### Standard Compilation
```bash
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh
```

### Debug Build (with symbols)
```bash
gcc -Wall -Wextra -pedantic -std=gnu89 -g *.c -o hsh_debug
```

### Optimized Build
```bash
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 -O2 *.c -o hsh
```

### Static Build (standalone binary)
```bash
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 -static *.c -o hsh_static
```

### Compilation Flags Explained

| Flag | Purpose |
|------|---------|
| `-Wall` | Enable all common warnings |
| `-Werror` | Treat warnings as errors |
| `-Wextra` | Enable extra warnings |
| `-pedantic` | Enforce ISO C standards strictly |
| `-std=gnu89` | Use GNU C89 standard |
| `-g` | Include debugging symbols |
| `-O2` | Optimization level 2 |
| `-static` | Link statically (no shared libraries) |

## Verification

### Basic Verification

```bash
# Check if binary exists and is executable
ls -lh hsh
file hsh

# Test basic functionality
echo "pwd" | ./hsh
```

### Comprehensive Testing

```bash
# Run test suites
./test_shell.sh
./test_advanced.sh
./check_style.sh

# Memory leak check (requires valgrind)
echo -e "ls\npwd\nexit" | valgrind --leak-check=full ./hsh
```

### Expected Output

✓ Binary size: ~40-60 KB
✓ Test results: 32/33 tests passing
✓ Memory leaks: 0
✓ Compilation warnings: 0

## Post-Installation Setup

### Configure PATH (Optional)

Add to your `~/.bashrc` or `~/.profile`:
```bash
export PATH="$PATH:/path/to/simple_shell"
```

### Set as Default Shell (Not Recommended)

⚠️ **Warning**: This is for testing only!

```bash
# Add to /etc/shells
echo "/path/to/simple_shell/hsh" | sudo tee -a /etc/shells

# Change default shell (NOT RECOMMENDED for production)
chsh -s /path/to/simple_shell/hsh
```

## Uninstallation

### Remove Binary
```bash
rm hsh
```

### Remove System Installation
```bash
sudo rm /usr/local/bin/simple_shell
sudo rm /usr/local/share/man/man1/simple_shell.1
sudo mandb
```

### Complete Cleanup
```bash
cd ..
rm -rf simple_shell
```

## Troubleshooting

### Compilation Fails

**Problem**: `gcc: command not found`
```bash
# Install GCC
sudo apt-get install gcc
```

**Problem**: Compilation errors about missing functions
```bash
# Make sure all .c files are present
ls *.c | wc -l  # Should show 30+ files
```

**Problem**: `Betty` style errors
```bash
# These are style warnings, not critical
# Fix or compile without -Werror temporarily
gcc -Wall -Wextra -pedantic -std=gnu89 *.c -o hsh
```

### Runtime Issues

**Problem**: Shell doesn't start
```bash
# Check permissions
chmod +x hsh
./hsh
```

**Problem**: Commands not found
```bash
# Check PATH
echo "env | grep PATH" | ./hsh
```

**Problem**: Segmentation fault
```bash
# Run with debugger
gdb ./hsh
run
bt  # Shows backtrace after crash
```

### Memory Issues

**Problem**: Memory leaks reported
```bash
# Run with valgrind for detailed analysis
valgrind --leak-check=full --show-leak-kinds=all ./hsh
```

## Platform-Specific Notes

### Ubuntu 20.04 LTS
- Default GCC version: 9.3.0 ✓
- All features work out of the box

### Ubuntu 22.04 LTS
- Default GCC version: 11.2.0 ✓
- May show additional warnings (still compiles)

### macOS
- Use `clang` instead of `gcc`
- Some features may not work identically
- Not officially supported

### Windows (WSL)
- Install Ubuntu on WSL
- Follow Ubuntu instructions
- Generally works well

## Additional Resources

- **Quick Start**: See [QUICKSTART.md](QUICKSTART.md)
- **Usage Examples**: See [EXAMPLES.md](EXAMPLES.md)
- **Development Setup**: See [DEVELOPMENT.md](DEVELOPMENT.md)
- **Common Issues**: See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Getting Help

If you encounter issues during installation:

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Review test output: `./test_shell.sh`
3. Check system requirements above
4. Open an issue on GitHub with:
   - OS version: `lsb_release -a`
   - GCC version: `gcc --version`
   - Error message
   - Steps to reproduce

---

**Installation complete?** Run `./hsh` to start the shell! 🚀
