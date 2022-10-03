private import codeql.ruby.Regexp
private import codeql.ruby.ast.Literal as Ast
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.internal.tainttrackingforregexp.TaintTrackingImpl
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.ApiGraphs

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
    exists(DataFlow::CallNode mce | mce.getMethodName() = ["match", "match?"] |
      // receiver of https://ruby-doc.org/core-2.4.0/String.html#method-i-match
      node = mce.getReceiver() and
      mce.getArgument(0) = trackRegexpType()
      or
      // first argument of https://ruby-doc.org/core-2.4.0/Regexp.html#method-i-match
      node = mce.getArgument(0) and
      mce.getReceiver() = trackRegexpType()
    )
  }
}

private DataFlow::LocalSourceNode trackRegexpType(TypeTracker t) {
  t.start() and
  (
    result.asExpr().getExpr() instanceof Ast::RegExpLiteral or
    result = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"])
  )
  or
  exists(TypeTracker t2 | result = trackRegexpType(t2).track(t2, t))
}

DataFlow::Node trackRegexpType() { trackRegexpType(TypeTracker::end()).flowsTo(result) }
