---
category: minorAnalysis
---
* Added modeling of the `mcp` (the official Model Context Protocol SDK) and `fastmcp` PyPI packages. The parameters of MCP tool, resource and prompt handlers are now sources of the opt-in `ai` threat model, as their values are produced by a language model. The HTTP headers that `fastmcp` handlers read through `get_http_headers()` or `get_http_request()`, and the bearer token that token verifiers (`verify_token`) and `get_access_token()` receive, are sources of the `remote` threat model.
