/**
 * Provides Python specific classes and predicates for defining flow summaries.
 *
 * Flow summaries are defined for callables that are not extracted.
 * Such callables go by different names in different parts of our codebase:
 *
 * - in `FlowSummary.qll`, which is user facing, they are called `SummarizedCallable`s.
 *   These contain summaries, implemented by the user via the predicates `propagatesFlow` and `propagatesFlowExt`.
 *
 * - in the data flow layer, they are called `LibraryCallable`s (as in the Ruby codebase).
 *   These are identified by strings and has predicates for finding calls to them.
 *
 * Having both extracted and non-extracted callables means that we now have three types of calls:
 * - Extracted calls to extracted callables, either `NormalCall` or `SpecialCall`. These are handled by standard data flow.
 * - Extracted calls to non-extracted callables, `LibraryCall`. These are handled by looking up the relevant summary when the
 *   global data flow graph is connected up via `getViableCallable`.
 * - Non-extracted calls, `SummaryCall`. These are synthesised by the flow summary framework.
 *
 * The first two can be referred to as `ExtractedDataFlowCall`. In fact, `LibraryCall` is a subclass of `NormalCall`, where
 * `getCallable` is set to `none()`. The member predicate `ExtractedDataFlowCall::getCallable` is _not_ the mechanism for
 * call resolution in global data flow. That mechanism is `getViableCallable`.
 * Resolving a call to a non-extracted callable goes via `LibraryCallable::getACall`, which may involve type tracking.
 * To avoid that type tracking becomes mutually recursive with data flow, type tracking must use a call graph not including summaries.
 * Type tracking sees the callgraph given by `ExtractedDataFlowCall::getACallable`.
 *
 * We do not support summaries of special methods via the special methods framework,
 * the summary would have to identify the call.
 *
 * We might, while we still extract the standard library, want to support flow summaries of
 * extracted callables, so that we can model part of the standard library with flow summaries.
 * For this to work, we have be careful with the enclosing callable predicate.
 */

private import python
private import DataFlowPrivate
private import DataFlowPublic
private import DataFlowImplCommon
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import semmle.python.dataflow.new.FlowSummary as FlowSummary

class SummarizedCallableBase = string;

/** View a `SummarizedCallable` as a `DataFlowCallable`. */
DataFlowCallable inject(SummarizedCallable c) { result.asLibraryCallable() = c }

/** Gets the parameter position of the instance parameter. */
ArgumentPosition callbackSelfParameterPosition() { none() } // disables implicit summary flow to `this` for callbacks

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
 * Gets the type of the parameter matching arguments at position `pos` in a
 * synthesized call that targets a callback of type `t`.
 */
bindingset[t, pos]
DataFlowType getCallbackParameterType(DataFlowType t, ArgumentPosition pos) { any() }

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) { any() }

/** Gets the type of synthetic global `sg`. */
DataFlowType getSyntheticGlobalType(SummaryComponent::SyntheticGlobal sg) { any() }

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, kind `kind`, and provenance `provenance`.
 */
predicate summaryElement(
  FlowSummary::SummarizedCallable c, string input, string output, string kind, string provenance
) {
  exists(boolean preservesValue |
    c.propagatesFlowExt(input, output, preservesValue) and
    (if preservesValue = true then kind = "value" else kind = "taint") and
    provenance = "manual"
  )
}

/**
 * Holds if a neutral model exists for `c` with provenance `provenance`,
 * which means that there is no flow through `c`.
 * Note. Neutral models have not been implemented for Python.
 */
predicate neutralElement(FlowSummary::SummarizedCallable c, string provenance) { none() }

/**
 * Gets the summary component for specification component `c`, if any.
 *
 * This covers all the Python-specific components of a flow summary.
 */
SummaryComponent interpretComponentSpecific(AccessPathToken c) {
  c = "ListElement" and
  result = FlowSummary::SummaryComponent::listElement()
}

/** Gets the textual representation of a summary component in the format used for flow summaries. */
string getComponentSpecific(SummaryComponent sc) {
  sc = TContentSummaryComponent(any(ListElementContent c)) and
  result = "ListElement"
}

/** Gets the textual representation of a parameter position in the format used for flow summaries. */
string getParameterPosition(ParameterPosition pos) {
  pos.isSelf() and result = "self"
  or
  exists(int i |
    pos.isPositional(i) and
    result = i.toString()
  )
  or
  exists(string name |
    pos.isKeyword(name) and
    result = name + ":"
  )
}

/** Gets the textual representation of an argument position in the format used for flow summaries. */
string getArgumentPosition(ArgumentPosition pos) {
  pos.isSelf() and result = "self"
  or
  exists(int i |
    pos.isPositional(i) and
    result = i.toString()
  )
  or
  exists(string name |
    pos.isKeyword(name) and
    result = name + ":"
  )
}

/** Holds if input specification component `c` needs a reference. */
predicate inputNeedsReferenceSpecific(string c) { none() }

/** Holds if output specification component `c` needs a reference. */
predicate outputNeedsReferenceSpecific(string c) { none() }

/** Gets the return kind corresponding to specification `"ReturnValue"`. */
ReturnKind getReturnValueKind() { any() }

/**
 * All definitions in this module are required by the shared implementation
 * (for source/sink interpretation), but they are unused for Python, where
 * we rely on API graphs instead.
 */
private module UnusedSourceSinkInterpretation {
  /**
   * Holds if an external source specification exists for `n` with output specification
   * `output`, kind `kind`, and provenance `provenance`.
   */
  predicate sourceElement(AstNode n, string output, string kind, string provenance) { none() }

  /**
   * Holds if an external sink specification exists for `n` with input specification
   * `input`, kind `kind` and provenance `provenance`.
   */
  predicate sinkElement(AstNode n, string input, string kind, string provenance) { none() }

  class SourceOrSinkElement = AstNode;

  /** An entity used to interpret a source/sink specification. */
  class InterpretNode extends AstNode_ {
    // InterpretNode is going away, this is just a dummy implementation.
    // However, we have some old location tests picking them up, so we
    // explicitly define them to not exist.
    InterpretNode() { none() }

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
  }

  /** Provides additional sink specification logic. */
  predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) { none() }

  /** Provides additional source specification logic. */
  predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode node) { none() }
}

import UnusedSourceSinkInterpretation

module ParsePositions {
  private import FlowSummaryImpl

  private predicate isParamBody(string body) {
    exists(AccessPathToken tok |
      tok.getName() = "Parameter" and
      body = tok.getAnArgument()
    )
  }

  private predicate isArgBody(string body) {
    exists(AccessPathToken tok |
      tok.getName() = "Argument" and
      body = tok.getAnArgument()
    )
  }

  predicate isParsedPositionalParameterPosition(string c, int i) {
    isParamBody(c) and
    i = AccessPath::parseInt(c)
  }

  predicate isParsedKeywordParameterPosition(string c, string paramName) {
    isParamBody(c) and
    c = paramName + ":"
  }

  predicate isParsedPositionalArgumentPosition(string c, int i) {
    isArgBody(c) and
    i = AccessPath::parseInt(c)
  }

  predicate isParsedKeywordArgumentPosition(string c, string argName) {
    isArgBody(c) and
    c = argName + ":"
  }
}

/** Gets the argument position obtained by parsing `X` in `Parameter[X]`. */
ArgumentPosition parseParamBody(string s) {
  exists(int i |
    ParsePositions::isParsedPositionalParameterPosition(s, i) and
    result.isPositional(i)
  )
  or
  exists(string name |
    ParsePositions::isParsedKeywordParameterPosition(s, name) and
    result.isKeyword(name)
  )
  or
  s = "self" and
  result.isSelf()
}

/** Gets the parameter position obtained by parsing `X` in `Argument[X]`. */
ParameterPosition parseArgBody(string s) {
  exists(int i |
    ParsePositions::isParsedPositionalArgumentPosition(s, i) and
    result.isPositional(i)
  )
  or
  exists(string name |
    ParsePositions::isParsedKeywordArgumentPosition(s, name) and
    result.isKeyword(name)
  )
  or
  s = "self" and
  result.isSelf()
}
