# Argument Injection in GitHub Actions

## Description

Passing user-controlled arguments to certain commands in the context of `Run` steps may lead to arbitrary code execution.

Argument injection in GitHub Actions may allow an attacker to exfiltrate any secrets used in the workflow and the temporary GitHub repository authorization token. The token may have write access to the repository, allowing the attacker to make changes to the repository.

## Recommendations

When possible avoid passing user-controlled data to commands which may spawn new processes using some of their arguments.

It is also recommended to limit the permissions of any tokens used by a workflow such as the GITHUB_TOKEN.

## Examples

### Incorrect Usage

The following example lets a user inject an arbitrary shell command through argument injection:

```yaml
on: issue_comment

jobs:
  echo-body:
    runs-on: ubuntu-latest
    steps:
      - env:
          BODY: ${{ github.event.comment.body }}
        run: |
          cat file.txt | sed  "s/BODY_PLACEHOLDER/$BODY/g" > replaced.txt
```

An attacker may set the body of an Issue comment to `BAR/g;1e whoami;#` and the command `whoami` will get executed during the `sed` operation.

## References

- [Common Weakness Enumeration: CWE-88](https://cwe.mitre.org/data/definitions/88.html).
- [Argument Injection Explained](https://sonarsource.github.io/argument-injection-vectors/explained/)
- [Argument Injection Vectors](https://sonarsource.github.io/argument-injection-vectors/)
- [GTFOBins](https://gtfobins.github.io/)
