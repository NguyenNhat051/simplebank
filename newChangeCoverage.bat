@echo off

REM Run tests with coverage enabled
go test -coverprofile=coverage .\... > NUL

REM Get a list of new or changed files compared to the last commit
FOR /F "tokens=*" %%i IN ('git diff --name-only --cached') DO SET staged_files=!staged_files! %%i
FOR /F "tokens=*" %%i IN ('git diff --name-only') DO SET unstaged_files=!unstaged_files! %%i
FOR /F "tokens=*" %%i IN ('git ls-files --others --exclude-standard') DO SET untracked_files=!untracked_files! %%i

REM Combine all file lists into one
SET changed_files=%staged_files% %unstaged_files% %untracked_files%

REM Filter the coverage report to only include new or changed files
FOR %%i IN (%changed_files%) DO (
  IF "%%~xi"==".go" (
    go tool cover -func=coverage | findstr "%%i"
  )
)
