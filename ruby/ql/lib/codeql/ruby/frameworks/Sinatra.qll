/** Provides modeling for the Sinatra library. */

private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.AST
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.dataflow.SSA

/** Provides modeling for the Sinatra library. */
module Sinatra {
  /**
   * A Sinatra application.
   *
   * ```rb
   * class MyApp < Sinatra::Base
   *   get "/" do
   *     erb :home
   *   end
   * end
   * ```
   */
  class App extends DataFlow::ClassNode {
    App() { this = DataFlow::getConstant("Sinatra").getConstant("Base").getADescendentModule() }

    /**
     * Gets a route defined in this application.
     */
    Route getARoute() { result.getApp() = this }
  }

  /**
   * A Sinatra route handler. HTTP requests with a matching method and path will
   * be handled by the block. For example, the following route will handle `GET`
   * requests with path `/`.
   *
   * ```rb
   * get "/" do
   *   erb :home
   * end
   * ```
   */
  class Route extends DataFlow::CallNode {
    private App app;

    Route() {
      this =
        app.getAModuleLevelCall([
            "get", "post", "put", "patch", "delete", "options", "link", "unlink"
          ])
    }

    /**
     * Gets the application that defines this route.
     */
    App getApp() { result = app }

    /**
     * Gets the body of this route.
     */
    DataFlow::BlockNode getBody() { result = this.getBlock() }
  }

  /**
   * An access to the parameters of an HTTP request in a Sinatra route handler or callback.
   */
  private class Params extends DataFlow::CallNode, Http::Server::RequestInputAccess::Range {
    Params() {
      this.asExpr().getExpr().getEnclosingCallable() =
        [any(Route r).getBody(), any(Filter f).getBody()].asCallableAstNode() and
      this.getMethodName() = "params"
    }

    override string getSourceType() { result = "Sinatra::Base#params" }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }

  /**
   * A call which renders an ERB template as an HTTP response.
   */
  class ErbCall extends DataFlow::CallNode {
    private Route route;

    ErbCall() {
      this.asExpr().getExpr().getEnclosingCallable() = route.getBody().asCallableAstNode() and
      this.getMethodName() = "erb"
    }

    /**
     * Gets the template file corresponding to this call.
     */
    ErbFile getTemplateFile() { result = getTemplateFile(this.asExpr().getExpr()) }

    /**
     * Gets the route containing this call.
     */
    Route getRoute() { result = route }
  }

  /**
   * Gets the template file referred to by `erbCall`.
   * This works on the AST level to avoid non-monotonic reecursion in `ErbLocalsHashSyntheticGlobal`.
   */
  pragma[nomagic]
  private ErbFile getTemplateFile(MethodCall erbCall) {
    erbCall.getMethodName() = "erb" and
    result.getTemplateName() = erbCall.getArgument(0).getConstantValue().getStringlikeValue() and
    result.getRelativePath().matches("%views/%")
  }

  pragma[nomagic]
  private predicate erbCallAtLocation(MethodCall erbCall, ErbFile erbFile, Location l) {
    erbCall.getMethodName() = "erb" and
    erbFile = getTemplateFile(erbCall) and
    l = erbCall.getLocation()
  }

  /**
   * Like `Location.toString`, but displays the relative path rather than the full path.
   */
  bindingset[loc]
  pragma[inline_late]
  private string locationRelativePathToString(Location loc) {
    result =
      loc.getFile().getRelativePath() + "@" + loc.getStartLine() + ":" + loc.getStartColumn() + ":" +
        loc.getEndLine() + ":" + loc.getEndColumn()
  }

  /**
   * A synthetic global representing the hash of local variables passed to an ERB template.
   */
  class ErbLocalsHashSyntheticGlobal extends string {
    private string id;
    private MethodCall erbCall;
    private ErbFile erbFile;

    ErbLocalsHashSyntheticGlobal() {
      exists(Location l |
        erbCallAtLocation(erbCall, erbFile, l) and
        id = erbFile.getRelativePath() + "," + locationRelativePathToString(l) and
        this = "SinatraErbLocalsHash(" + id + ")"
      )
    }

    /**
     * Gets the `erb` call associated with this global.
     */
    MethodCall getErbCall() { result = erbCall }

    /**
     * Gets the ERB template that this global contains the locals for.
     */
    ErbFile getErbFile() { result = erbFile }

    /**
     * Gets a unique identifer for this global.
     */
    string getId() { result = id }
  }

  /**
   * A summary for `Sinatra::Base#erb`. This models the first half of the flow
   * from the `locals` keyword argument to variables in the ERB template. The
   * second half is modeled by `ErbLocalsAccessSummary`.
   */
  private class ErbLocalsSummary extends SummarizedCallable {
    ErbLocalsSummary() { this = "Sinatra::Base#erb" }

    override MethodCall getACall() { result = any(ErbCall c).asExpr().getExpr() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[locals:]" and
      output = "SyntheticGlobal[" + any(ErbLocalsHashSyntheticGlobal global) + "]" and
      preservesValue = true
    }
  }

  bindingset[local]
  pragma[inline_late]
  private predicate isPairKey(string local) {
    local = any(Pair p).getKey().getConstantValue().getStringlikeValue()
  }

  /**
   * A summary for accessing a local variable in an ERB template.
   * This is the second half of the modeling of the flow from the `locals`
   * keyword argument to variables in the ERB template.
   * The first half is modeled by `ErbLocalsSummary`.
   */
  private class ErbLocalsAccessSummary extends SummarizedCallable {
    private ErbLocalsHashSyntheticGlobal global;
    private string local;

    ErbLocalsAccessSummary() {
      this = "sinatra_erb_locals_access()" + global.getId() + "#" + local and
      local = any(MethodCall c | c.getLocation().getFile() = global.getErbFile()).getMethodName() and
      isPairKey(local)
    }

    override MethodCall getACall() {
      result.getLocation().getFile() = global.getErbFile() and
      result.getMethodName() = local and
      result.getReceiver() instanceof SelfVariableReadAccess
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "SyntheticGlobal[" + global + "].Element[:" + local + "]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /**
   * A class representing Sinatra filters AKA callbacks.
   *
   * Filters are run before or after the route handler. They can modify the
   * request and response, and share instance variables with the route handler.
   */
  class Filter extends DataFlow::CallNode {
    private App app;

    Filter() { this = app.getAModuleLevelCall(["before", "after"]) }

    /** Gets the app which this filter belongs to. */
    App getApp() { result = app }

    /**
     * Gets the pattern which constrains this route, if any. In the example below, the pattern is `/protected/*`.
     * Patterns are typically given as strings, and are interpreted by the `mustermann` gem (they are not regular expressions).
     * ```rb
     * before '/protected/*' do
     *   authenticate!
     * end
     * ```
     */
    DataFlow::ExprNode getPattern() { result = this.getArgument(0) }

    /**
     * Holds if this filter has a pattern.
     */
    predicate hasPattern() { exists(this.getPattern()) }

    /**
     * Gets the body of this filter.
     */
    DataFlow::BlockNode getBody() { result = this.getBlock() }
  }

  /**
   * A class for Sinatra `before` filters. These run before the route handler.
   */
  class BeforeFilter extends Filter {
    BeforeFilter() { this.getMethodName() = "before" }
  }

  /**
   * A class for Sinatra `after` filters. These run after the route handler.
   */
  class AfterFilter extends Filter {
    AfterFilter() { this.getMethodName() = "after" }
  }

  /**
   * A class defining additional jump steps arising from filters.
   * This only models flow between filters with no patterns - i.e. those that apply to all routes.
   * Filters with patterns are not yet modeled.
   */
  class FilterJumpStep extends DataFlowPrivate::AdditionalJumpStep {
    /**
     * Holds if data can flow from `pred` to `succ` via a callback chain.
     */
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(BeforeFilter filter, Route route |
        // the filter and route belong to the same app
        filter.getApp() = route.getApp() and
        // the filter applies to all routes
        not filter.hasPattern() and
        blockPostSelf(pred, filter.getBody()) and
        blockSelf(succ, route.getBody().asExpr().getExpr())
      )
    }
  }

  /** Holds if `n` is a post-update node referencing `self` in the block `b`. */
  private predicate blockPostSelf(DataFlow::PostUpdateNode n, DataFlow::BlockNode b) {
    exists(SelfVariableAccessCfgNode self |
      n.getPreUpdateNode().asExpr() = self and
      self.getScope() = b.asExpr().getAstNode()
    )
  }

  /** Holds if `n` is a node referencing `self` in the block `b`. */
  private predicate blockSelf(DataFlow::VariableAccessNode self, Block b) {
    self.getExprNode().getBasicBlock().getScope() = b and
    self.asVariableAccessAstNode().getVariable() instanceof SelfVariable
  }
}
