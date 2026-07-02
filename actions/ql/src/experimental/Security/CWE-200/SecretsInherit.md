## Overview

When calling a reusable workflow with `secrets: inherit`, every secret the calling workflow can access (organization, repository, and environment secrets) is forwarded to the callee. This is convenient but broader than most callees require. If the reusable workflow has a vulnerability — for example, a template-injection flaw — the blast radius includes every inherited secret rather than just the ones it actually uses.

## Recommendation

As a defense-in-depth measure, prefer passing only the secrets the reusable workflow needs via an explicit `secrets:` block.

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
