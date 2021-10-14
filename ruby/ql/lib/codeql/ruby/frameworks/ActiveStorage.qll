private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

class ActiveStorageFilenameSanitizedCall extends Path::PathSanitization::Range, DataFlow::CallNode {
  ActiveStorageFilenameSanitizedCall() {
    this.getReceiver() =
      API::getTopLevelMember("ActiveStorage").getMember("Filename").getAnInstantiation() and
    this.asExpr().getExpr().(MethodCall).getMethodName() = "sanitized"
  }
}
