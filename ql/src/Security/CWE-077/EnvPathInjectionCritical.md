# Environment Path Injection

## Description

GitHub Actions allow to define the system PATH variable by writing to a file pointed to by the `GITHUB_PATH` environment variable. Writing to this file appends a directory to the system PATH variable and automatically makes it available to all subsequent actions in the current job.

E.g.:

```bash
echo "$HOME/.local/bin" >> $GITHUB_PATH
```

If an attacker can control the contents of the system PATH, they are able to influence what commands are run in subsequent steps of the same job.

## Recommendations

Do not allow untrusted data to influence the system PATH: Avoid using untrusted data sources (e.g., artifact content) to define the system PATH.

## Examples

### Incorrect Usage

Consider the following basic setup where an environment variable `PATH` is set:

```yaml
steps:
  - name: Set the path
    env:
      BODY: ${{ github.event.comment.body }}
    run: |
      PATH=$(echo "$BODY" | grep -oP 'system path: \K\S+')
      echo "$PATH" >> "$GITHUB_PATH"
```

If an attacker can manipulate the value being set, such as through artifact downloads or user inputs, they can potentially change the system PATH and get arbitrary command execution in subsequent steps.

## References

- [Workflow commands for GitHub Actions](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/workflow-commands-for-github-actions)
