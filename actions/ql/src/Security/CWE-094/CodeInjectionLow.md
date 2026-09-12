## Overview

Using the output of a previous workflow step in GitHub Actions may lead to code injection in contexts like _run:_ or _script:_ if the step output can be controlled by a malicious actor. This alert does not always indicate a vulnerability, as step outputs are often derived from trusted sources and cannot be controlled by an attacker. However, if the step output originates from user-controlled data (such as issue comments, pull request titles, or commit messages), it may be exploitable.

If a step output is user-controlled, code injection in GitHub Actions may allow an attacker to exfiltrate any secrets used in the workflow and the temporary GitHub repository authorization token. The token may have write access to the repository, allowing an attacker to make changes to the repository.

## Recommendation

First, determine whether the step output can actually be controlled by an attacker. Trace the data flow from the step that sets the output to understand where the value originates. If the output is derived from trusted sources (such as hardcoded values, repository settings, or authenticated API responses), the risk is minimal.

If the step output can be user-controlled, the best practice to avoid code injection vulnerabilities in GitHub workflows is to set the untrusted input value of the expression to an intermediate environment variable and then use the environment variable using the native syntax of the shell/script interpreter (that is, not _${{ env.VAR }}_).

It is also recommended to limit the permissions of any tokens used by a workflow such as the GITHUB_TOKEN.

## Example

### Incorrect Usage

The following example lets attackers inject an arbitrary shell command if output `message` of the step `get-message` is derived from user-controlled data:

```yaml
jobs:
  echo-message:
    runs-on: ubuntu-latest
    steps:
      - id: get-message
        run: |
          # If this value comes from user input, it is vulnerable
          echo "message=$USER_INPUT" >> $GITHUB_OUTPUT
      - run: |
          echo '${{ steps.get-message.outputs.message }}'
```

The following example uses an environment variable, but **still allows the injection** because of the use of expression syntax:

```yaml
jobs:
  echo-message:
    runs-on: ubuntu-latest
    steps:
      - id: get-message
        run: |
          echo "message=$USER_INPUT" >> $GITHUB_OUTPUT
      - env:
          MESSAGE: ${{ steps.get-message.outputs.message }}
        run: |
          echo '${{ env.MESSAGE }}'
```

### Correct Usage

The following example uses shell syntax to read the environment variable and will prevent the attack:

```yaml
jobs:
  echo-message:
    runs-on: ubuntu-latest
    steps:
      - id: get-message
        run: |
          echo "message=$USER_INPUT" >> $GITHUB_OUTPUT
      - env:
          MESSAGE: ${{ steps.get-message.outputs.message }}
        run: |
          echo "$MESSAGE"
```

The following example uses `process.env` to read environment variables within JavaScript code.

```yaml
jobs:
  echo-message:
    runs-on: ubuntu-latest
    steps:
      - id: get-message
        run: |
          echo "message=$USER_INPUT" >> $GITHUB_OUTPUT
      - uses: actions/github-script@v4
        env:
          MESSAGE: ${{ steps.get-message.outputs.message }}
        with:
          script: |
            const { MESSAGE } = process.env
            ...
```

## References

- GitHub Security Lab Research: [Keeping your GitHub Actions and workflows secure: Untrusted input](https://securitylab.github.com/research/github-actions-untrusted-input).
- GitHub Docs: [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).
- GitHub Docs: [Permissions for the GITHUB_TOKEN](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token).
