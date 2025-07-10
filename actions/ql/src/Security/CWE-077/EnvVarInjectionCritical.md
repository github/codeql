# Environment Variable Injection

## Description

GitHub Actions allow to define environment variables by writing to a file pointed to by the `GITHUB_ENV` environment variable:

This file contains lines in the `KEY=VALUE` format:

```bash
steps:
  - name: Set the value
    id: step_one
    run: |
      echo "action_state=yellow" >> "$GITHUB_ENV"
```

It is also possible to define multiline variables by using the [following construct](https://en.wikipedia.org/wiki/Here_document):

```
KEY<<{delimiter}
VALUE
VALUE
{delimiter}
```

```bash
steps:
  - name: Set the value in bash
    id: step_one
    run: |
      {
        echo 'JSON_RESPONSE<<EOF'
        curl https://example.com
        echo EOF
      } >> "$GITHUB_ENV"
```

If an attacker can control the values assigned to environment variables and there is no sanitization in place, the attacker will be able to inject additional variables by injecting new lines or `{delimiters}`.

## Recommendations

1. **Do not allow untrusted data to influence environment variables**:

    - Avoid using untrusted data sources (e.g., artifact content) to define environment variables.
    - Validate and sanitize all inputs before using them in environment settings.

2. **Do not allow new lines when defining single line environment variables**:

    - `echo "BODY=$(echo "$BODY" | tr -d '\n')" >> "$GITHUB_ENV"`

3. **Use unique identifiers when defining multi line environment variables**:

    ```bash
    steps:
      - name: Set the value in bash
        id: step_one
        run: |
          # Generate a UUID
          UUID=$(uuidgen)
          {
            echo "JSON_RESPONSE<<EOF$UUID"
            curl https://example.com
            echo "EOF$UUID"
          } >> "$GITHUB_ENV"
    ```

## Examples

### Example of Vulnerability

Consider the following basic setup where an environment variable `MYVAR` is set and used in subsequent steps:

```yaml
steps:
  - name: Set the value
    id: step_one
    env:
      BODY: ${{ github.event.comment.body }}
    run: |
      REPLACED=$(echo "$BODY" | sed 's/FOO/BAR/g')
      echo "MYVAR=$REPLACED" >> "$GITHUB_ENV"
```

If an attacker can manipulate the value being set, such as through artifact downloads or user inputs, the attacker can potentially inject new environment variables. For example, they could write an issue comment like:

```text
FOO
NEW_ENV_VAR=MALICIOUS_VALUE
```

Likewise, if the attacker controls a file in the GitHub Actions Runner's workspace (eg: the workflow checkouts untrusted code or downloads an untrusted artifact) and the contents of that file are assigned to an environment variable such as:

```bash
- run: |
    PR_NUMBER=$(cat pr-number.txt)
    echo "PR_NUMBER=$PR_NUMBER" >> $GITHUB_ENV
```

An attacker could craft a malicious artifact that writes dangerous environment variables:

```bash
  - run: |
      echo -e "666\nNEW_ENV_VAR=MALICIOUS_VALUE" > pr-number.txt
  - uses: actions/upload-artifact@v4
    with:
      name: pr-number
      path: ./pr-number.txt
```

### Exploitation

An attacker is be able to run arbitrary code by injecting environment variables such as `LD_PRELOAD`, `BASH_ENV`, etc.

## References

- [Workflow commands for GitHub Actions](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/workflow-commands-for-github-actions)
- [GitHub Actions Exploitation: Repo Jacking and Environment Manipulation](https://www.synacktiv.com/publications/github-actions-exploitation-repo-jacking-and-environment-manipulation)
