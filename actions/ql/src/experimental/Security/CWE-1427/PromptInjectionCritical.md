## Overview

Passing user-controlled data into the prompt of an AI inference action allows an attacker to hijack the AI's behavior through **prompt injection**. Any workflow that feeds external input — issue titles, PR bodies, comments, or `repository_dispatch` payloads — directly into an AI prompt without sanitization is vulnerable to this class of attack.

When the AI action runs with access to secrets, write permissions, or code execution capabilities, a successful prompt injection can lead to secret exfiltration, unauthorized repository modifications, malicious package publication, or arbitrary command execution within the CI/CD environment.

## Recommendation

Never pass user-controlled data directly into AI prompt parameters. Instead:

- **Sanitize and truncate** user input before including it in prompts. Strip control characters and limit length.
- **Use environment variables** with shell-native interpolation (e.g. `$TITLE` not `${{ ... }}`) to prevent expression injection.
- **Restrict workflow permissions** to the minimum required (e.g. `issues: write`, `models: read` only).
- **Use deployment environments** with required reviewers for workflows that invoke AI actions on external input.
- **Validate AI output** before using it in subsequent steps — treat AI responses as untrusted data.

## Example

### Incorrect Usage

The following example passes unsanitized issue data directly into an AI prompt. An attacker can craft an issue title containing hidden instructions that cause the AI to ignore its system prompt, exfiltrate secrets via its response, or produce output that compromises downstream steps:

```yaml
on:
  issues:
    types: [opened]

jobs:
  summary:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      models: read
    steps:
      - name: Run AI inference
        uses: actions/ai-inference@v1
        with:
          prompt: |
            Summarize the following GitHub issue:
            Title: ${{ github.event.issue.title }}
            Body: ${{ github.event.issue.body }}
```

### Correct Usage

The following example sanitizes and truncates user input before passing it to the AI, and uses environment variables to prevent expression injection:

```yaml
on:
  issues:
    types: [opened]

jobs:
  summary:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      models: read
    steps:
      - name: Sanitize input
        id: sanitize
        run: |
          SAFE_TITLE=$(echo "$TITLE" | head -c 200 | tr -dc '[:print:]')
          echo "title=$SAFE_TITLE" >> $GITHUB_OUTPUT
        env:
          TITLE: ${{ github.event.issue.title }}

      - name: Run AI inference
        uses: actions/ai-inference@v1
        with:
          prompt: |
            Summarize the following GitHub issue title (user input has been sanitized):
            Title: ${{ steps.sanitize.outputs.title }}
```

## References

- Common Weakness Enumeration: [CWE-1427](https://cwe.mitre.org/data/definitions/1427.html).
- [OWASP LLM01: Prompt Injection](https://genai.owasp.org/llmrisk/llm01-prompt-injection/).
- GitHub Docs: [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).
