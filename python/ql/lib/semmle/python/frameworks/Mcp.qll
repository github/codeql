/**
 * Provides classes modeling security-relevant aspects of the `mcp` and `fastmcp` PyPI packages
 * (Model Context Protocol server SDKs).
 *
 * Baseline `@mcp.tool` / `@mcp.prompt` / `@mcp.resource` handlers on standalone functions are
 * covered by Models-as-Data. This module only captures programmatic edge cases MaD misses:
 * stacked/wrapped custom decorators and instance registrations such as `@self.mcp.tool()`.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.ApiGraphs

/**
 * Provides models for MCP server handler parameters as remote flow sources.
 */
module Mcp {
  private string registrationMethod() { result in ["tool", "prompt", "resource"] }

  /** Gets API nodes for MCP / FastMCP server classes used to register handlers. */
  private API::Node mcpServerClass() {
    result =
      [
        API::moduleImport("fastmcp").getMember("FastMCP"),
        API::moduleImport("fastmcp").getMember("server").getMember("FastMCP"),
        API::moduleImport("fastmcp").getMember("server").getMember("server").getMember("FastMCP"),
        API::moduleImport("mcp").getMember("server").getMember("fastmcp").getMember("FastMCP"),
        API::moduleImport("mcp")
            .getMember("server")
            .getMember("fastmcp")
            .getMember("server")
            .getMember("FastMCP"),
        API::moduleImport("mcp").getMember("server").getMember("MCPServer"),
        API::moduleImport("mcp").getMember("server").getMember("mcpserver").getMember("MCPServer"),
        API::moduleImport("mcp")
            .getMember("server")
            .getMember("mcpserver")
            .getMember("server")
            .getMember("MCPServer"),
      ]
  }

  /** An MCP `@tool`/`@prompt`/`@resource` decorator expression on `handler`. */
  private predicate mcpRegistrationDecorator(Function handler, Expr dec) {
    dec = handler.getADecorator() and
    exists(API::Node cls | cls = mcpServerClass() |
      exists(API::CallNode call |
        call = cls.getAnInstance().getMember(registrationMethod()).getACall() and
        call.getNode().getNode() = dec
      )
      or
      exists(string name | name = registrationMethod() |
        dec = cls.getAnInstance().getMember(name).getAValueReachableFromSource().asExpr()
      )
    )
  }

  /**
   * Holds if `handler` is an MCP registration wrapped by another decorator.
   * MaD YAML currently drops these stacked/custom project wrappers.
   */
  private predicate isWrappedMcpHandler(Function handler) {
    exists(Expr mcpDec, Expr extra |
      mcpRegistrationDecorator(handler, mcpDec) and
      extra = handler.getADecorator() and
      extra != mcpDec
    )
  }

  /**
   * Holds if `handler` is registered via a nested instance lookup such as `@self.mcp.tool()`.
   * The callee object is itself an `Attribute`, not a simple name (`mcp_app.tool()`).
   */
  private predicate isInstanceLookupHandler(Function handler) {
    exists(Expr dec | mcpRegistrationDecorator(handler, dec) |
      exists(Attribute callee |
        callee = dec.(Call).getFunc()
        or
        callee = dec
      |
        callee.getObject() instanceof Attribute
      )
    )
  }

  private predicate isMcpHandler(Function handler) {
    isWrappedMcpHandler(handler)
    or
    isInstanceLookupHandler(handler)
  }

  private predicate isContextAnnotation(Expr ann) {
    exists(API::Node ctx |
      ctx in [
          API::moduleImport("fastmcp").getMember("Context"),
          API::moduleImport("mcp").getMember("server").getMember("fastmcp").getMember("Context"),
        ] and
      ann = ctx.getAValueReachableFromSource().asExpr()
    )
  }

  private predicate isMcpContextParameter(Parameter p) {
    exists(Expr ann | ann = p.getAnnotation() |
      isContextAnnotation(ann)
      or
      exists(Subscript sub | sub = ann | isContextAnnotation(sub.getValue()))
      or
      exists(BinaryExpr bin | bin = ann and bin.getOp() instanceof BitOr |
        isContextAnnotation(bin.getLeft()) or isContextAnnotation(bin.getRight())
      )
    )
  }

  private predicate isHandlerParameter(Function handler, Parameter p) {
    (
      p = handler.getAnArg()
      or
      p = handler.getAKeywordOnlyArg()
      or
      p = handler.getVararg()
      or
      p = handler.getKwarg()
    ) and
    not (handler.isMethod() and p = handler.getArg(0)) and
    not isMcpContextParameter(p)
  }

  private class McpHandlerParameter extends RemoteFlowSource::Range, DataFlow::ParameterNode {
    McpHandlerParameter() {
      exists(Function handler |
        isMcpHandler(handler) and
        isHandlerParameter(handler, this.getParameter())
      )
    }

    override string getSourceType() { result = "MCP server handler parameter" }
  }
}
