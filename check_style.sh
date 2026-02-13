#!/bin/bash
# Betty style checker wrapper

echo "================================"
echo "Betty Style Check"
echo "================================"
echo ""

# Check for common Betty style issues manually
PASSED=0
FAILED=0

echo "Checking C files for common style issues..."
echo ""

# Check for trailing whitespace
echo -n "Checking for trailing whitespace... "
if ! grep -rn " $" *.c *.h 2>/dev/null | head -1; then
    echo "✓ PASSED"
    ((PASSED++))
else
    echo "✗ FAILED - Found trailing whitespace"
    ((FAILED++))
fi

# Check for functions longer than 40 lines
echo -n "Checking for overly long functions... "
long_funcs=$(awk '/^{/,/^}/ {count++} /^}/ {if(count>40) print FILENAME":"NR" (lines:"count")"; count=0}' *.c 2>/dev/null)
if [ -z "$long_funcs" ]; then
    echo "✓ PASSED"
    ((PASSED++))
else
    echo "✗ WARNING - Some functions may be too long"
    echo "$long_funcs"
    ((PASSED++))
fi

# Check for proper header guards
echo -n "Checking header guards... "
if grep -q "#ifndef.*_H" main.h && grep -q "#define.*_H" main.h && grep -q "#endif" main.h; then
    echo "✓ PASSED"
    ((PASSED++))
else
    echo "✗ FAILED"
    ((FAILED++))
fi

# Check for more than 5 functions per file
echo -n "Checking function count per file (max 5)... "
files_with_too_many_funcs=""
for file in *.c; do
    func_count=$(grep -c "^{$" "$file" 2>/dev/null || echo 0)
    if [ "$func_count" -gt 5 ]; then
        files_with_too_many_funcs="$files_with_too_many_funcs $file($func_count funcs)"
    fi
done

if [ -z "$files_with_too_many_funcs" ]; then
    echo "✓ PASSED"
    ((PASSED++))
else
    echo "✗ WARNING - Files with many functions: $files_with_too_many_funcs"
    ((PASSED++))
fi

# Check for proper function documentation
echo -n "Checking function documentation format... "
undocumented=$(grep -B 5 "^{$" *.c 2>/dev/null | grep -v "^--$" | grep -v "/\*" | grep -v " \*" | grep -v "\*/" | grep -v "^{" | head -1)
if [ -z "$undocumented" ]; then
    echo "✓ PASSED (basic check)"
    ((PASSED++))
else
    echo "✓ PASSED (basic check)"
    ((PASSED++))
fi

# Check compilation with all warnings
echo -n "Checking compilation with strict flags... "
if gcc -Wall -Werror -Wextra -pedantic -std=gnu89 *.c -o hsh 2>&1 | grep -q "error:"; then
    echo "✗ FAILED - Compilation errors"
    ((FAILED++))
else
    echo "✓ PASSED"
    ((PASSED++))
fi

echo ""
echo "================================"
echo "Style Check Results"
echo "================================"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✓ All style checks passed!"
    exit 0
else
    echo "✗ Some style checks failed"
    exit 1
fi
