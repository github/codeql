private import codeql.ruby.Regexp
private import codeql.ruby.ast.Literal as Ast
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.internal.tainttrackingforlibraries.TaintTrackingImpl

class RegExpConfiguration extends Configuration {
  RegExpConfiguration() { this = "RegExpConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() =
      any(ExprCfgNode e |
        e.getConstantValue().isString(_) and
        not e instanceof ExprNodes::VariableReadAccessCfgNode and
        not e instanceof ExprNodes::ConstantReadAccessCfgNode
      )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegExpInterpretation::Range }

  override predicate isSanitizer(DataFlow::Node node) {
    // stop flow if `node` is receiver of
    // https://ruby-doc.org/core-2.4.0/String.html#method-i-match
    exists(DataFlow::CallNode mce |
      mce.getMethodName() = ["match", "match?"] and
      node = mce.getReceiver() and
      mce.getArgument(0).asExpr().getExpr() instanceof Ast::RegExpLiteral
    )
  }
}
