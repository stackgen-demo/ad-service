# AGENTS.md

## Repo purpose
The Ad service provides advertisement based on context keys. If no context keys are provided then it returns random ads.

## Tech stack
- Java
- Docker

## Build / test / lint / run (best-effort)

### Bootstrap
- (not detected; check README/Makefile/package scripts)

### Build
- `./gradlew build -x test`

### Test
- `./gradlew test`

### Lint / format
- (not detected; check README/Makefile/package scripts)

### Run
- (not detected; check README/Makefile/package scripts)

## Project layout (where to look)
- Start with `README.md` and `.github/workflows/`.
- Common conventions (if present): `src/`, `lib/`, `cmd/`, `internal/`, `packages/`.
- Look for build entrypoints: `Makefile`, `package.json`, `go.mod`, `pyproject.toml`.

## CI / workflows
- (none detected)

## Common gotchas
- Some commands above are **best-effort guesses** based on repository signals; prefer README/Makefile/package scripts when they disagree.
- If CI fails, check workflow logs for exact tool versions and required secrets.
