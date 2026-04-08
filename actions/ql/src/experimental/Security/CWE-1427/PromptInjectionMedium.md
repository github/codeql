## Overview

Passing user-controlled data into the prompt of an AI inference action on non-privileged but externally triggerable events such as `pull_request` allows an attacker to manipulate AI behavior through **prompt injection**. While the `pull_request` event does not grant write access to the base repository by default, the AI action may still reveal sensitive information, produce misleading output, or influence downstream processes that trust the AI's response.

This is a lower-severity variant of prompt injection (compared to privileged contexts like `issues`, `issue_comment`, or `pull_request_target`) because the attacker's ability to exploit the injection is limited by the reduced permissions of the triggering event.

## Recommendation

Apply the same mitigations as for critical-severity prompt injection:

- **Sanitize and truncate** user input before including it in prompts.
- **Use environment variables** with shell-native interpolation instead of `${{ }}` expression syntax.
- **Restrict workflow permissions** to the minimum required.
- **Validate AI output** before using it in subsequent steps.

## Example

### Incorrect Usage

The following example passes the pull request title directly into an AI prompt on the `pull_request` event:

```yaml
on:
  pull_request:
    types: [opened]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - name: AI analysis
        uses: actions/ai-inference@v1
        with:
          prompt: |
            Analyze this PR title:
            ${{ github.event.pull_request.title }}
```

### Correct Usage

The following example sanitizes the PR title before passing it to the AI:

```yaml
on:
  pull_request:
    types: [opened]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - name: Sanitize input
        id: sanitize
        run: |
          SAFE_TITLE=$(echo "$TITLE" | head -c 200 | tr -dc '[:print:]')
          echo "title=$SAFE_TITLE" >> $GITHUB_OUTPUT
        env:
          TITLE: ${{ github.event.pull_request.title }}

      - name: AI analysis
        uses: actions/ai-inference@v1
        with:
          prompt: |
            Analyze this PR title (sanitized):
            ${{ steps.sanitize.outputs.title }}
```

## References

- Common Weakness Enumeration: [CWE-1427](https://cwe.mitre.org/data/definitions/1427.html).
- [OWASP LLM01: Prompt Injection](https://genai.owasp.org/llmrisk/llm01-prompt-injection/).
- GitHub Docs: [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).
