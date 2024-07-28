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

private signature module TypeTrackInputSig {
  DataFlow::LocalSourceNode start(TypeTracker t, DataFlow::Node start);

  predicate end(DataFlow::Node n);

  predicate additionalStep(DataFlow::Node nodeFrom, DataFlow::LocalSourceNode nodeTo);
}

/**
 * Provides a version of type tracking where we first prune for reachable nodes,
 * before doing the type tracking computation.
 */
private module PrunedTypeTrack<TypeTrackInputSig Input> {
  private predicate additionalStep(
    DataFlow::LocalSourceNode nodeFrom, DataFlow::LocalSourceNode nodeTo
  ) {
    Input::additionalStep(nodeFrom.getALocalUse(), nodeTo)
  }

  /** Gets a node that is forwards reachable by type-tracking. */
  pragma[nomagic]
  private DataFlow::LocalSourceNode forward(TypeTracker t) {
    result = Input::start(t, _)
    or
    exists(TypeTracker t2 | result = forward(t2).track(t2, t))
    or
    exists(TypeTracker t2 | t2 = t.continue() | additionalStep(forward(t2), result))
  }

  bindingset[result, tbt]
  pragma[inline_late]
  pragma[noopt]
  private DataFlow::LocalSourceNode forwardLateInline(TypeBackTracker tbt) {
    exists(TypeTracker tt |
      result = forward(tt) and
      tt = tbt.getACompatibleTypeTracker()
    )
  }

  /** Gets a node that is backwards reachable by type-tracking. */
  pragma[nomagic]
  private DataFlow::LocalSourceNode backwards(TypeBackTracker t) {
    result = forwardLateInline(t) and
    (
      t.start() and
      Input::end(result.getALocalUse())
      or
      exists(TypeBackTracker t2 | result = backwards(t2).backtrack(t2, t))
      or
      exists(TypeBackTracker t2 | t2 = t.continue() | additionalStep(result, backwards(t2)))
    )
  }

  bindingset[result, tt]
  pragma[inline_late]
  pragma[noopt]
  private DataFlow::LocalSourceNode backwardsInlineLate(TypeTracker tt) {
    exists(TypeBackTracker tbt |
      result = backwards(tbt) and
      tt = tbt.getACompatibleTypeTracker()
    )
  }

  /** Holds if `n` is forwards and backwards reachable with type tracker `t`. */
  pragma[nomagic]
  private predicate reached(DataFlow::LocalSourceNode n, TypeTracker t) {
    n = forward(t) and
    n = backwardsInlineLate(t)
  }

  pragma[nomagic]
  private TypeTracker stepReached(
    TypeTracker t, DataFlow::LocalSourceNode nodeFrom, DataFlow::LocalSourceNode nodeTo
  ) {
    exists(StepSummary summary |
      step(nodeFrom, nodeTo, summary) and
      reached(nodeFrom, t) and
      reached(nodeTo, result) and
      result = append(t, summary)
    )
    or
    additionalStep(nodeFrom, nodeTo) and
    reached(nodeFrom, pragma[only_bind_into](t)) and
    reached(nodeTo, pragma[only_bind_into](t)) and
    result = t.continue()
  }

  /** Gets a node that has been tracked from the start node `start`. */
  DataFlow::LocalSourceNode track(DataFlow::Node start, TypeTracker t) {
    t.start() and
    result = Input::start(t, start) and
    reached(result, t)
    or
    exists(TypeTracker t2 | t = stepReached(t2, track(start, t2), result))
  }
}

/** Holds if `inputStr` is compiled to a regular expression that is returned at `call`. */
pragma[nomagic]
private predicate regFromString(DataFlow::LocalSourceNode inputStr, DataFlow::CallNode call) {
  exists(DataFlow::Node mid |
    inputStr.flowsTo(mid) and
    call = API::getTopLevelMember("Regexp").getAMethodCall(["compile", "new"]) and
    mid = call.getArgument(0)
  )
}

private module StringTypeTrackInput implements TypeTrackInputSig {
  DataFlow::LocalSourceNode start(TypeTracker t, DataFlow::Node start) {
    start = strStart() and t.start() and result = start
  }

  predicate end(DataFlow::Node n) {
    n = stringSink() or
    regFromString(n, _)
  }

  predicate additionalStep(DataFlow::Node nodeFrom, DataFlow::LocalSourceNode nodeTo) {
    // include taint flow through `String` summaries
    TaintTrackingPrivate::summaryThroughStepTaint(nodeFrom, nodeTo,
      any(String::SummarizedCallable c))
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

/**
 * Gets a node that has been tracked from the string constant `start` to some node.
 * This is used to figure out where `start` is evaluated as a regular expression against an input string,
 * or where `start` is compiled into a regular expression.
 */
private predicate trackStrings = PrunedTypeTrack<StringTypeTrackInput>::track/2;

/** Holds if `strConst` flows to a regex compilation (tracked by `t`), where the resulting regular expression is stored in `reg`. */
pragma[nomagic]
private predicate regFromStringStart(DataFlow::Node strConst, TypeTracker t, DataFlow::CallNode reg) {
  regFromString(trackStrings(strConst, t), reg) and
  exists(t.continue())
}

private module RegTypeTrackInput implements TypeTrackInputSig {
  DataFlow::LocalSourceNode start(TypeTracker t, DataFlow::Node start) {
    start = regStart() and
    t.start() and
    result = start
    or
    regFromStringStart(start, t, result)
  }

  predicate end(DataFlow::Node n) { n = regSink() }

  predicate additionalStep(DataFlow::Node nodeFrom, DataFlow::LocalSourceNode nodeTo) { none() }
}

/**
 * Gets a node that has been tracked from the regular expression `start` to some node.
 * This is used to figure out where `start` is executed against an input string.
 */
private predicate trackRegs = PrunedTypeTrack<RegTypeTrackInput>::track/2;

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
