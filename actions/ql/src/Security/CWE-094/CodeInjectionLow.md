## Overview

Using string-typed `workflow_call` inputs in GitHub Actions may lead to code injection in contexts like _run:_ or _script:_.

Inputs declared as `string` should be treated with caution. Although `workflow_call` can only be triggered by other workflows (not directly by external users), the calling workflow may pass untrusted user input as arguments. Since the reusable workflow author has no control over the callers, these inputs may still originate from untrusted data.

Code injection in GitHub Actions may allow an attacker to exfiltrate any secrets used in the workflow and the temporary GitHub repository authorization token.

## Recommendation

The best practice to avoid code injection vulnerabilities in GitHub workflows is to set the untrusted input value of the expression to an intermediate environment variable and then use the environment variable using the native syntax of the shell/script interpreter (that is, not _${{ env.VAR }}_).

It is also recommended to limit the permissions of any tokens used by a workflow such as the GITHUB_TOKEN.

## Example

### Incorrect Usage

The following example uses a `workflow_call` input directly in a _run:_ step, which allows code injection if the caller passes untrusted data:

```yaml
on:
  workflow_call:
    inputs:
      title:
        description: 'Title'
        type: string

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo '${{ inputs.title }}'
```

### Correct Usage

The following example safely uses a `workflow_call` input by passing it through an environment variable:

```yaml
on:
  workflow_call:
    inputs:
      title:
        description: 'Title'
        type: string

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - env:
          TITLE: ${{ inputs.title }}
        run: |
          echo "$TITLE"
```

## References

- GitHub Security Lab Research: [Keeping your GitHub Actions and workflows secure: Untrusted input](https://securitylab.github.com/research/github-actions-untrusted-input).
- GitHub Docs: [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).
- GitHub Docs: [Reusing workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows).
- Common Weakness Enumeration: [CWE-94: Improper Control of Generation of Code ('Code Injection')](https://cwe.mitre.org/data/definitions/94.html).
- Common Weakness Enumeration: [CWE-95: Improper Neutralization of Directives in Dynamically Evaluated Code ('Eval Injection')](https://cwe.mitre.org/data/definitions/95.html).
- Common Weakness Enumeration: [CWE-116: Improper Encoding or Escaping of Output](https://cwe.mitre.org/data/definitions/116.html).
