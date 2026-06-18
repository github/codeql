---
category: newQuery
---
* Replaced the experimental `py/prompt-injection` query with two new experimental queries, `py/system-prompt-injection` and `py/user-prompt-injection`, to distinguish untrusted data flowing into system-level prompts and tool descriptions from data flowing into user-role prompts. The queries model the `openai`, `agents`, `anthropic`, `google-genai`, `openrouter` and `langchain` frameworks.
