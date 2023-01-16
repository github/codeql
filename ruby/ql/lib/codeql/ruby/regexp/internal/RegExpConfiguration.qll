private import codeql.ruby.Regexp as RE
private import codeql.ruby.AST as Ast
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.internal.DataFlowImplForRegExp
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.TaintTracking
private import codeql.ruby.frameworks.core.String

/**
 * Gets a node that has been tracked from the string constant `start` to some node.
 * This is used to figure out where `start` is evaluated as a regular expression against an input string,
 * or where `start` is compiled into a regular expression.
 */
private DataFlow::LocalSourceNode strToReg(DataFlow::Node start, TypeTracker t) {
  t.start() and
  start = result and
  result.asExpr() =
    any(ExprCfgNode e |
      e.getConstantValue().isString(_) and
      not e instanceof ExprNodes::VariableReadAccessCfgNode and
      not e instanceof ExprNodes::ConstantReadAccessCfgNode
    )
  or
  exists(TypeTracker t2 | result = strToReg(start, t2).track(t2, t))
  or
  exists(TypeTracker t2, DataFlow::Node nodeFrom | t2 = t.continue() |
    strToReg(start, t2).flowsTo(nodeFrom) and
    (
      // include taint flow through `String` summaries
      TaintTracking::localTaintStep(nodeFrom, result) and
      nodeFrom.(DataFlowPrivate::SummaryNode).getSummarizedCallable() instanceof
        String::SummarizedCallable
      or
      // string concatenations, and
      exists(CfgNodes::ExprNodes::OperationCfgNode op |
        op = result.asExpr() and
        op.getAnOperand() = nodeFrom.asExpr() and
        op.getExpr().(Ast::BinaryOperation).getOperator() = "+"
      )
      or
      // string interpolations
      nodeFrom.asExpr() =
        result.asExpr().(CfgNodes::ExprNodes::StringlikeLiteralCfgNode).getAComponent()
    )
  )
}

/**
 * Gets a node that has been tracked from the regular expression `start` to some node.
 * This is used to figure out where `start` is executed against an input string.
 */
private DataFlow::LocalSourceNode regToReg(DataFlow::Node start, TypeTracker t) {
  t.start() and
  start = result and
  result.asExpr().getExpr() instanceof Ast::RegExpLiteral
  or
  exists(TypeTracker t2 | result = regToReg(start, t2).track(t2, t))
  or
  exists(TypeTracker t2 |
    t2 = t.continue() and
    exists(DataFlow::CallNode call |
      call = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"]) and
      strToReg(start, t2).flowsTo(call.getArgument(0)) and
      result = call
    )
  )
}

/** Gests a node that references a regular expression. */
private DataFlow::LocalSourceNode trackRegexpType(TypeTracker t) {
  t.start() and
  (
    result.asExpr().getExpr() instanceof Ast::RegExpLiteral or
    result = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"])
  )
  or
  exists(TypeTracker t2 | result = trackRegexpType(t2).track(t2, t))
}

/** Gests a node that references a regular expression. */
DataFlow::Node trackRegexpType() { trackRegexpType(TypeTracker::end()).flowsTo(result) }

/** Gets a the value for the regular expression that is evaluated at `re`. */
cached
DataFlow::Node regExpSource(DataFlow::Node re) {
  exists(DataFlow::LocalSourceNode end | end = strToReg(result, TypeTracker::end()) |
    end.flowsTo(re) and
    re instanceof RE::RegExpInterpretation::Range and
    not exists(DataFlow::CallNode mce | mce.getMethodName() = ["match", "match?"] |
      // receiver of https://ruby-doc.org/core-2.4.0/String.html#method-i-match
      re = mce.getReceiver() and
      mce.getArgument(0) = trackRegexpType()
      or
      // first argument of https://ruby-doc.org/core-2.4.0/Regexp.html#method-i-match
      re = mce.getArgument(0) and
      mce.getReceiver() = trackRegexpType()
    )
  )
  or
  exists(DataFlow::LocalSourceNode end | end = regToReg(result, TypeTracker::end()) |
    end.flowsTo(re) and
    re = any(RegexExecution exec).getRegex()
  )
}
