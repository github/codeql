## Overview

GitHub Actions steps communicate output values to the runner through a line-oriented command format. A step normally sets an output by appending a `name=value` record to the file referenced by `GITHUB_OUTPUT`. Multiline values use a delimiter-based form. Older workflows may instead emit `set-output` workflow commands to standard output.

If attacker-controlled data is written to one of these command channels without validation, the data may be interpreted as command syntax rather than as a single value. An attacker can use newline characters, a matching multiline delimiter, or a forged workflow command to create additional outputs or overwrite output values that later steps expect to be trusted.

The attacker-controlled data may come directly from an event, or indirectly from an untrusted checkout, downloaded artifact, file, or action output. Clobbered outputs can alter conditions and arguments in later steps. If a later step interpolates an injected output into a script, this issue may contribute to arbitrary code execution.

## Recommendation

Treat values from events, pull requests, artifacts, untrusted files, and third-party actions as untrusted.

Before writing an untrusted value to `GITHUB_OUTPUT`, validate it against the narrow format required by the workflow. For example, require a pull request number to contain only decimal digits. For a single-line output, reject carriage-return and newline characters. Do not append an untrusted file directly to `GITHUB_OUTPUT`.

Do not use the deprecated `set-output` workflow command. Migrate to `GITHUB_OUTPUT`, and avoid printing untrusted data while legacy workflow-command processing is enabled.

For multiline values, use a random delimiter that cannot occur on a line by itself in the value. If the value is arbitrary, store it in a normal file instead of using the multiline command format, and pass only the validated file path as an output.

Review the documentation and implementation of actions that consume untrusted inputs. Use only inputs that the action handles as data rather than as output-command syntax.

## Example

### Incorrect Usage

The following step reads an attacker-controlled artifact file and writes its contents directly to `GITHUB_OUTPUT`. A newline in `pr-number.txt` can add another output record and overwrite `approved`.

```yaml
- id: metadata
  run: |
    echo "approved=false" >> "$GITHUB_OUTPUT"
    echo "pr_number=$(cat pr-number.txt)" >> "$GITHUB_OUTPUT"
```

For example, an attacker can provide a `pr-number.txt` artifact with the following contents:

```text
123
approved=true
```

The step appends the following records to `GITHUB_OUTPUT`:

```text
approved=false
pr_number=123
approved=true
```

The injected record replaces the expected `approved` output with the attacker-controlled value
`true`.

Likewise, printing untrusted data to standard output can forge a legacy workflow command:

```yaml
- id: metadata
  env:
    BODY: ${{ github.event.comment.body }}
  run: |
    echo "$BODY"
    echo "::set-output name=approved::false"
```

### Correct Usage

Validate the value before writing it to `GITHUB_OUTPUT`, and use a fixed output name with a single-line value:

```yaml
- id: metadata
  run: |
    pr_number="$(cat pr-number.txt)"
    if [[ ! "$pr_number" =~ ^[0-9]+$ ]]; then
      echo "Invalid pull request number" >&2
      exit 1
    fi
    printf 'pr_number=%s\n' "$pr_number" >> "$GITHUB_OUTPUT"
```

## References

- GitHub Docs: [Workflow commands for GitHub Actions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands).
- GitHub Docs: [Setting an output parameter](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands#setting-an-output-parameter).
- GitHub Docs: [Multiline strings](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands#multiline-strings).
- GitHub Changelog: [Deprecating `save-state` and `set-output` commands](https://github.blog/changelog/2022-10-10-github-actions-deprecating-save-state-and-set-output-commands/).
- GitHub Actions Toolkit: [`add-path` and `set-env` runner commands are processed via stdout](https://github.com/actions/toolkit/security/advisories/GHSA-mfwh-5m23-j46w).
- GitHub Security Lab: [New vulnerability patterns and mitigation strategies](https://securitylab.github.com/resources/github-actions-new-patterns-and-mitigations/).
- GitHub Security Lab: [Actions expression injection in Ant Design](https://securitylab.github.com/advisories/GHSL-2024-121_GHSL-2024-122_ant-design/).
- GitHub Security Lab: [Poisoned Pipeline Execution via code injection in SymPy](https://securitylab.github.com/advisories/GHSL-2024-322_Sympy/).
- Common Weakness Enumeration: [CWE-74](https://cwe.mitre.org/data/definitions/74.html).
