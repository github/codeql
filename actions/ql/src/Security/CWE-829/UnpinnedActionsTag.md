## Overview

Using a mutable tag or branch for an Action or reusable workflow can lead to executing untrusted code through a supply chain attack.

## Recommendation

Pinning an Action or reusable workflow to a full length commit SHA is currently the only way to use a mutable reference as an immutable release. Pinning to a particular SHA helps mitigate the risk of a bad actor adding a backdoor to the referenced repository, as they would need to generate a SHA-1 collision for a valid Git object payload. When selecting a SHA, you should verify it is from the intended repository and not a repository fork.

## Example

### Incorrect Usage

```yaml
- uses: tj-actions/changed-files@v44
```

```yaml
jobs:
  call-workflow:
    uses: example/actions/.github/workflows/build.yml@main
```

### Correct Usage

```yaml
- uses: tj-actions/changed-files@c65cd883420fd2eb864698a825fc4162dd94482c # v44
```

```yaml
jobs:
  call-workflow:
    uses: example/actions/.github/workflows/build.yml@25b062c917b0c75f8b47d8469aff6c94ffd89abb
```

## References

- GitHub Docs: [Using third-party actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions#using-third-party-actions).
- GitHub Docs: [Reusing third-party workflows](https://docs.github.com/en/actions/reference/security/secure-use#reusing-third-party-workflows).
- GitHub Docs: [Workflow syntax for reusable workflow calls](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#jobsjob_iduses).
