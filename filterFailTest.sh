#!/bin/bash

failed_tests_file="failed_tests.txt"

# If the file does not exist or is empty, run go test ./... and generate the file
if [ ! -s "$failed_tests_file" ]; then
  echo "Running go test ./... to generate the failed_tests.txt file"
  go test -count=1 -json ./... | jq -r 'select(.Action=="fail" and has("Test"))|.Test' > "$failed_tests_file"
fi

# Run the tests excluding the failed tests
if [ -s "$failed_tests_file" ]; then
  # Read failed_tests.txt and store failed tests in an array
  failed_tests=()
  while IFS= read -r line; do
    failed_tests+=("$line")
  done < "$failed_tests_file"
  
  # Run all tests except the ones listed in the failed_tests array
  for pkg in $(go list ./...); do
    test_filter=$(go test -list ".*" "$pkg" | grep -v -F -x -f "$failed_tests_file" | tr '\n' '|' | sed 's/|$//')
    echo test_filter: "$test_filter"
    if [ -n "$test_filter" ]; then
      go test -count=1 -v -run "$test_filter" "$pkg"
    fi
  done
else
  # If the file is empty, run all tests
  go test ./...
fi
