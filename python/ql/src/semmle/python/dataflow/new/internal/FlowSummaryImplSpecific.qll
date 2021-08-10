/**
 * Provides Python specific classes and predicates for definining flow summaries.
 */

private import python
private import DataFlowPrivate
private import DataFlowUtil
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public

// private import semmle.python.dataflow.ExternalFlow
private module FlowSummaries {
  private import semmle.python.dataflow.FlowSummary as F
}

/** Holds if `i` is a valid parameter position. */
predicate parameterPosition(int i) { i in [0 .. any(Parameter p).getPosition()] }

/** Gets the synthesized summary data-flow node for the given values. */
Node summaryNode(SummarizedCallable c, SummaryNodeState state) { result = getSummaryNode(c, state) }

/** Gets the synthesized data-flow call for `receiver`. */
DataFlowCall summaryDataFlowCall(Node receiver) { none() }

/** Gets the type of content `c`. */
DataFlowType getContentType(Content c) { none() }

/** Gets the return type of kind `rk` for callable `c`. */
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) { none() }

/**
 * Gets the type of the `i`th parameter in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackParameterType(DataFlowType t, int i) { none() }

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) { none() }

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, and kind `kind`.
 */
predicate summaryElement(DataFlowCallable c, string input, string output, string kind) { none() }

/** Gets the summary component for specification component `c`, if any. */
bindingset[c]
SummaryComponent interpretComponentSpecific(string c) { none() }

class SourceOrSinkElement = AstNode; // TODO: Check

/**
 * Holds if an external source specification exists for `e` with output specification
 * `output` and kind `kind`.
 */
predicate sourceElement(SourceOrSinkElement e, string output, string kind) { none() }

/**
 * Holds if an external sink specification exists for `e` with input specification
 * `input` and kind `kind`.
 */
predicate sinkElement(SourceOrSinkElement e, string input, string kind) { none() }

/** Gets the return kind corresponding to specification `"ReturnValue"`. */
ReturnKind getReturnValueKind() { any() }

private newtype TInterpretNode =
  TElement(SourceOrSinkElement n) or
  TINode(Node n)

/** An entity used to interpret a source/sink specification. */
class InterpretNode extends TInterpretNode {
  /** Gets the element that this node corresponds to, if any. */
  SourceOrSinkElement asElement() { none() }

  /** Gets the data-flow node that this node corresponds to, if any. */
  Node asNode() { none() }

  /** Gets the call that this node corresponds to, if any. */
  DataFlowCall asCall() { none() }

  /** Gets the callable that this node corresponds to, if any. */
  DataFlowCallable asCallable() { none() }

  /** Gets the target of this call, if any. */
  SourceOrSinkElement getCallTarget() { none() }

  /** Gets a textual representation of this node. */
  string toString() {
    result = this.asElement().toString()
    or
    result = this.asNode().toString()
  }

  /** Gets the location of this node. */
  Location getLocation() {
    result = this.asElement().getLocation()
    or
    result = this.asNode().getLocation()
  }
}

/** Provides additional sink specification logic required for annotations. */
pragma[inline]
predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) { none() }

/** Provides additional source specification logic required for annotations. */
pragma[inline]
predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode n) { none() }
