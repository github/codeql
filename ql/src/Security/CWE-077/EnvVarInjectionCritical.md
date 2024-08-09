# Environment Variable Injection

## Description

GitHub Actions allows to define Environment Variables by writing to a file pointed to by the `GITHUB_ENV` environment variable:

This file should lines in the `KEY=VALUE` format:

```bash
steps:
  - name: Set the value
    id: step_one
    run: |
      echo "action_state=yellow" >> "$GITHUB_ENV"
```

It is also possible to define a multiline variables by using the following format:

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

If an attacker can control the contents of the values assigned to these variables and these are not properly sanitized, they will be able to inject additional variables by injecting new lines or `{delimiters}`.

## Recommendations

1. **Do Not Allow Untrusted Data to Influence Environment Variables**:

- Avoid using untrusted data sources (e.g., artifact content) to define environment variables.
- Validate and sanitize all inputs before using them in environment settings.

2. **Do Not Allow New Lines When Defining Single Line Environment Variables**:

- `echo "BODY=$(echo "$BODY" | tr -d '\n')" >> "$GITHUB_ENV"`

3. **Use Unique Identifiers When Defining Multi Line Environment Variables**:

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

Consider the following basic setup where an environment variable `MYVAR` is set and used in different steps:

```yaml
steps:
  - name: Set the value
    id: step_one
    env:
      BODY: ${{ github.event.comment.body }}
    run: |
      REPLACED=$(echo "$BODY" | sed 's/FOO/BAR/g')
      echo "BODY=$REPLACED" >> "$GITHUB_ENV"
```

If an attacker can manipulate the value being set, such as through artifact downloads or user inputs, they can potentially inject new Environment variables. For example, they could write an Issue comment like:

```
FOO
NEW_ENV_VAR=MALICIOUS_VALUE
```

Likewise, if the attacker controls a file in the Runner's workspace (eg: the workflow checkouts untrusted code or downloads an untrusted artifact), and the contents of that file are assigned to an environment variable such as:

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

An attacker will be able to run arbitrary code by injecting environment variables such as `LD_PRELOAD`, `BASH_ENV`, etc.

## References

- [Workflow commands for GitHub Actions](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/workflow-commands-for-github-actions)
- [GitHub Actions Exploitation: Repo Jacking and Environment Manipulation](https://www.synacktiv.com/publications/github-actions-exploitation-repo-jacking-and-environment-manipulation)
