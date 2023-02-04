/** Provides modeling for the Sinatra library. */

private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.AST
private import codeql.ruby.dataflow.FlowSummary

/** Provides modeling for the Sinatra library. */
module Sinatra {
  class App extends DataFlow::ClassNode {
    App() { this = DataFlow::getConstant("Sinatra").getConstant("Base").getADescendentModule() }

    Route getARoute() { result.getApp() = this }
  }

  class Route extends DataFlow::CallNode {
    private App app;

    Route() {
      this =
        app.getAModuleLevelCall([
            "get", "post", "put", "patch", "delete", "options", "link", "unlink"
          ])
    }

    App getApp() { result = app }

    DataFlow::BlockNode getBody() { result = this.getBlock() }
  }

  private class Params extends DataFlow::CallNode, Http::Server::RequestInputAccess::Range {
    private Route route;

    Params() {
      this.asExpr().getExpr().getEnclosingCallable() = route.getBody().asCallableAstNode() and
      this.getMethodName() = "params"
    }

    override string getSourceType() { result = "Sinatra::Base#params" }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }

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
  }

  /**
   * Gets the template file referred to by `erbCall`.
   * This works on the AST level to avoid non-monotonic reecursion in `ErbLocalsHashSyntheticGlobal`.
   */
  private ErbFile getTemplateFile(MethodCall erbCall) {
    erbCall.getMethodName() = "erb" and
    result.getTemplateName() = erbCall.getArgument(0).getConstantValue().getStringlikeValue() and
    result.getRelativePath().matches("%views/%")
  }

  /**
   * Like `Location.toString`, but displays the relative path rather than the full path.
   */
  private string locationRelativePathToString(Location loc) {
    result =
      loc.getFile().getRelativePath() + "@" + loc.getStartLine() + ":" + loc.getStartColumn() + ":" +
        loc.getEndLine() + ":" + loc.getEndColumn()
  }

  class ErbLocalsHashSyntheticGlobal extends SummaryComponent::SyntheticGlobal {
    private string id;
    private MethodCall erbCall;
    private ErbFile erbFile;

    ErbLocalsHashSyntheticGlobal() {
      this = "SinatraErbLocalsHash(" + id + ")" and
      id = erbFile.getRelativePath() + "," + locationRelativePathToString(erbCall.getLocation()) and
      erbCall.getMethodName() = "erb" and
      erbFile = getTemplateFile(erbCall)
    }

    ErbFile getErbFile() { result = erbFile }

    string getId() { result = id }
  }

  private class ErbLocalsSummary extends SummarizedCallable {
    private ErbLocalsHashSyntheticGlobal global;

    ErbLocalsSummary() { this = "Sinatra::Base#erb" }

    override MethodCall getACall() { result = any(ErbCall c).asExpr().getExpr() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[locals:]" and
      output = "SyntheticGlobal[" + global + "]" and
      preservesValue = true
    }
  }

  private class ErbLocalsAccessSummary extends SummarizedCallable {
    private ErbLocalsHashSyntheticGlobal global;
    private string local;

    ErbLocalsAccessSummary() {
      this = "sinatra_erb_locals_access()" + global.getId() + "#" + local and
      local = any(MethodCall c | c.getLocation().getFile() = global.getErbFile()).getMethodName() and
      local = any(Pair p).getKey().getConstantValue().getStringlikeValue()
    }

    override MethodCall getACall() {
      result.getLocation().getFile() = global.getErbFile() and
      result.getMethodName() = local and
      result.getReceiver() instanceof SelfVariableReadAccess
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "SyntheticGlobal[" + global + "].Element[:" + local + "]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /**
   * Filters are run before or after the route handler. They can modify the
   * request and response, and share instance variables with the route handler.
   */
  class Filter extends DataFlow::CallNode {
    private App app;

    Filter() { this = app.getAModuleLevelCall(["before", "after"]) }

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

  class BeforeFilter extends Filter {
    BeforeFilter() { this.getMethodName() = "before" }
  }

  class AfterFilter extends Filter {
    AfterFilter() { this.getMethodName() = "after" }
  }
}
