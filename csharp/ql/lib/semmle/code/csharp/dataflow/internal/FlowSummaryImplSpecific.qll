/**
 * Provides C# specific classes and predicates for defining flow summaries.
 */

private import csharp
private import dotnet
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowPublic
private import DataFlowImplCommon
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import semmle.code.csharp.Unification
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.FlowSummary as FlowSummary

class SummarizedCallableBase extends Callable {
  SummarizedCallableBase() { this.isUnboundDeclaration() }
}

DataFlowCallable inject(SummarizedCallable c) { result.asSummarizedCallable() = c }

/** Gets the parameter position of the instance parameter. */
ArgumentPosition callbackSelfParameterPosition() { none() } // disables implicit summary flow to `this` for callbacks

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
    t = c.(SyntheticFieldContent).getField().getType()
    or
    c instanceof ElementContent and
    t instanceof ObjectType // we don't know what the actual element type is
  )
}

private DataFlowType getReturnTypeBase(DotNet::Callable c, ReturnKind rk) {
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
 * Gets the type of the parameter matching arguments at position `pos` in a
 * synthesized call that targets a callback of type `t`.
 */
DataFlowType getCallbackParameterType(DataFlowType t, ArgumentPosition pos) {
  exists(SystemLinqExpressions::DelegateExtType dt |
    t = Gvn::getGlobalValueNumber(dt) and
    result =
      Gvn::getGlobalValueNumber(dt.getDelegateType().getParameter(pos.getPosition()).getType())
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

/** Gets the type of synthetic global `sg`. */
DataFlowType getSyntheticGlobalType(SummaryComponent::SyntheticGlobal sg) {
  exists(sg) and
  result = Gvn::getGlobalValueNumber(any(ObjectType t))
}

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, kind `kind`, and provenance `provenance`.
 */
predicate summaryElement(Callable c, string input, string output, string kind, string provenance) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance) and
    c = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/**
 * Holds if a neutral model exists for `c` with provenance `provenace`,
 * which means that there is no flow through `c`.
 */
predicate neutralElement(Callable c, string provenance) {
  exists(string namespace, string type, string name, string signature |
    neutralModel(namespace, type, name, signature, provenance) and
    c = interpretElement(namespace, type, false, name, signature, "")
  )
}

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
  c = "Element" and result = SummaryComponent::content(any(ElementContent ec))
  or
  c = "WithoutElement" and result = SummaryComponent::withoutContent(any(ElementContent ec))
  or
  c = "WithElement" and result = SummaryComponent::withContent(any(ElementContent ec))
  or
  // Qualified names may contain commas,such as in `Tuple<,>`, so get the entire argument list
  // rather than an individual argument.
  exists(Field f |
    c.getName() = "Field" and
    c.getArgumentList() = f.getQualifiedName() and
    result = SummaryComponent::content(any(FieldContent fc | fc.getField() = f))
  )
  or
  exists(Property p |
    c.getName() = "Property" and
    c.getArgumentList() = p.getQualifiedName() and
    result = SummaryComponent::content(any(PropertyContent pc | pc.getProperty() = p))
  )
  or
  exists(SyntheticField f |
    c.getName() = "SyntheticField" and
    c.getArgumentList() = f and
    result = SummaryComponent::content(any(SyntheticFieldContent sfc | sfc.getField() = f))
  )
}

/** Gets the textual representation of the content in the format used for flow summaries. */
private string getContentSpecific(Content c) {
  c = TElementContent() and result = "Element"
  or
  exists(Field f | c = TFieldContent(f) and result = "Field[" + f.getQualifiedName() + "]")
  or
  exists(Property p | c = TPropertyContent(p) and result = "Property[" + p.getQualifiedName() + "]")
  or
  exists(SyntheticField f | c = TSyntheticFieldContent(f) and result = "SyntheticField[" + f + "]")
}

/** Gets the textual representation of a summary component in the format used for flow summaries. */
string getComponentSpecific(SummaryComponent sc) {
  exists(Content c | sc = TContentSummaryComponent(c) and result = getContentSpecific(c))
  or
  sc = TWithoutContentSummaryComponent(_) and result = "WithoutElement"
  or
  sc = TWithContentSummaryComponent(_) and result = "WithElement"
  or
  exists(ReturnKind rk |
    sc = TReturnSummaryComponent(rk) and
    result = "ReturnValue[" + rk + "]" and
    not rk instanceof NormalReturnKind
  )
}

/** Gets the textual representation of a parameter position in the format used for flow summaries. */
string getParameterPosition(ParameterPosition pos) {
  result = pos.getPosition().toString()
  or
  pos.isThisParameter() and
  result = "this"
}

/** Gets the textual representation of an argument position in the format used for flow summaries. */
string getArgumentPosition(ArgumentPosition pos) {
  result = pos.getPosition().toString()
  or
  pos.isQualifier() and
  result = "this"
}

/** Holds if input specification component `c` needs a reference. */
predicate inputNeedsReferenceSpecific(string c) { none() }

/** Holds if output specification component `c` needs a reference. */
predicate outputNeedsReferenceSpecific(string c) { none() }

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
  DataFlowCallable asCallable() { result.getUnderlyingCallable() = this.asElement() }

  /** Gets the target of this call, if any. */
  Callable getCallTarget() { result = this.asCall().(NonDelegateDataFlowCall).getATarget(_) }

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

/** Gets the argument position obtained by parsing `X` in `Parameter[X]`. */
bindingset[s]
ArgumentPosition parseParamBody(string s) {
  result.getPosition() = AccessPath::parseInt(s)
  or
  s = "this" and
  result.isQualifier()
}

/** Gets the parameter position obtained by parsing `X` in `Argument[X]`. */
bindingset[s]
ParameterPosition parseArgBody(string s) {
  result.getPosition() = AccessPath::parseInt(s)
  or
  s = "this" and
  result.isThisParameter()
}
