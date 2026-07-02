---
category: minorAnalysis
---
* Added prompt-injection sink models (`system-prompt-injection` and `user-prompt-injection` kinds) for the `openai`, `agents`, `anthropic`, `google-genai`, `openrouter` and `langchain` frameworks. Tool and function descriptions (which are model-facing instructions) are now modeled as `system-prompt-injection` sinks across all of these frameworks.
