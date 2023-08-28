/**
 * Provides Ruby specific classes and predicates for defining flow summaries.
 */

private import codeql.ruby.AST
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowPublic
private import DataFlowImplCommon
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import codeql.ruby.dataflow.FlowSummary as FlowSummary

/**
 * A class of callables that are candidates for flow summary modeling.
 */
class SummarizedCallableBase = string;

/**
 * A class of callables that are candidates for neutral modeling.
 */
class NeutralCallableBase = string;

DataFlowCallable inject(SummarizedCallable c) { result.asLibraryCallable() = c }

/** Gets the parameter position representing a callback itself, if any. */
ArgumentPosition callbackSelfParameterPosition() { none() } // disables implicit summary flow to `self` for callbacks

/** Gets the synthesized data-flow call for `receiver`. */
SummaryCall summaryDataFlowCall(SummaryNode receiver) { receiver = result.getReceiver() }

/** Gets the type of content `c`. */
DataFlowType getContentType(ContentSet c) { any() }

/** Gets the type of the parameter at the given position. */
DataFlowType getParameterType(SummarizedCallable c, ParameterPosition pos) { any() }

/** Gets the return type of kind `rk` for callable `c`. */
bindingset[c, rk]
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) { any() }

/**
 * Gets the type of the `i`th parameter in a synthesized call that targets a
 * callback of type `t`.
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
 * Holds if a neutral model exists for `c` of kind `kind`
 * and with provenance `provenance`.
 * Note. Neutral models have not been implemented for Ruby.
 */
predicate neutralElement(NeutralCallableBase c, string kind, string provenance) { none() }

bindingset[arg]
private SummaryComponent interpretElementArg(string arg) {
  arg = "?" and
  result = FlowSummary::SummaryComponent::elementUnknown()
  or
  arg = "any" and
  result = FlowSummary::SummaryComponent::elementAny()
  or
  exists(int lower, boolean includeUnknown |
    ParsePositions::isParsedElementLowerBoundPosition(arg, includeUnknown, lower)
  |
    includeUnknown = false and
    result = FlowSummary::SummaryComponent::elementLowerBound(lower)
    or
    includeUnknown = true and
    result = FlowSummary::SummaryComponent::elementLowerBoundOrUnknown(lower)
  )
  or
  exists(ConstantValue cv, string argAdjusted, boolean includeUnknown |
    argAdjusted = ParsePositions::adjustElementArgument(arg, includeUnknown) and
    (
      includeUnknown = false and
      result = FlowSummary::SummaryComponent::elementKnown(cv)
      or
      includeUnknown = true and
      result = FlowSummary::SummaryComponent::elementKnownOrUnknown(cv)
    )
  |
    cv.isInt(AccessPath::parseInt(argAdjusted))
    or
    not exists(AccessPath::parseInt(argAdjusted)) and
    cv.serialize() = argAdjusted
  )
}

/**
 * Gets the summary component for specification component `c`, if any.
 *
 * This covers all the Ruby-specific components of a flow summary.
 */
SummaryComponent interpretComponentSpecific(AccessPathToken c) {
  exists(string arg, ParameterPosition ppos |
    arg = c.getAnArgument("Argument") and
    result = FlowSummary::SummaryComponent::argument(ppos)
  |
    arg = "any" and
    ppos.isAny()
    or
    ppos.isPositionalLowerBound(AccessPath::parseLowerBound(arg))
    or
    arg = "hash-splat" and
    ppos.isHashSplat()
  )
  or
  result = interpretElementArg(c.getAnArgument("Element"))
  or
  result =
    FlowSummary::SummaryComponent::content(TSingletonContent(TFieldContent(c.getAnArgument("Field"))))
  or
  exists(ContentSet cs |
    FlowSummary::SummaryComponent::content(cs) = interpretElementArg(c.getAnArgument("WithElement")) and
    result = FlowSummary::SummaryComponent::withContent(cs)
  )
  or
  exists(ContentSet cs |
    FlowSummary::SummaryComponent::content(cs) =
      interpretElementArg(c.getAnArgument("WithoutElement")) and
    result = FlowSummary::SummaryComponent::withoutContent(cs)
  )
}

private string getContentSpecific(Content c) {
  exists(string name | c = TFieldContent(name) and result = "Field[" + name + "]")
  or
  exists(ConstantValue cv |
    c = TKnownElementContent(cv) and result = "Element[" + cv.serialize() + "!]"
  )
  or
  c = TUnknownElementContent() and result = "Element[?]"
}

private string getContentSetSpecific(ContentSet cs) {
  exists(Content c | cs = TSingletonContent(c) and result = getContentSpecific(c))
  or
  cs = TAnyElementContent() and result = "Element[any]"
  or
  exists(Content::KnownElementContent kec |
    cs = TKnownOrUnknownElementContent(kec) and
    result = "Element[" + kec.getIndex().serialize() + "]"
  )
  or
  exists(int lower, boolean includeUnknown, string unknown |
    cs = TElementLowerBoundContent(lower, includeUnknown) and
    (if includeUnknown = true then unknown = "" else unknown = "!") and
    result = "Element[" + lower + ".." + unknown + "]"
  )
}

/** Gets the textual representation of a summary component in the format used for MaD models. */
string getMadRepresentationSpecific(SummaryComponent sc) {
  exists(ContentSet cs | sc = TContentSummaryComponent(cs) and result = getContentSetSpecific(cs))
  or
  exists(ContentSet cs |
    sc = TWithoutContentSummaryComponent(cs) and
    result = "WithoutElement[" + getContentSetSpecific(cs) + "]"
  )
  or
  exists(ContentSet cs |
    sc = TWithContentSummaryComponent(cs) and
    result = "WithElement[" + getContentSetSpecific(cs) + "]"
  )
  or
  exists(ReturnKind rk |
    sc = TReturnSummaryComponent(rk) and
    not rk = getReturnValueKind() and
    result = "ReturnValue[" + rk + "]"
  )
}

/** Gets the textual representation of a parameter position in the format used for flow summaries. */
string getParameterPosition(ParameterPosition pos) {
  exists(int i |
    pos.isPositional(i) and
    result = i.toString()
  )
  or
  exists(int i |
    pos.isPositionalLowerBound(i) and
    result = i + ".."
  )
  or
  exists(string name |
    pos.isKeyword(name) and
    result = name + ":"
  )
  or
  pos.isSelf() and
  result = "self"
  or
  pos.isBlock() and
  result = "block"
  or
  pos.isAny() and
  result = "any"
  or
  pos.isAnyNamed() and
  result = "any-named"
  or
  pos.isHashSplat() and
  result = "hash-splat"
}

/** Gets the textual representation of an argument position in the format used for flow summaries. */
string getArgumentPosition(ArgumentPosition pos) {
  pos.isSelf() and result = "self"
  or
  pos.isBlock() and result = "block"
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
NormalReturnKind getReturnValueKind() { any() }

/**
 * All definitions in this module are required by the shared implementation
 * (for source/sink interpretation), but they are unused for Ruby, where
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

  /** Provides additional sink specification logic. */
  predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) { none() }

  /** Provides additional source specification logic. */
  predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode node) { none() }
}

import UnusedSourceSinkInterpretation

module ParsePositions {
  private import FlowSummaryImpl

  private predicate isParamBody(string body) {
    body = any(AccessPathToken tok).getAnArgument("Parameter")
  }

  private predicate isArgBody(string body) {
    body = any(AccessPathToken tok).getAnArgument("Argument")
  }

  private predicate isElementBody(string body) {
    body = any(AccessPathToken tok).getAnArgument(["Element", "WithElement", "WithoutElement"])
  }

  predicate isParsedParameterPosition(string c, int i) {
    isParamBody(c) and
    i = AccessPath::parseInt(c)
  }

  predicate isParsedArgumentPosition(string c, int i) {
    isArgBody(c) and
    i = AccessPath::parseInt(c)
  }

  predicate isParsedArgumentLowerBoundPosition(string c, int i) {
    isArgBody(c) and
    i = AccessPath::parseLowerBound(c)
  }

  predicate isParsedKeywordParameterPosition(string c, string paramName) {
    isParamBody(c) and
    c = paramName + ":"
  }

  predicate isParsedKeywordArgumentPosition(string c, string paramName) {
    isArgBody(c) and
    c = paramName + ":"
  }

  bindingset[arg]
  string adjustElementArgument(string arg, boolean includeUnknown) {
    result = arg.regexpCapture("(.*)!", 1) and
    includeUnknown = false
    or
    result = arg and
    not arg.matches("%!") and
    includeUnknown = true
  }

  predicate isParsedElementLowerBoundPosition(string c, boolean includeUnknown, int lower) {
    isElementBody(c) and
    lower = AccessPath::parseLowerBound(adjustElementArgument(c, includeUnknown))
  }
}

/** Gets the argument position obtained by parsing `X` in `Parameter[X]`. */
ArgumentPosition parseParamBody(string s) {
  exists(int i |
    ParsePositions::isParsedParameterPosition(s, i) and
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
  or
  s = "block" and
  result.isBlock()
  or
  s = "any" and
  result.isAny()
  or
  s = "any-named" and
  result.isAnyNamed()
}

/** Gets the parameter position obtained by parsing `X` in `Argument[X]`. */
ParameterPosition parseArgBody(string s) {
  exists(int i |
    ParsePositions::isParsedArgumentPosition(s, i) and
    result.isPositional(i)
  )
  or
  exists(int i |
    ParsePositions::isParsedArgumentLowerBoundPosition(s, i) and
    result.isPositionalLowerBound(i)
  )
  or
  exists(string name |
    ParsePositions::isParsedKeywordArgumentPosition(s, name) and
    result.isKeyword(name)
  )
  or
  s = "self" and
  result.isSelf()
  or
  s = "block" and
  result.isBlock()
  or
  s = "any" and
  result.isAny()
  or
  s = "any-named" and
  result.isAnyNamed()
}
