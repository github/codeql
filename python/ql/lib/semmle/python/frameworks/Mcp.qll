/**
 * Provides classes modeling security-relevant aspects of the `mcp` and `fastmcp` PyPI packages,
 * which implement Model Context Protocol (MCP) servers.
 *
 * See
 * - https://pypi.org/project/mcp/
 * - https://pypi.org/project/fastmcp/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `mcp` and `fastmcp` PyPI packages.
 *
 * The parameters of tool, resource and prompt handlers are chosen by the MCP client, that is by a
 * language model or by anyone who can reach the server. The low-level server of `mcp`, the HTTP
 * headers and the bearer tokens are modeled as data extensions (`mcp.model.yml`, `fastmcp.model.yml`).
 */
module Mcp {
  /** Gets a reference to a server class whose instances register tool, resource and prompt handlers. */
  private API::Node serverClass() {
    exists(API::Node mcpServer | mcpServer = API::moduleImport("mcp").getMember("server") |
      // `FastMCP` in 1.x of `mcp`, renamed to `MCPServer` in 2.x
      result = mcpServer.getMember("fastmcp").getMember("FastMCP")
      or
      result = mcpServer.getMember("fastmcp").getMember("server").getMember("FastMCP")
      or
      result = mcpServer.getMember("MCPServer")
      or
      result = mcpServer.getMember("mcpserver").getMember("MCPServer")
      or
      result = mcpServer.getMember("mcpserver").getMember("server").getMember("MCPServer")
    )
    or
    exists(API::Node fastmcp | fastmcp = API::moduleImport("fastmcp") |
      result = fastmcp.getMember("FastMCP")
      or
      result = fastmcp.getMember("server").getMember("FastMCP")
      or
      result = fastmcp.getMember("server").getMember("server").getMember("FastMCP")
    )
  }

  /** Gets a reference to a tool or prompt class of `fastmcp` that has a `from_function` method. */
  private API::Node functionComponentClass() {
    exists(API::Node tools | tools = API::moduleImport("fastmcp").getMember("tools") |
      result = tools.getMember(["Tool", "FunctionTool"])
      or
      // 2.x defines both classes in `fastmcp.tools.tool`, later versions split them up
      result = tools.getMember("tool").getMember(["Tool", "FunctionTool"])
      or
      result = tools.getMember("base").getMember("Tool")
      or
      result = tools.getMember("function_tool").getMember("FunctionTool")
    )
    or
    exists(API::Node prompts | prompts = API::moduleImport("fastmcp").getMember("prompts") |
      result = prompts.getMember(["Prompt", "FunctionPrompt"])
      or
      result = prompts.getMember("prompt").getMember(["Prompt", "FunctionPrompt"])
      or
      result = prompts.getMember("base").getMember("Prompt")
      or
      result = prompts.getMember("function_prompt").getMember("FunctionPrompt")
    )
  }

  /**
   * Gets a reference to a standalone decorator of `fastmcp` (3.x and later) that marks a function
   * as a tool or prompt.
   */
  private API::Node standaloneDecorator() {
    exists(API::Node fastmcp | fastmcp = API::moduleImport("fastmcp") |
      result = fastmcp.getMember("tools").getMember("tool")
      or
      result = fastmcp.getMember("tools").getMember("function_tool").getMember("tool")
      or
      result = fastmcp.getMember("prompts").getMember("prompt")
      or
      result = fastmcp.getMember("prompts").getMember("function_prompt").getMember("prompt")
    )
  }

  /** Gets an API node for a function that is registered as a tool, resource or prompt handler. */
  private API::Node handlerNode() {
    exists(API::Node server | server = serverClass().getAnInstance() |
      // `@server.tool()`, `@server.resource(uri)`, `@server.prompt()`
      result = server.getMember(["tool", "resource", "prompt"]).getReturn().getParameter(0)
      or
      // `@server.tool` and `@server.prompt` without parentheses (`fastmcp`)
      result = server.getMember(["tool", "prompt"]).getParameter(0)
      or
      result = server.getMember(["tool", "prompt"]).getKeywordParameter("name_or_fn")
      or
      result = server.getMember(["add_tool", "add_prompt"]).getParameter(0)
      or
      result = server.getMember("add_tool").getKeywordParameter(["fn", "tool"])
      or
      result = server.getMember("add_prompt").getKeywordParameter("prompt")
    )
    or
    exists(API::Node fromFunction |
      fromFunction = functionComponentClass().getMember("from_function")
    |
      result = fromFunction.getParameter(0)
      or
      result = fromFunction.getKeywordParameter("fn")
    )
    or
    exists(API::Node decorator | decorator = standaloneDecorator() |
      result = decorator.getParameter(0)
      or
      result = decorator.getKeywordParameter("name_or_fn")
      or
      result = decorator.getReturn().getParameter(0)
    )
  }

  /** Gets a reference to the `Context` class whose instances the SDKs inject into handlers. */
  private API::Node contextClass() {
    exists(API::Node mcpServer | mcpServer = API::moduleImport("mcp").getMember("server") |
      result = mcpServer.getMember("fastmcp").getMember("Context")
      or
      result = mcpServer.getMember("fastmcp").getMember("server").getMember("Context")
      or
      result = mcpServer.getMember("mcpserver").getMember("Context")
      or
      result = mcpServer.getMember("mcpserver").getMember("context").getMember("Context")
    )
    or
    exists(API::Node fastmcp | fastmcp = API::moduleImport("fastmcp") |
      result = fastmcp.getMember("Context")
      or
      result = fastmcp.getMember("server").getMember("context").getMember("Context")
    )
  }

  /** Gets a name under which the module `m` refers to the `Context` class. */
  private string contextName(Module m) {
    exists(Expr ref |
      ref = contextClass().getAValueReachableFromSource().asExpr() and
      m = ref.getEnclosingModule()
    |
      result = "Context"
      or
      // `from fastmcp import Context as Ctx`
      exists(Alias alias | alias.getValue() = ref | result = alias.getAsname().(Name).getId())
    )
  }

  /** Holds if `s` subscripts something named `name`, as in `name[...]` or `typing.name[...]`. */
  private predicate subscripts(Subscript s, string name) {
    s.getObject().(Name).getId() = name or s.getObject().(Attribute).getName() = name
  }

  /**
   * Holds if the annotation `e` refers to the injected `Context` class, possibly as
   * `Context[...]`, `Context | None`, `Optional[Context]`, `Union[Context, ...]`,
   * `Annotated[Context, ...]` or as a string such as `"Context"`.
   */
  private predicate isContextAnnotation(Expr e) {
    e = contextClass().getAValueReachableFromSource().asExpr()
    or
    isContextAnnotation(e.(Subscript).getObject())
    or
    // Only the first argument of `Annotated` is a type, the others are metadata.
    exists(Subscript s | s = e and subscripts(s, "Annotated") |
      isContextAnnotation(s.getIndex().(Tuple).getElt(0))
    )
    or
    // The arguments of `Literal` are values, not types.
    exists(Subscript s | s = e and not subscripts(s, ["Annotated", "Literal"]) |
      isContextAnnotation(s.getIndex())
    )
    or
    isContextAnnotation(e.(Tuple).getAnElt())
    or
    exists(BinaryExpr union | union = e and union.getOp() instanceof BitOr |
      isContextAnnotation(union.getLeft()) or isContextAnnotation(union.getRight())
    )
    or
    // The SDKs resolve string annotations, so a string naming the class in this module counts.
    e.(StringLiteral).getText().regexpMatch(".*\\b" + contextName(e.getEnclosingModule()) + "\\b.*")
  }

  /**
   * Holds if `p` is a parameter of `handler` whose value is chosen by the MCP client.
   *
   * A handler decorated in a class body is registered unbound, so the client supplies its first
   * parameter as well.
   */
  private predicate isClientParameter(Function handler, Parameter p) {
    handler = handlerNode().getAValueReachingSink().asExpr().(CallableExpr).getInnerScope() and
    (
      p = handler.getAnArg()
      or
      p = handler.getAKeywordOnlyArg()
      or
      p = handler.getVararg()
      or
      p = handler.getKwarg()
    ) and
    not isContextAnnotation(p.getAnnotation())
  }

  /** A parameter of an MCP tool, resource or prompt handler, seen as a source of the `ai` threat model. */
  private class HandlerParameter extends ThreatModelSource::Range, DataFlow::ParameterNode {
    HandlerParameter() { isClientParameter(_, this.getParameter()) }

    override string getThreatModel() { result = "ai" }

    override string getSourceType() { result = "MCP handler parameter" }
  }
}
