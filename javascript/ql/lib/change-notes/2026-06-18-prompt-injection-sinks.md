---
category: minorAnalysis
---
* Added more prompt-injection sinks for the OpenAI, Anthropic, and Google GenAI SDKs: OpenAI `videos.create`/`edit`/`extend`/`remix` (Sora) prompts and `beta.realtime.sessions.create` instructions, Anthropic legacy `completions.create` prompts, and Google GenAI `caches.create` cached contents and system instructions.
* The OpenAI legacy `completions.create` prompt is now treated as a user-prompt-injection sink instead of a system-prompt-injection sink, since the legacy `/v1/completions` endpoint takes a single free-form prompt with no role separation.
