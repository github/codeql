/**
 * Provides Swift specific classes and predicates for defining flow summaries.
 */

private import swift
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowPublic
private import DataFlowImplCommon
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSummary as FlowSummary
private import codeql.swift.controlflow.CfgNodes

class SummarizedCallableBase = AbstractFunctionDecl;

DataFlowCallable inject(SummarizedCallable c) { result.getUnderlyingCallable() = c }

/** Gets the parameter position of the instance parameter. */
ArgumentPosition callbackSelfParameterPosition() { result instanceof ThisArgumentPosition }

/** Gets the synthesized summary data-flow node for the given values. */
Node summaryNode(SummarizedCallable c, SummaryNodeState state) { result = TSummaryNode(c, state) }

/** Gets the synthesized data-flow call for `receiver`. */
SummaryCall summaryDataFlowCall(Node receiver) { receiver = result.getReceiver() }

/** Gets the type of content `c`. */
DataFlowType getContentType(ContentSet c) { any() }

/** Gets the return type of kind `rk` for callable `c`. */
bindingset[c]
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) {
  any() // TODO once we have type pruning
}

/**
 * Gets the type of the parameter matching arguments at position `pos` in a
 * synthesized call that targets a callback of type `t`.
 */
DataFlowType getCallbackParameterType(DataFlowType t, ArgumentPosition pos) {
  any() // TODO once we have type pruning
}

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) {
  any() // TODO once we have type pruning
}

/** Gets the type of synthetic global `sg`. */
DataFlowType getSyntheticGlobalType(SummaryComponent::SyntheticGlobal sg) { any() }

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, kind `kind`, and provenance `provenance`.
 */
predicate summaryElement(
  AbstractFunctionDecl c, string input, string output, string kind, string provenance
) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance) and
    c = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/**
 * Holds if a neutral model exists for `c` with provenance `provenance`,
 * which means that there is no flow through `c`.
 */
predicate neutralElement(AbstractFunctionDecl c, string provenance) { none() }

/**
 * Holds if an external source specification exists for `e` with output specification
 * `output`, kind `kind`, and provenance `provenance`.
 */
predicate sourceElement(Element e, string output, string kind, string provenance) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance) and
    e = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/**
 * Holds if an external sink specification exists for `e` with input specification
 * `input`, kind `kind` and provenance `provenance`.
 */
predicate sinkElement(Element e, string input, string kind, string provenance) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    sinkModel(namespace, type, subtypes, name, signature, ext, input, kind, provenance) and
    e = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/** Gets the summary component for specification component `c`, if any. */
bindingset[c]
SummaryComponent interpretComponentSpecific(AccessPathToken c) {
  exists(ContentSet cs, Content content |
    cs.isSingleton(content) and
    parseContent(c, content) and
    result = SummaryComponent::content(cs)
  )
}

/** Gets the textual representation of the content in the format used for flow summaries. */
private string getContentSpecific(ContentSet cs) {
  exists(Content::FieldContent c |
    cs.isSingleton(c) and
    result = "Field[" + c.getField().getName() + "]"
  )
}

/** Gets the textual representation of a summary component in the format used for flow summaries. */
string getComponentSpecific(SummaryComponent sc) {
  exists(ContentSet c | sc = TContentSummaryComponent(c) and result = getContentSpecific(c))
  or
  exists(ReturnKind rk |
    sc = TReturnSummaryComponent(rk) and
    result = "ReturnValue[" + rk + "]" and
    not rk instanceof NormalReturnKind
  )
}

/** Gets the textual representation of a parameter position in the format used for flow summaries. */
string getParameterPosition(ParameterPosition pos) { result = pos.toString() }

/** Gets the textual representation of an argument position in the format used for flow summaries. */
string getArgumentPosition(ArgumentPosition pos) { result = pos.toString() }

/** Holds if input specification component `c` needs a reference. */
predicate inputNeedsReferenceSpecific(string c) { none() }

/** Holds if output specification component `c` needs a reference. */
predicate outputNeedsReferenceSpecific(string c) { none() }

class SourceOrSinkElement = AstNode;

/** Gets the return kind corresponding to specification `"ReturnValue"`. */
NormalReturnKind getReturnValueKind() { any() }

private newtype TInterpretNode =
  TElement_(Element n) or
  TNode_(Node n) or
  TDataFlowCall_(DataFlowCall c)

/** An entity used to interpret a source/sink specification. */
class InterpretNode extends TInterpretNode {
  /** Gets the element that this node corresponds to, if any. */
  SourceOrSinkElement asElement() { this = TElement_(result) }

  /** Gets the data-flow node that this node corresponds to, if any. */
  Node asNode() { this = TNode_(result) }

  /** Gets the call that this node corresponds to, if any. */
  DataFlowCall asCall() { this = TDataFlowCall_(result) }

  /** Gets the callable that this node corresponds to, if any. */
  DataFlowCallable asCallable() { result.getUnderlyingCallable() = this.asElement() }

  /** Gets the target of this call, if any. */
  AbstractFunctionDecl getCallTarget() { result = this.asCall().asCall().getStaticTarget() }

  /** Gets a textual representation of this node. */
  string toString() {
    result = this.asElement().toString()
    or
    result = this.asNode().toString()
    or
    result = this.asCall().toString()
  }

  /** Gets the location of this node. */
  Location getLocation() {
    result = this.asElement().getLocation()
    or
    result = this.asNode().getLocation()
    or
    result = this.asCall().getLocation()
  }
}

predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) {
  // Allow fields to be picked as output nodes.
  exists(Node n, AstNode ast |
    n = node.asNode() and
    ast = mid.asElement()
  |
    c = "" and
    n.asExpr().(MemberRefExpr).getMember() = ast
  )
}

predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode n) { none() }

/** Gets the argument position obtained by parsing `X` in `Parameter[X]`. */
bindingset[s]
ArgumentPosition parseParamBody(string s) {
  exists(int index | index = AccessPath::parseInt(s) |
    result.(PositionalArgumentPosition).getIndex() = index
    or
    index = -1 and
    result instanceof ThisArgumentPosition
  )
}

/** Gets the parameter position obtained by parsing `X` in `Argument[X]`. */
bindingset[s]
ParameterPosition parseArgBody(string s) {
  exists(int index | index = AccessPath::parseInt(s) |
    result.(PositionalParameterPosition).getIndex() = index
    or
    index = -1 and
    result instanceof ThisParameterPosition
  )
}
