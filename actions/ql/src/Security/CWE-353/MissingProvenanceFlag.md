## Overview

The `npm publish` command does not include the `--provenance` flag. Provenance attestation cryptographically links the published package to a specific source commit and workflow run, allowing consumers to verify where and how the package was built.

## Recommendation

Add `--provenance` to the `npm publish` command. This requires the workflow to have `id-token: write` permission and to run in a GitHub Actions environment.

## Example

### Incorrect Usage

```yaml
- name: Publish
  run: npm publish
```

### Correct Usage

```yaml
permissions:
  id-token: write

- name: Publish
  run: npm publish --provenance
```

## References

- npm Docs: [Generating provenance statements](https://docs.npmjs.com/generating-provenance-statements#publishing-packages-with-provenance-via-github-actions).
- GitHub Blog: [Introducing npm package provenance](https://github.blog/security/supply-chain-security/introducing-npm-package-provenance/).
