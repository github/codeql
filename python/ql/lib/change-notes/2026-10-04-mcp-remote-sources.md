---
category: minorAnalysis
---
* Added **`ai`** threat-model sources for MCP/`fastmcp` tool, resource and prompt handlers that are registered behind **inner custom project wrappers**, where the API-graph baseline alone does not reach the handler. Standard handlers, `@staticmethod` tools, and `@self.mcp.tool()` instance registrations are already modeled in the merged MCP baseline (#22703).