/**
 * Provides C# specific classes and predicates for defining flow summaries.
 */

private import csharp
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowPublic
private import DataFlowImplCommon
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import semmle.code.csharp.Unification
private import semmle.code.csharp.dataflow.ExternalFlow

/** Holds is `i` is a valid parameter position. */
predicate parameterPosition(int i) { i in [-1 .. any(Parameter p).getPosition()] }

/** Gets the synthesized summary data-flow node for the given values. */
Node summaryNode(SummarizedCallable c, SummaryNodeState state) { result = TSummaryNode(c, state) }

/** Gets the synthesized data-flow call for `receiver`. */
SummaryCall summaryDataFlowCall(Node receiver) { receiver = result.getReceiver() }

/** Gets the type of content `c`. */
DataFlowType getContentType(Content c) {
  exists(Type t | result = Gvn::getGlobalValueNumber(t) |
    t = c.(FieldContent).getField().getType()
    or
    t = c.(PropertyContent).getProperty().getType()
    or
    c instanceof ElementContent and
    t instanceof ObjectType // we don't know what the actual element type is
  )
}

private DataFlowType getReturnTypeBase(DataFlowCallable c, ReturnKind rk) {
  exists(Type t | result = Gvn::getGlobalValueNumber(t) |
    rk instanceof NormalReturnKind and
    (
      t = c.(Constructor).getDeclaringType()
      or
      not c instanceof Constructor and
      t = c.getReturnType()
    )
    or
    t = c.getParameter(rk.(OutRefReturnKind).getPosition()).getType()
  )
}

/** Gets the return type of kind `rk` for callable `c`. */
bindingset[c]
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) {
  result = getReturnTypeBase(c, rk)
  or
  rk =
    any(JumpReturnKind jrk | result = getReturnTypeBase(jrk.getTarget(), jrk.getTargetReturnKind()))
}

/**
 * Gets the type of the `i`th parameter in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackParameterType(DataFlowType t, int i) {
  exists(SystemLinqExpressions::DelegateExtType dt |
    t = Gvn::getGlobalValueNumber(dt) and
    result = Gvn::getGlobalValueNumber(dt.getDelegateType().getParameter(i).getType())
  )
}

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) {
  rk instanceof NormalReturnKind and
  exists(SystemLinqExpressions::DelegateExtType dt |
    t = Gvn::getGlobalValueNumber(dt) and
    result = Gvn::getGlobalValueNumber(dt.getDelegateType().getReturnType())
  )
}

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, and kind `kind`.
 */
predicate summaryElement(DataFlowCallable c, string input, string output, string kind) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind) and
    c = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/**
 * Holds if an external source specification exists for `e` with output specification
 * `output` and kind `kind`.
 */
predicate sourceElement(Element e, string output, string kind) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    sourceModel(namespace, type, subtypes, name, signature, ext, output, kind) and
    e = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/**
 * Holds if an external sink specification exists for `n` with input specification
 * `input` and kind `kind`.
 */
predicate sinkElement(Element e, string input, string kind) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    sinkModel(namespace, type, subtypes, name, signature, ext, input, kind) and
    e = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/** Gets the summary component for specification component `c`, if any. */
bindingset[c]
SummaryComponent interpretComponentSpecific(string c) {
  c = "Element" and result = SummaryComponent::content(any(ElementContent ec))
  or
  exists(Field f |
    c.regexpCapture("Field\\[(.+)\\]", 1) = f.getQualifiedName() and
    result = SummaryComponent::content(any(FieldContent fc | fc.getField() = f))
  )
  or
  exists(Property p |
    c.regexpCapture("Property\\[(.+)\\]", 1) = p.getQualifiedName() and
    result = SummaryComponent::content(any(PropertyContent pc | pc.getProperty() = p))
  )
}

class SourceOrSinkElement = Element;

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
  DataFlowCallable asCallable() { result = this.asElement() }

  /** Gets the target of this call, if any. */
  Callable getCallTarget() { result = viableCallable(this.asCall()) }

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

/** Provides additional sink specification logic required for attributes. */
predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) {
  exists(Node n | n = node.asNode() |
    (c = "Parameter" or c = "") and
    n.asParameter() = mid.asElement()
    or
    c = "" and
    n.asExpr().(AssignableRead).getTarget().getUnboundDeclaration() = mid.asElement()
  )
}

/** Provides additional sink specification logic required for attributes. */
predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode n) {
  c = "" and
  exists(Assignable a |
    n.asNode().asExpr() = a.getAnAssignedValue() and
    a.getUnboundDeclaration() = mid.asElement()
  )
}
