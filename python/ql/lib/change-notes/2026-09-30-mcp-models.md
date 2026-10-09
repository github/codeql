---
category: minorAnalysis
---
* Added modeling of the `mcp` (the official Model Context Protocol SDK) and `fastmcp` PyPI packages. The parameters of MCP tool, resource and prompt handlers, the HTTP headers that `fastmcp` handlers read through `get_http_headers()` or `get_http_request()`, and the bearer token that token verifiers (`verify_token`) and `get_access_token()` receive, are now sources of the `remote` threat model.
