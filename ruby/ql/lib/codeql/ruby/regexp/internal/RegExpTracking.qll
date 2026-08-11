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
private import codeql.ruby.typetracking.internal.TypeTrackingImpl
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.dataflow.internal.TaintTrackingPrivate as TaintTrackingPrivate
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

private module RegexConfig implements DataFlow::StateConfigSig {
  private newtype TFlowState =
    TStringState() or
    TRegExpState()

  class FlowState = TFlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    state = TStringState() and source = strStart()
    or
    state = TRegExpState() and source = regStart()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    state = TStringState() and sink = stringSink()
    or
    state = TRegExpState() and sink = regSink()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    regFromString(node1, node2) and state1 = TStringState() and state2 = TRegExpState()
    or
    state1 = TStringState() and
    state2 = TStringState() and
    (
      // include taint flow through `String` summaries
      TaintTrackingPrivate::summaryThroughStepTaint(node1, node2, any(String::SummarizedCallable c))
      or
      // string concatenations, and
      exists(CfgNodes::ExprNodes::OperationCfgNode op |
        op = node2.asExpr() and
        op.getAnOperand() = node1.asExpr() and
        op.getExpr().(Ast::BinaryOperation).getOperator() = "+"
      )
      or
      // string interpolations
      node1.asExpr() =
        node2.asExpr().(CfgNodes::ExprNodes::StringlikeLiteralCfgNode).getAComponent()
    )
  }

  int accessPathLimit() { result = 1 }
}

private module RegexTracking = DataFlow::GlobalWithState<RegexConfig>;

/** Holds if `inputStr` is compiled to a regular expression that is returned at `call`. */
pragma[nomagic]
private predicate regFromString(DataFlow::Node inputStr, DataFlow::CallNode call) {
  call = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"]) and
  inputStr = call.getArgument(0)
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
DataFlow::Node regExpSource(DataFlow::Node re) { RegexTracking::flow(result, re) }
