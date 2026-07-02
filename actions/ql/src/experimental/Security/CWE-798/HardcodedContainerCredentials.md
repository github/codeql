## Overview

Hardcoding credentials (passwords) in GitHub Actions workflow `container` or `services` configurations embeds secrets directly in the repository source code. Anyone with read access to the repository can see these credentials.

## Recommendation

Use [encrypted secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions) instead of hardcoded credentials.

## Example

### Incorrect Usage

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: registry.example.com/app
      credentials:
        username: user
        password: hackme
    steps:
      - run: echo 'hello'
```

### Correct Usage

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: registry.example.com/app
      credentials:
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_PASSWORD }}
    steps:
      - run: echo 'hello'
```

## References

- GitHub Docs: [Using encrypted secrets in a workflow](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions).
- Zizmor: [hardcoded-container-credentials](https://docs.zizmor.sh/audits/#hardcoded-container-credentials).
