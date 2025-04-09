# Unversioned Immutable Action

## Description

This action is eligible for Immutable Actions, a new GitHub feature that is currently only available for internal users. Immutable Actions are released as packages in the GitHub package registry instead of resolved from a pinned SHA at the repository. The Immutable Action provides the same immutability as pinning the version to a SHA but with improved readability and additional security guarantees.

## Recommendations

For internal users: when using [immutable actions](https://github.com/github/package-registry-team/blob/main/docs/immutable-actions/immutable-actions-howto.md) use the full semantic version of the action. This will ensure that the action is resolved to the exact version stored in the GitHub package registry.

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
