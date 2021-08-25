/**
 * Provides Ruby specific classes and predicates for defining flow summaries.
 */

private import ruby
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowPublic
private import DataFlowImplCommon
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import codeql.ruby.dataflow.FlowSummary as FlowSummary

/** Holds is `i` is a valid parameter position. */
predicate parameterPosition(int i) { i in [-2 .. 10] }

/** Gets the synthesized summary data-flow node for the given values. */
Node summaryNode(SummarizedCallable c, SummaryNodeState state) { result = TSummaryNode(c, state) }

/** Gets the synthesized data-flow call for `receiver`. */
SummaryCall summaryDataFlowCall(Node receiver) { receiver = result.getReceiver() }

/** Gets the type of content `c`. */
DataFlowType getContentType(Content c) { any() }

/** Gets the return type of kind `rk` for callable `c`. */
bindingset[c, rk]
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) { any() }

/**
 * Gets the type of the `i`th parameter in a synthesized call that targets a
 * callback of type `t`.
 */
bindingset[t, i]
DataFlowType getCallbackParameterType(DataFlowType t, int i) { any() }

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) { any() }

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, and kind `kind`.
 */
predicate summaryElement(DataFlowCallable c, string input, string output, string kind) {
  exists(FlowSummary::SummarizedCallable sc |
    sc.propagatesFlowExt(input, output, kind) and
    c.asLibraryCallable() = sc
  )
}

/**
 * Holds if an external source specification exists for `e` with output specification
 * `output` and kind `kind`.
 */
predicate sourceElement(AstNode n, string output, string kind) { none() }

/**
 * Holds if an external sink specification exists for `n` with input specification
 * `input` and kind `kind`.
 */
predicate sinkElement(AstNode n, string input, string kind) { none() }

/** Gets the summary component for specification component `c`, if any. */
SummaryComponent interpretComponentSpecific(string c) {
  c = "BlockArgument" and
  result = FlowSummary::SummaryComponent::block()
}

class SourceOrSinkElement = AstNode;

/** Gets the return kind corresponding to specification `"ReturnValue"`. */
NormalReturnKind getReturnValueKind() { any() }

/** An entity used to interpret a source/sink specification. */
class InterpretNode extends AstNode {
  /** Gets the element that this node corresponds to, if any. */
  SourceOrSinkElement asElement() { none() }

  /** Gets the data-flow node that this node corresponds to, if any. */
  Node asNode() { none() }

  /** Gets the call that this node corresponds to, if any. */
  DataFlowCall asCall() { none() }

  /** Gets the callable that this node corresponds to, if any. */
  DataFlowCallable asCallable() { none() }

  /** Gets the target of this call, if any. */
  Callable getCallTarget() { none() }
}

/** Provides additional sink specification logic required for attributes. */
predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) { none() }

/** Provides additional sink specification logic required for attributes. */
predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode n) { none() }
