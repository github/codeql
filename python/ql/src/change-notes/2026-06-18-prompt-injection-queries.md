---
category: newQuery
---
* Added two new queries, `py/system-prompt-injection` and `py/user-prompt-injection`, to detect untrusted data flowing into system-level prompts and tool descriptions or user-role prompts, respectively. The queries support the `openai`, OpenAI Agents SDK (`agents`), `anthropic`, `google-genai`, `openrouter`, and `langchain` frameworks. The system prompt injection query is included in the default code scanning suite; the lower-precision user prompt injection query is not included in the standard suites.
