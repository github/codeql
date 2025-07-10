# Excessive Secrets Exposure

## Description

When the workflow runner cannot determine what secrets are needed to run the workflow, it will pass all the available secrets to the runner including organization and repository secrets. This violates the least privileged principle and increases the impact of a potential vulnerability affecting the workflow.

## Recommendations

Only pass those secrets that are needed by the workflow. Avoid using expressions such as `toJSON(secrets)` or dynamically accessed secrets such as `secrets[format('GH_PAT_%s', matrix.env)]` since the workflow will need to receive all secrets to decide at runtime which one needs to be used.

## Examples

### Incorrect Usage

```yaml
env:
  ALL_SECRETS: ${{ toJSON(secrets) }}
```

```yaml
strategy:
  matrix:
    env: [PROD, DEV]
env:
  GH_TOKEN: ${{ secrets[format('GH_PAT_%s', matrix.env)] }}
```

### Correct Usage

```yaml
env:
  NEEDED_SECRET: ${{ secrets.GH_PAT }}
```

```yaml
strategy:
  matrix:
    env: [PROD, DEV]
---
if: matrix.env == "PROD"
env:
  GH_TOKEN: ${{ secrets.GH_PAT_PROD }}
---
if: matrix.env == "DEV"
env:
  GH_TOKEN: ${{ secrets.GH_PAT_DEV }}
```

## References

- [Using secrets in GitHub Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#using-encrypted-secrets-in-a-workflow)
- [Job uses all secrets](https://github.com/boostsecurityio/poutine/blob/main/docs/content/en/rules/job_all_secrets.md)
