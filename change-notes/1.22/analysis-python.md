# Improvements to Python analysis


## General improvements

### Points-to
Tracking of "unknown" values from modules that are absent from the database has been improved. Particularly when an "unknown" value is used as a decorator, the decorated function is tracked.

### Loop unrolling
The extractor now unrolls a single iteration of loops that are known to run at least once. This improves analysis in cases like the following

```python
if seq:
    for x in seq:
        y = x
    y  # y is defined here
```

### Better API for function parameter annotations
Instances of the `Parameter` and `ParameterDefinition` class now have a `getAnnotation` method that returns the corresponding parameter annotation, if one exists.

### Improvements to the Value API
- The Value API has been extended with classes representing functions, classes, tuples, and other types.

- `Value::forInt(int x)` and `Value::forString(string s)` have been added to make it easier to refer to the `Value` entities for common constants.

### Other improvements

- Short flags for regexes (for example, `re.M` for multiline regexes) are now handled correctly.
- Modules with multiple import roots no longer get multiple names.
- A new `NegativeIntegerLiteral` class has been added as a subtype of `ImmutableLiteral`, so that `-1` is treated as an `ImmutableLiteral`. This means that queries looking for the use of constant integers will automatically handle negative numbers.

## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Arbitrary file write during tarfile extraction (`py/tarslip`) | security, external/cwe/cwe-022 | Finds instances where extracting from a tar archive can result in arbitrary file writes. Results are not shown on LGTM by default. |

