---
category: minorAnalysis
---
* Added modeling of the `@modelcontextprotocol/sdk` and `@modelcontextprotocol/server` (the official Model Context Protocol SDK) and `fastmcp` npm packages. The arguments of MCP tool, resource and prompt callbacks and the requests that handlers of the low-level `Server` receive are now sources of the opt-in `ai` threat model, as their values are produced by a language model. The request headers and the bearer token that the SDK passes to a callback are sources of the `remote` threat model.
