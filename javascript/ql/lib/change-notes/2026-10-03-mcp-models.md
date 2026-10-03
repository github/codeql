---
category: minorAnalysis
---
* Added modeling of the `@modelcontextprotocol/sdk` and `@modelcontextprotocol/server` (the official Model Context Protocol SDK) and `fastmcp` npm packages. The arguments of MCP tool, resource and prompt callbacks, the requests that handlers of the low-level `Server` receive, and the request headers and bearer token that the SDK passes to a callback, are now sources of the `remote` threat model.
