# Code Injection in GitHub Actions

Using user-controlled input in GitHub Actions may lead to code injection in contexts like _run:_ or _script:_.

Code injection in GitHub Actions may allow an attacker to exfiltrate any secrets used in the workflow and the temporary GitHub repository authorization token. The token might have write access to the repository, allowing an attacker to use the token to make changes to the repository.

## Recommendation

The best practice to avoid code injection vulnerabilities in GitHub workflows is to set the untrusted input value of the expression to an intermediate environment variable and then use the environment variable using the native syntax of the shell/script interpreter (that is, not _${{ env.VAR }}_).

It is also recommended to limit the permissions of any tokens used by a workflow such as the GITHUB_TOKEN.

## Example

The following example lets a user inject an arbitrary shell command:

```yaml
on: issue_comment

jobs:
  echo-body:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo '${{ github.event.comment.body }}'
```

The following example uses an environment variable, but **still allows the injection** because of the use of expression syntax:

```yaml
on: issue_comment

jobs:
  echo-body:
    runs-on: ubuntu-latest
    steps:
    -  env:
        BODY: ${{ github.event.issue.body }}
      run: |
        echo '${{ env.BODY }}'
```

The following example uses shell syntax to read the environment variable and will prevent the attack:

```yaml
jobs:
  echo-body:
    runs-on: ubuntu-latest
    steps:
      - env:
          BODY: ${{ github.event.issue.body }}
        run: |
          echo "$BODY"
```

## References

- GitHub Security Lab Research: [Keeping your GitHub Actions and workflows secure: Untrusted input](https://securitylab.github.com/research/github-actions-untrusted-input).
- GitHub Docs: [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).
- GitHub Docs: [Permissions for the GITHUB_TOKEN](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token).
