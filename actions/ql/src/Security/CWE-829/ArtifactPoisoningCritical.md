# Artifact poisoning

## Description

The workflow downloads artifacts that may be poisoned by an attacker in previously triggered workflows. If the contents of these artifacts are not correctly extracted, stored and verified, they may lead to repository compromise if untrusted code gets executed in a privileged job.

## Recommendations

- Always consider artifacts content as untrusted.
- Extract the contents of artifacts to a temporary folder so they cannot override existing files.
- Verify the contents of the artifacts downloaded. If an artifact is expected to contain a numeric value, verify it before using it.

## Examples

### Incorrect Usage

The following workflow downloads an artifact that can potentially be controlled by an attacker and then runs a script from the runner workspace. Because the `dawidd6/action-download-artifact` by default downloads and extracts the contents of the artifacts overriding existing files, an attacker will be able to override the contents of `cmd.sh` and gain code execution when this file gets executed.

```yaml
name: Insecure Workflow

on:
  workflow_run:
    workflows: ["Prev"]
    types:
      - completed

jobs:
  Download:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: dawidd6/action-download-artifact@v2
        with:
          name: pr_number
      - name: Run command
        run: |
          sh cmd.sh
```

### Correct Usage

The following example, correctly creates a temporary directory and extracts the contents of the artifact there before calling `cmd.sh`.

```yaml
name: Insecure Workflow

on:
  workflow_run:
    workflows: ["Prev"]
    types:
      - completed

jobs:
  Download:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: mkdir -p ${{ runner.temp }}/artifacts/
      - uses: dawidd6/action-download-artifact@v2
        with:
          name: pr_number
          path: ${{ runner.temp }}/artifacts/

      - name: Run command
        run: |
          sh cmd.sh
```

## References

- [Keeping your GitHub Actions and workflows secure Part 1: Preventing pwn requests](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/)
