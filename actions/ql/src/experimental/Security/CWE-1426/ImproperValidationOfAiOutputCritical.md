## Overview

Using AI-generated output without validation in GitHub Actions workflows enables **chained injection attacks** where an attacker's prompt injection in one step produces malicious AI output that executes as code in a subsequent step. When AI output flows unsanitized into shell commands, build scripts, package installations, or subsequent AI prompts, an attacker who controls the AI's input effectively controls the code that runs in your CI/CD pipeline.

AI output should always be treated as untrusted data. This is especially dangerous because the malicious payload is generated dynamically by the AI and may bypass traditional static analysis or code review.

## Recommendation

Treat all AI-generated output as untrusted. Before using AI output in any executable context:

- **Validate the format** — check that the output matches an expected schema or pattern before use.
- **Never interpolate AI output directly into `run:` steps** — use environment variables and validate before execution.
- **Limit AI action permissions** — restrict `GITHUB_TOKEN` scope and avoid passing secrets to workflows that consume AI output.
- **Use structured output formats** (e.g. JSON with a defined schema) to constrain AI responses and make validation easier.
- **Avoid chaining AI calls** without validating intermediate output. Each AI step's output is a potential injection vector for the next.

## Example

### Incorrect Usage

The following example executes AI output directly as a shell command. An attacker who controls the AI's input (via the issue body) can cause the AI to output arbitrary shell commands:

```yaml
on:
  issues:
    types: [opened]

jobs:
  ai-task:
    runs-on: ubuntu-latest
    steps:
      - name: AI inference
        id: ai
        uses: actions/ai-inference@v1
        with:
          prompt: |
            Suggest a fix for: ${{ github.event.issue.body }}

      - name: Apply fix
        run: |
          ${{ steps.ai.outputs.response }}
```

### Correct Usage

The following example validates the AI output format before taking any action:

```yaml
      - name: Validate and apply
        run: |
          RESPONSE="${AI_RESPONSE}"
          # Only accept responses that match a safe pattern
          if echo "$RESPONSE" | grep -qE '^(fix|patch|update):'; then
            echo "Valid response format, proceeding"
          else
            echo "::warning::Unexpected AI output format, skipping execution"
            exit 0
          fi
        env:
          AI_RESPONSE: ${{ steps.ai.outputs.response }}
```

## References

- Common Weakness Enumeration: [CWE-1426](https://cwe.mitre.org/data/definitions/1426.html).
- [OWASP LLM02: Insecure Output Handling](https://genai.owasp.org/llmrisk/llm02-insecure-output-handling/).
- GitHub Docs: [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).
