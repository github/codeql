/**
 * Provides predicates that track strings and regular expressions to where they are used.
 * This is implemented using TypeTracking in two phases:
 *
 * 1: An exploratory analysis that just imprecisely tracks all string and regular expressions
 * to all places where regular expressions (as string or as regular expression objects) can be used.
 * The exploratory phase then ends with a backwards analysis from the uses that were reached.
 * This is similar to the exploratory phase of the JavaScript global DataFlow library.
 *
 * 2: A precise type tracking analysis that tracks
 * strings and regular expressions to the places where they are used.
 * This phase keeps track of which strings and regular expressions end up in which places.
 */

private import codeql.ruby.Regexp as RE
private import codeql.ruby.AST as Ast
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.TaintTracking
private import codeql.ruby.frameworks.core.String

/** Gets a constant string value that may be used as a regular expression. */
DataFlow::LocalSourceNode strStart() {
  result.asExpr() =
    any(ExprCfgNode e |
      e.getConstantValue().isString(_) and
      not e instanceof ExprNodes::VariableReadAccessCfgNode and
      not e instanceof ExprNodes::ConstantReadAccessCfgNode
    )
}

/** Gets a dataflow node for a regular expression literal. */
DataFlow::LocalSourceNode regStart() { result.asExpr().getExpr() instanceof Ast::RegExpLiteral }

/**
 * Holds if the analysis should track flow from `nodeFrom` to `nodeTo` on top of the ordinary type-tracking steps.
 * `nodeFrom` and `nodeTo` has type `fromType` and `toType` respectively.
 * The types are either "string" or "regexp".
 */
predicate step(
  DataFlow::Node nodeFrom, DataFlow::LocalSourceNode nodeTo, string fromType, string toType
) {
  fromType = toType and
  fromType = "string" and
  (
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
  )
  or
  fromType = "string" and
  toType = "reg" and
  exists(DataFlow::CallNode call |
    call = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"]) and
    nodeFrom = call.getArgument(0) and
    nodeTo = call
  )
}

/** Gets a node where string values that flow to the node are interpreted as regular expressions. */
DataFlow::Node stringSink() {
  result instanceof RE::RegExpInterpretation::Range and
  not exists(DataFlow::CallNode mce | mce.getMethodName() = ["match", "match?"] |
    // receiver of https://ruby-doc.org/core-2.4.0/String.html#method-i-match
    result = mce.getReceiver() and
    mce.getArgument(0) = trackRegexpType()
    or
    // first argument of https://ruby-doc.org/core-2.4.0/Regexp.html#method-i-match
    result = mce.getArgument(0) and
    mce.getReceiver() = trackRegexpType()
  )
}

/** Gets a node where regular expressions that flow to the node are used. */
DataFlow::Node regSink() { result = any(RegexExecution exec).getRegex() }

/** Gets a node that is reachable by type-tracking from any string or regular expression. */
DataFlow::LocalSourceNode forward(TypeTracker t) {
  t.start() and
  result = [strStart(), regStart()]
  or
  exists(TypeTracker t2 | result = forward(t2).track(t2, t))
  or
  exists(TypeTracker t2 | t2 = t.continue() | step(forward(t2).getALocalUse(), result, _, _))
}

/**
 * Gets a node that is backwards reachable from any regular expression use,
 * where that use is reachable by type-tracking from any string or regular expression.
 */
DataFlow::LocalSourceNode backwards(TypeBackTracker t) {
  t.start() and
  result.flowsTo([stringSink(), regSink()]) and
  result = forward(TypeTracker::end())
  or
  exists(TypeBackTracker t2 | result = backwards(t2).backtrack(t2, t))
  or
  exists(TypeBackTracker t2 | t2 = t.continue() | step(result.getALocalUse(), backwards(t2), _, _))
}

/**
 * Gets a node that has been tracked from the string constant `start` to some node.
 * This is used to figure out where `start` is evaluated as a regular expression against an input string,
 * or where `start` is compiled into a regular expression.
 */
private DataFlow::LocalSourceNode trackStrings(DataFlow::Node start, TypeTracker t) {
  result = backwards(_) and
  (
    t.start() and
    start = result and
    result = strStart()
    or
    exists(TypeTracker t2 | result = trackStrings(start, t2).track(t2, t))
    or
    // an additional step from string to string
    exists(TypeTracker t2 | t2 = t.continue() |
      step(trackStrings(start, t2).getALocalUse(), result, "string", "string")
    )
  )
}

/**
 * Gets a node that has been tracked from the regular expression `start` to some node.
 * This is used to figure out where `start` is executed against an input string.
 */
private DataFlow::LocalSourceNode trackRegs(DataFlow::Node start, TypeTracker t) {
  result = backwards(_) and
  (
    t.start() and
    start = result and
    result = regStart()
    or
    exists(TypeTracker t2 | result = trackRegs(start, t2).track(t2, t))
    or
    // an additional step where a string is converted to a regular expression
    exists(TypeTracker t2 | t2 = t.continue() |
      step(trackStrings(start, t2).getALocalUse(), result, "string", "reg")
    )
  )
}

/** Gets a node that references a regular expression. */
private DataFlow::LocalSourceNode trackRegexpType(TypeTracker t) {
  t.start() and
  (
    result = regStart() or
    result = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"])
  )
  or
  exists(TypeTracker t2 | result = trackRegexpType(t2).track(t2, t))
}

/** Gets a node that references a regular expression. */
DataFlow::Node trackRegexpType() { trackRegexpType(TypeTracker::end()).flowsTo(result) }

/** Gets a node holding a value for the regular expression that is evaluated at `re`. */
cached
DataFlow::Node regExpSource(DataFlow::Node re) {
  exists(DataFlow::LocalSourceNode end | end = trackStrings(result, TypeTracker::end()) |
    end.getALocalUse() = re and re = stringSink()
  )
  or
  exists(DataFlow::LocalSourceNode end | end = trackRegs(result, TypeTracker::end()) |
    end.getALocalUse() = re and re = regSink()
  )
}
