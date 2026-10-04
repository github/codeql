/**
 * Provides classes modeling security-relevant aspects of the `mcp` and `fastmcp` PyPI packages
 * (Model Context Protocol server SDKs).
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

  /** Gets API nodes for module-level `fastmcp` registration decorators (`@tool`, etc.). */
  private API::Node fastmcpModuleRegistration(string name) {
    name = registrationMethod() and result = API::moduleImport("fastmcp").getMember(name)
    or
    name = "tool" and result = API::moduleImport("fastmcp").getMember("tools").getMember("tool")
  }

  private predicate isMcpHandler(Function handler) {
    exists(API::Node cls | cls = mcpServerClass() |
      exists(API::CallNode call |
        call = cls.getAnInstance().getMember(registrationMethod()).getACall() and
        call.getNode().getNode() = handler.getADecorator()
      )
      or
      exists(string name | name = registrationMethod() |
        handler.getADecorator() =
          cls.getAnInstance().getMember(name).getAValueReachableFromSource().asExpr()
      )
      or
      exists(API::CallNode addCall |
        addCall = cls.getAnInstance().getMember("add_tool").getACall() and
        (
          exists(DataFlow::LocalSourceNode funcSrc |
            (
              funcSrc.flowsTo(addCall.getArg(0)) or
              funcSrc.flowsTo(addCall.getArgByName("fn")) or
              funcSrc.flowsTo(addCall.getArgByName("tool"))
            ) and
            funcSrc.asExpr() = handler.getDefinition()
          )
          or
          exists(DataFlow::Node arg |
            arg in [addCall.getArg(0), addCall.getArgByName("fn"), addCall.getArgByName("tool")] and
            arg.asExpr().(Name).getId() = handler.getName() and
            arg.getScope() = handler.getScope()
          )
        )
      )
    )
    or
    exists(string name | name = registrationMethod() |
      exists(API::Node reg | reg = fastmcpModuleRegistration(name) |
        exists(API::CallNode call |
          call = reg.getACall() and call.getNode().getNode() = handler.getADecorator()
        )
        or
        handler.getADecorator() = reg.getAValueReachableFromSource().asExpr()
      )
    )
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
