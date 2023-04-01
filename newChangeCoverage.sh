# Run tests with coverage enabled
go test -coverprofile=coverage.out ./... > /dev/null
#go test -coverprofile=coverage.out .\... > NUL   // Windows

# Get a list of new or changed files compared to the last commit
staged_files=$(git diff --name-only --cached)
unstaged_files=$(git diff --name-only)
untracked_files=$(git ls-files --others --exclude-standard)

# Combine all file lists into one
changed_files=$(echo "$staged_files" "$unstaged_files" "$untracked_files")

# Filter the coverage report to only include new or changed files
for file in $changed_files; do
  if [[ $file == *.go ]]; then
    go tool cover -func=coverage.out | grep "$file"
  fi
done
