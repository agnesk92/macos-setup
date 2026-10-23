# Patterns for Decomposing Features into TDD Increments

## General Strategy

1. **Start with the degenerate case** — empty input, zero, nil, no-op
2. **Add the simplest happy path** — one item, minimal valid input
3. **Add variations** — multiple items, different valid inputs
4. **Add edge cases** — boundaries, limits, special characters
5. **Add error cases** — invalid input, missing data, failure modes
6. **Add integration** — combine with other components if needed

## Decomposition Patterns

### Pattern: Data Transformation
Example: "Parse CSV into records"
1. Empty input returns empty list
2. Single row with one field
3. Single row with multiple fields
4. Multiple rows
5. Quoted fields with commas
6. Missing/empty fields
7. Malformed input raises error

### Pattern: CRUD Resource
Example: "User management API"
1. Create with valid data returns entity
2. Create with missing required field raises error
3. Read existing entity by ID
4. Read non-existent entity returns not-found
5. Update existing entity
6. Update non-existent entity returns not-found
7. Delete existing entity
8. Delete non-existent entity is idempotent

### Pattern: State Machine / Workflow
Example: "Order lifecycle"
1. Initial state is correct on creation
2. Valid transition from state A to B
3. Invalid transition from state A to C raises error
4. Each subsequent valid transition
5. Terminal state rejects further transitions
6. Side effects on specific transitions

### Pattern: Calculation / Algorithm
Example: "Discount calculator"
1. Zero/base case returns identity value
2. Single simple input
3. Known computed example
4. Boundary at threshold
5. Multiple inputs combined
6. Overflow / precision edge case

### Pattern: Integration / Adapter
Example: "HTTP client wrapper"
1. Successful request returns parsed data
2. Connection error is handled
3. Timeout is handled
4. Non-200 status is handled
5. Malformed response body is handled
6. Retry logic (if applicable)

## Language-Specific Notes

### Python
- Each increment maps to one `test_` function in a `test_*.py` file
- Group related increments in a test class if they share setup

### TypeScript
- Each increment maps to one `it()` or `test()` block
- Group in `describe()` blocks by increment group

### Go
- Each increment maps to one `func Test*(t *testing.T)` or a subtest via `t.Run()`
- Use table-driven tests when increments share structure
