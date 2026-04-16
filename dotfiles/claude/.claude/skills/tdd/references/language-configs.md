# Language & Test Framework Configurations

## Python (pytest)

- **Test runner:** `python -m pytest -xvs`
  - `-x` stop on first failure (useful in Red phase)
  - `-v` verbose output
  - `-s` show print output
- **Run single test:** `python -m pytest -xvs path/to/test_file.py::test_name`
- **Run all tests:** `python -m pytest -xvs`
- **Test file naming:** `test_*.py` or `*_test.py`
- **Test function naming:** `def test_*():`
- **Import pattern:** `from module_name import ClassName, function_name`
- **Project structure:**
  ```
  src/
    module_name/
      __init__.py
      feature.py
  tests/
    test_feature.py
  ```
- **Assertion style:** Plain `assert` statements (pytest rewrites them for good diffs)

## TypeScript (vitest)

- **Test runner:** `npx vitest run`
- **Run single test:** `npx vitest run path/to/file.test.ts -t "test name"`
- **Run all tests:** `npx vitest run`
- **Watch mode (don't use in skill):** `npx vitest`
- **Test file naming:** `*.test.ts` or `*.spec.ts`
- **Test function naming:** `test('description', () => {})` or `it('description', () => {})`
- **Import pattern:** `import { thing } from './module'`
- **Project structure:**
  ```
  src/
    feature.ts
    feature.test.ts    # co-located
  ```
  or
  ```
  src/
    feature.ts
  tests/
    feature.test.ts    # separate directory
  ```
- **Assertion style:** `expect(value).toBe(expected)`, `expect(fn).toThrow()`

## Go (testing)

- **Test runner:** `go test -v -run TestName ./path/to/package`
- **Run single test:** `go test -v -run ^TestFunctionName$ ./path/to/package`
- **Run all tests:** `go test -v ./...`
- **Test file naming:** `*_test.go` (same package directory)
- **Test function naming:** `func TestFeatureName(t *testing.T)`
- **Import pattern:** Standard Go imports
- **Project structure:**
  ```
  package/
    feature.go
    feature_test.go    # always co-located in Go
  ```
- **Assertion style:** `if got != want { t.Errorf("got %v, want %v", got, want) }`
- **Note:** Consider suggesting `testify/assert` if already in go.mod
