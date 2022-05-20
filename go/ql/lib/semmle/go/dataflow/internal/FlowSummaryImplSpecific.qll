/**
 * Provides Go-specific classes and predicates for defining flow summaries.
 */

private import go
private import DataFlowPrivate
private import DataFlowUtil
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import semmle.go.dataflow.ExternalFlow
private import DataFlowImplCommon

private module FlowSummaries {
  private import semmle.go.dataflow.FlowSummary as F
}

/** Holds if `i` is a valid parameter position. */
predicate parameterPosition(int i) {
  i = [-1 .. any(DataFlowCallable c).getType().getNumParameter()]
}

/** Gets the parameter position of the instance parameter. */
int instanceParameterPosition() { result = -1 }

/** A parameter position represented by an integer. */
class ParameterPosition extends int {
  ParameterPosition() { parameterPosition(this) }
}

/** An argument position represented by an integer. */
class ArgumentPosition extends int {
  ArgumentPosition() { parameterPosition(this) }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

/**
 * Holds if `arg` is an argument of `call` with an argument position that matches
 * parameter position `ppos`.
 */
pragma[noinline]
predicate argumentPositionMatch(DataFlowCall call, ArgNode arg, ParameterPosition ppos) {
  exists(ArgumentPosition apos |
    arg.argumentOf(call, apos) and
    parameterMatch(ppos, apos)
  )
}

/** Gets the textual representation of a parameter position in the format used for flow summaries. */
string getParameterPositionCsv(ParameterPosition pos) { result = pos.toString() }

/** Gets the textual representation of an argument position in the format used for flow summaries. */
string getArgumentPositionCsv(ArgumentPosition pos) { result = pos.toString() }

Node summaryNode(SummarizedCallable c, SummaryNodeState state) { result = getSummaryNode(c, state) }

/** Gets the synthesized data-flow call for `receiver`. */
DataFlowCall summaryDataFlowCall(Node receiver) {
  // We do not currently have support for callback-based library models.
  none()
}

/** Gets the type of content `c`. */
DataFlowType getContentType(Content c) { result = c.getType() }

/** Gets the return type of kind `rk` for callable `c`. */
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) {
  result = c.getType().getResultType(rk.getIndex())
}

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
predicate summaryElement(DataFlowCallable c, string input, string output, string kind) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind) and
    c.asFunction() = interpretElement(namespace, type, subtypes, name, signature, ext).asEntity()
  )
}

/** Gets the summary component for specification component `c`, if any. */
bindingset[c]
SummaryComponent interpretComponentSpecific(string c) {
  exists(int pos | parseReturn(c, pos) and result = SummaryComponent::return(getReturnKind(pos)))
  or
  exists(Content content | parseContent(c, content) and result = SummaryComponent::content(content))
}

/** Gets the summary component for specification component `c`, if any. */
private string getContentSpecificCsv(Content c) {
  exists(Field f, string package, string className, string fieldName |
    f = c.(FieldContent).getField() and
    f.hasQualifiedName(package, className, fieldName) and
    result = "Field[" + package + "." + className + "." + fieldName + "]"
  )
  or
  exists(SyntheticField f |
    f = c.(SyntheticFieldContent).getField() and result = "SyntheticField[" + f + "]"
  )
  or
  c instanceof ArrayContent and result = "ArrayElement"
  or
  c instanceof CollectionContent and result = "Element"
  or
  c instanceof MapKeyContent and result = "MapKey"
  or
  c instanceof MapValueContent and result = "MapValue"
}

/** Gets the textual representation of the content in the format used for flow summaries. */
string getComponentSpecificCsv(SummaryComponent sc) {
  exists(Content c | sc = TContentSummaryComponent(c) and result = getContentSpecificCsv(c))
  or
  exists(ReturnKind rk, int n | n = rk.getIndex() |
    sc = TReturnSummaryComponent(rk) and
    result = "ReturnValue[" + n + "]" and
    n != 0
  )
}

/** Holds if input specification component `c` needs a reference. */
predicate inputNeedsReferenceSpecific(string c) { none() }

/** Holds if output specification component `c` needs a reference. */
predicate outputNeedsReferenceSpecific(string c) { parseReturn(c, _) }

private newtype TSourceOrSinkElement =
  TEntityElement(Entity e) or
  TAstElement(AstNode n)

/** An element representable by CSV modeling. */
class SourceOrSinkElement extends TSourceOrSinkElement {
  /** Gets this source or sink element as an entity, if it is one. */
  Entity asEntity() { this = TEntityElement(result) }

  /** Gets this source or sink element as an AST node, if it is one. */
  AstNode asAstNode() { this = TAstElement(result) }

  /** Gets a textual representation of this source or sink element. */
  string toString() {
    result = "element representing " + [this.asEntity().toString(), this.asAstNode().toString()]
  }

  predicate hasLocationInfo(string fp, int sl, int sc, int el, int ec) {
    this.asEntity().hasLocationInfo(fp, sl, sc, el, ec) or
    this.asAstNode().hasLocationInfo(fp, sl, sc, el, ec)
  }
}

/**
 * Holds if an external source specification exists for `e` with output specification
 * `output` and kind `kind`.
 */
predicate sourceElement(SourceOrSinkElement e, string output, string kind) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    sourceModel(namespace, type, subtypes, name, signature, ext, output, kind) and
    e = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/**
 * Holds if an external sink specification exists for `e` with input specification
 * `input` and kind `kind`.
 */
predicate sinkElement(SourceOrSinkElement e, string input, string kind) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    sinkModel(namespace, type, subtypes, name, signature, ext, input, kind) and
    e = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/** Gets the return kind corresponding to specification `"ReturnValue"`. */
ReturnKind getReturnValueKind() { result = getReturnKind(0) }

private newtype TInterpretNode =
  TElement(SourceOrSinkElement n) or
  TNode(Node n)

/** An entity used to interpret a source/sink specification. */
class InterpretNode extends TInterpretNode {
  /** Gets the element that this node corresponds to, if any. */
  SourceOrSinkElement asElement() { this = TElement(result) }

  /** Gets the data-flow node that this node corresponds to, if any. */
  Node asNode() { this = TNode(result) }

  /** Gets the call that this node corresponds to, if any. */
  DataFlowCall asCall() { result = this.asElement().asAstNode() }

  /** Gets the callable that this node corresponds to, if any. */
  DataFlowCallable asCallable() {
    result.asFunction() = this.asElement().asEntity()
    or
    result.asFuncLit() = this.asElement().asAstNode()
  }

  /** Gets the target of this call, if any. */
  SourceOrSinkElement getCallTarget() {
    result.asEntity() = this.asCall().getNode().(DataFlow::CallNode).getTarget()
  }

  /** Gets a textual representation of this node. */
  string toString() {
    result = this.asElement().toString()
    or
    result = this.asNode().toString()
  }

  /** Gets the location of this node. */
  predicate hasLocationInfo(string fp, int sl, int sc, int el, int ec) {
    this.asElement().hasLocationInfo(fp, sl, sc, el, ec)
    or
    this.asNode().hasLocationInfo(fp, sl, sc, el, ec)
  }
}

/** Provides additional sink specification logic required for annotations. */
pragma[inline]
predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) {
  exists(int pos | node.asNode() = getAnOutNodeExt(mid.asCall(), TValueReturn(getReturnKind(pos))) |
    parseReturn(c, pos)
  )
  or
  exists(Node n, SourceOrSinkElement e |
    n = node.asNode() and
    e = mid.asElement()
  |
    (c = "Parameter" or c = "") and
    node.asNode().asParameter() = e.asEntity()
    or
    c = "" and
    n.(DataFlow::FieldReadNode).getField() = e.asEntity()
  )
}

/** Provides additional source specification logic required for annotations. */
pragma[inline]
predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode n) {
  exists(int pos, ReturnNodeExt ret |
    parseReturn(c, pos) and
    ret = n.asNode() and
    ret.getKind().(ValueReturnKind).getKind() = getReturnKind(pos) and
    mid.asCallable() = getNodeEnclosingCallable(ret)
  )
  or
  exists(DataFlow::Write fw, Field f |
    c = "" and
    f = mid.asElement().asEntity() and
    fw.writesField(_, f, n.asNode())
  )
}

/** Holds if specification component `c` parses as return value `n`. */
predicate parseReturn(AccessPathToken c, int n) {
  (
    c = "ReturnValue" and n = 0
    or
    c.getName() = "ReturnValue" and
    n = parseConstantOrRange(c.getAnArgument())
  )
}

bindingset[arg]
private int parseConstantOrRange(string arg) {
  result = arg.toInt()
  or
  exists(int n1, int n2 |
    arg.regexpCapture("([-0-9]+)\\.\\.([0-9]+)", 1).toInt() = n1 and
    arg.regexpCapture("([-0-9]+)\\.\\.([0-9]+)", 2).toInt() = n2 and
    result = [n1 .. n2]
  )
}

bindingset[arg]
ArgumentPosition parseParamBody(string arg) { result = parseConstantOrRange(arg) }

bindingset[arg]
ParameterPosition parseArgBody(string arg) { result = parseConstantOrRange(arg) }
