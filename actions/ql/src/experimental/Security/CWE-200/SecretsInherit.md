## Overview

When calling a reusable workflow with `secrets: inherit`, all organization, repository, and environment secrets from the parent workflow are forwarded to the called workflow. This violates the principle of least privilege and increases the impact of a potential vulnerability in the reusable workflow.

## Recommendation

Instead of using `secrets: inherit`, explicitly pass only the secrets that the reusable workflow actually needs via a `secrets:` block.

## Example

### Incorrect Usage

```yaml
jobs:
  call-workflow:
    uses: org/repo/.github/workflows/reusable.yml@main
    secrets: inherit
```

### Correct Usage

```yaml
jobs:
  call-workflow:
    uses: org/repo/.github/workflows/reusable.yml@main
    secrets:
      API_KEY: ${{ secrets.API_KEY }}
```

## References

- GitHub Docs: [Passing secrets to reusable workflows](https://docs.github.com/en/actions/sharing-automations/reusing-workflows#passing-inputs-and-secrets-to-a-reusable-workflow).
- Zizmor: [secrets-inherit](https://docs.zizmor.sh/audits/#secrets-inherit).
