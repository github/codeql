# Unpinned tag for 3rd party Action in workflow

## Description

Using a tag for a 3rd party Action that is not pinned to a commit can lead to executing an untrusted Action through a supply chain attack.

## Recommendations

Pinning an action to a full length commit SHA is currently the only way to use a non-immutable action as an immutable release. Pinning to a particular SHA helps mitigate the risk of a bad actor adding a backdoor to the action's repository, as they would need to generate a SHA-1 collision for a valid Git object payload. When selecting a SHA, you should verify it is from the action's repository and not a repository fork.

## Examples

### Incorrect Usage

```yaml
- uses: tj-actions/changed-files@v44
```

### Correct Usage

```yaml
- uses: tj-actions/changed-files@c65cd883420fd2eb864698a825fc4162dd94482c # v44
```

## References

- [Using third-party actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions#using-third-party-actions)
- [Extending CodeQL coverage with CodeQL model packs in default setup](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/editing-your-configuration-of-default-setup#extending-codeql-coverage-with-codeql-model-packs-in-default-setup)
- [Creating and working with CodeQL packs](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack)

