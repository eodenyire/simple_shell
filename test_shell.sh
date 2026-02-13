#!/bin/bash
# Comprehensive test script for simple_shell

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

echo "================================"
echo "Simple Shell Test Suite"
echo "================================"
echo ""

# Helper function to run a test
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_exit="$3"
    
    echo -n "Testing: $test_name... "
    
    output=$(echo "$command" | ./hsh 2>&1)
    exit_code=$?
    
    if [ "$exit_code" -eq "$expected_exit" ]; then
        echo -e "${GREEN}PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}FAILED${NC} (expected exit code $expected_exit, got $exit_code)"
        ((FAILED++))
        return 1
    fi
}

# Helper function to run a test and check output
run_test_output() {
    local test_name="$1"
    local command="$2"
    local expected_pattern="$3"
    
    echo -n "Testing: $test_name... "
    
    output=$(echo "$command" | ./hsh 2>&1)
    
    if echo "$output" | grep -q "$expected_pattern"; then
        echo -e "${GREEN}PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}FAILED${NC} (output did not match expected pattern)"
        echo "Expected pattern: $expected_pattern"
        echo "Got: $output"
        ((FAILED++))
        return 1
    fi
}

echo "=== Basic Command Tests ==="
run_test "Simple command (ls)" "ls" 0
run_test "Command with argument (ls -l)" "ls -l" 0
run_test "pwd command" "pwd" 0
run_test "echo command" "echo hello world" 0

echo ""
echo "=== Built-in Commands ==="
run_test "env command" "env" 0
run_test "exit command" "exit" 0
run_test "exit with status" "exit 0" 0

echo ""
echo "=== PATH Resolution ==="
run_test "Absolute path" "/bin/ls" 0

echo ""
echo "=== Error Handling ==="
run_test "Non-existent command" "nonexistentcommand123" 127
run_test_output "Command not found message" "nonexistentcommand123" "not found"

echo ""
echo "=== Multiple Commands ==="
run_test "Semicolon separator" "ls ; pwd" 0
run_test_output "Multiple commands output" "echo first ; echo second" "first"

echo ""
echo "=== Environment Variables ==="
run_test_output "Environment variable in output" "env" "PATH"
run_test_output "HOME variable exists" "env" "HOME"

echo ""
echo "=== Edge Cases ==="
run_test "Empty lines" "" 0
run_test "Spaces only" "   " 0
run_test "Multiple spaces" "ls     -l" 0

echo ""
echo "=== Comment Handling ==="
run_test_output "Comment after command" "echo hello # this is a comment" "hello"
run_test "Comment only line" "# just a comment" 0

echo ""
echo "================================"
echo "Test Results"
echo "================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo "Total: $((PASSED + FAILED))"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed! ✓${NC}"
    exit 0
else
    echo -e "${YELLOW}Some tests failed.${NC}"
    exit 1
fi
