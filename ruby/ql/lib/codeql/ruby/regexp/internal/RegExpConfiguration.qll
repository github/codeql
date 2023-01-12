private import codeql.ruby.Regexp
private import codeql.ruby.AST as Ast
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.internal.DataFlowImplForRegExp
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.TaintTracking
private import codeql.ruby.frameworks.core.String

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

  override predicate isBarrier(DataFlow::Node node) {
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

  override predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // include taint flow through `String` summaries
    TaintTracking::localTaintStep(nodeFrom, nodeTo) and
    nodeFrom.(DataFlowPrivate::SummaryNode).getSummarizedCallable() instanceof
      String::SummarizedCallable
    or
    // string concatenations, and
    exists(CfgNodes::ExprNodes::OperationCfgNode op |
      op = nodeTo.asExpr() and
      op.getAnOperand() = nodeFrom.asExpr() and
      op.getExpr().(Ast::BinaryOperation).getOperator() = "+"
    )
    or
    // string interpolations
    nodeFrom.asExpr() =
      nodeTo.asExpr().(CfgNodes::ExprNodes::StringlikeLiteralCfgNode).getAComponent()
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
