/** Provides modeling for the Sinatra library. */

private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.AST
private import codeql.ruby.dataflow.FlowSummary

/** Provides modeling for the Sinatra library. */
module Sinatra {
  private class App extends DataFlow::ClassNode {
    App() { this = DataFlow::getConstant("Sinatra").getConstant("Base").getADescendentModule() }

    Route getRoute() { result.getApp() = this }
  }

  private class Route extends DataFlow::CallNode {
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

  private class ErbCall extends DataFlow::CallNode {
    private Route route;

    ErbCall() {
      this.asExpr().getExpr().getEnclosingCallable() = route.getBody().asCallableAstNode() and
      this.getMethodName() = "erb"
    }

    ErbFile getTemplateFile() {
      result.getTemplateName() =
        this.getArgument(0).asExpr().getConstantValue().getStringlikeValue() and
      result.getRelativePath().matches("%views/%")
    }
  }

  ErbFile getTemplateFile(MethodCall erbCall) {
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

  private class ErbLocalsHashSyntheticGlobal extends SummaryComponent::SyntheticGlobal {
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
      input = "Argument[2]" and output = "SyntheticGlobal[" + global + "]" and preservesValue = true
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
}
