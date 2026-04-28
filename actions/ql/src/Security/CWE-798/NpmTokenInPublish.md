## Overview

The publish step sets `NODE_AUTH_TOKEN` (or `NPM_TOKEN`) from a GitHub Actions secret (`secrets.*`). This is a long-lived credential that can be stolen and used to publish malicious versions from outside the CI/CD pipeline, as demonstrated by the axios@1.14.1 supply chain attack.

## Recommendation

Remove `NODE_AUTH_TOKEN` from the publish step. Configure npm Trusted Publishing (OIDC) on npmjs.com, pointing to this repository and workflow. This eliminates the need for long-lived tokens entirely.

## Example

### Incorrect Usage

```yaml
- name: Publish
  run: npm publish
  env:
    NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

### Correct Usage

Use npm Trusted Publishing (OIDC) instead of a long-lived token:

```yaml
permissions:
  id-token: write

- name: Publish
  run: npm publish --provenance
```

## References

- npm Docs: [Generating provenance statements](https://docs.npmjs.com/generating-provenance-statements#publishing-packages-with-provenance-via-github-actions).
- GitHub Blog: [Introducing npm package provenance](https://github.blog/security/supply-chain-security/introducing-npm-package-provenance/).
