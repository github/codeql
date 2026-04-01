## Overview

The GitHub Actions `contains()` function behaves differently depending on the type of its first argument. When the first argument is a string, `contains()` performs a substring match rather than an exact membership check. This can be bypassed by an attacker who crafts a value that happens to be a substring of the target string.

For example, the condition `contains('refs/heads/main refs/heads/develop', github.ref)` would also match `github.ref` values like `refs/heads/mai` or `refs/heads/evelop`, because these are substrings of the target string.

## Recommendation

Use `fromJSON()` to pass an array as the first argument to `contains()`, which performs an exact array membership check:

```yaml
if: contains(fromJSON('["refs/heads/main", "refs/heads/develop"]'), github.ref)
```

Alternatively, use explicit equality checks combined with logical OR:

```yaml
if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop'
```

## Example

### Incorrect Usage

```yaml
steps:
  - run: terraform apply
    if: contains('refs/heads/main refs/heads/develop', github.ref)
```

### Correct Usage

```yaml
steps:
  - run: terraform apply
    if: contains(fromJSON('["refs/heads/main", "refs/heads/develop"]'), github.ref)
```

## References

- GitHub Docs: [contains() function](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/evaluate-expressions-in-workflows-and-actions#contains).
- Zizmor: [unsound-contains](https://docs.zizmor.sh/audits/#unsound-contains).
