# Unmasked Secret Exposure

## Description

Secrets derived from other secrets are not know to the workflow runner and therefore not masked unless explicitly registered.

## Recommendations

Avoid defining non-plain secrets. For example, do not define a new secret containing a JSON object and then read properties out of it from the workflow since these read values will not be masked by the workflow runner.

## Examples

### Incorrect Usage

```yaml
- env:
    username: ${{ fromJson(secrets.AZURE_CREDENTIALS).clientId }}
    password: ${{ fromJson(secrets.AZURE_CREDENTIALS).clientSecret }}
  run: |
    echo "$username"
    echo "$password"
```

### Correct Usage

```yaml
- env:
    username: ${{ secrets.AZURE_CREDENTIALS_CLIENT_ID }}
    password: ${{ secrets.AZURE_CREDENTIALS_CLIENT_SECRET }}
  run: |
    echo "$username"
    echo "$password"
```

## References

- [Using secrets in GitHub Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#using-encrypted-secrets-in-a-workflow)
