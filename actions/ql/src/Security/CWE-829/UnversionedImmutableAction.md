# Unversioned Immutable Action

## Description

Using an immutable action without indicating proper semantic version will result in the version being resolved to a tag that is mutable. This means the action code can change between runs and without the user's knowledge. Using an immutable action with proper semantic versioning will resolve to the exact version
of the action stored in the GitHub package registry. The action code will not change between runs.

## Recommendations

When using [immutable actions](https://github.com/github/package-registry-team/blob/main/docs/immutable-actions/immutable-actions-howto.md) use the full semantic version of the action. This will ensure that the action is resolved to the exact version stored in the GitHub package registry. This will prevent the action code from changing between runs.

## Examples

### Incorrect Usage

```yaml
- uses: actions/checkout@some-tag
- uses: actions/checkout@2.x.x
```

### Correct Usage

```yaml
- uses: actions/checkout@4.0.0
```

## References

- [Consuming immutable actions]()
