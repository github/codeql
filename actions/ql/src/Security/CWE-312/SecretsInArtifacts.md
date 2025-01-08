# Storage of sensitive information in GitHub Actions artifact

## Description

Sensitive information included in a GitHub Actions artifact can allow an attacker to access the sensitive information if the artifact is published.

## Recommendation

Only store information that is meant to be publicly available in a GitHub Actions artifact.

## Example

The following example uses `actions/checkout` to checkout code which stores the GITHUB_TOKEN in the \`.git/config\` file and then stores the contents of the \`.git\` repository into the artifact:

```yaml
name: secrets-in-artifacts
on:
  pull_request:
jobs:
  a-job: # VULNERABLE
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: "Upload artifact"
        uses: actions/upload-artifact@1746f4ab65b179e0ea60a494b83293b640dd5bba # v4.3.2
        with:
          name: file
          path: .
```

The issue has been fixed below, where the `actions/upload-artifact` uses a version (v4+) which does not include hidden files or directories into the artifact.

```yaml
name: secrets-in-artifacts
on:
  pull_request:
jobs:
  a-job: # NOT VULNERABLE
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: "Upload artifact"
        uses: actions/upload-artifact@v4
        with:
          name: file
          path: .
```
