/**
 * Provides Java specific classes and predicates for defining flow summaries.
 */

private import java
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowUtil
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSummary as FlowSummary
private import semmle.code.java.dataflow.internal.AccessPathSyntax as AccessPathSyntax

class SummarizedCallableBase = FlowSummary::SummarizedCallableBase;

DataFlowCallable inject(SummarizedCallable c) { result.asSummarizedCallable() = c }

/** Gets the parameter position of the instance parameter. */
int instanceParameterPosition() { result = -1 }

/** Gets the synthesized summary data-flow node for the given values. */
Node summaryNode(SummarizedCallable c, SummaryNodeState state) { result = getSummaryNode(c, state) }

/** Gets the synthesized data-flow call for `receiver`. */
SummaryCall summaryDataFlowCall(Node receiver) { result.getReceiver() = receiver }

/** Gets the type of content `c`. */
DataFlowType getContentType(Content c) { result = c.getType() }

/** Gets the return type of kind `rk` for callable `c`. */
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) {
  result = getErasedRepr(c.getReturnType()) and
  exists(rk)
}

/**
 * Gets the type of the `i`th parameter in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackParameterType(DataFlowType t, int i) {
  result = getErasedRepr(t.(FunctionalInterface).getRunMethod().getParameterType(i))
  or
  result = getErasedRepr(t.(FunctionalInterface)) and i = -1
}

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) {
  result = getErasedRepr(t.(FunctionalInterface).getRunMethod().getReturnType()) and
  exists(rk)
}

/** Gets the type of synthetic global `sg`. */
DataFlowType getSyntheticGlobalType(SummaryComponent::SyntheticGlobal sg) {
  exists(sg) and
  result instanceof TypeObject
}

bindingset[provenance]
private boolean isGenerated(string provenance) {
  provenance = "generated" and result = true
  or
  provenance != "generated" and result = false
}

private predicate relatedArgSpec(Callable c, string spec) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, spec, _, _, _) or
    summaryModel(namespace, type, subtypes, name, signature, ext, _, spec, _, _) or
    sourceModel(namespace, type, subtypes, name, signature, ext, spec, _, _) or
    sinkModel(namespace, type, subtypes, name, signature, ext, spec, _, _)
  |
    c = interpretElement(namespace, type, subtypes, name, signature, ext)
  )
}

/**
 * Holds if `defaultsCallable` is a Kotlin default-parameter proxy for `originalCallable`, and
 * `originalCallable` has a model, and `defaultsArgSpec` is `originalArgSpec` adjusted to account
 * for the additional dispatch receiver parameter that occurs in the default-parameter proxy's argument
 * list. When no adjustment is required (e.g. for constructors, or non-argument-based specs), `defaultArgsSpec`
 * equals `originalArgSpec`.
 *
 * Note in the case where `originalArgSpec` uses an integer range, like `Argument[1..3]...`, this will produce multiple
 * results for `defaultsArgSpec`, like `{Argument[2]..., Argument[3]..., Argument[4]...}`.
 */
private predicate correspondingKotlinParameterDefaultsArgSpec(
  Callable originalCallable, Callable defaultsCallable, string originalArgSpec,
  string defaultsArgSpec
) {
  relatedArgSpec(originalCallable, originalArgSpec) and
  defaultsCallable = originalCallable.getKotlinParameterDefaultsProxy() and
  (
    originalCallable instanceof Constructor and originalArgSpec = defaultsArgSpec
    or
    originalCallable instanceof Method and
    exists(string regex |
      // Note I use a regex and not AccessPathToken because this feeds summaryElement et al,
      // which would introduce mutual recursion with the definition of AccessPathToken.
      regex = "Argument\\[([0-9,\\. ]+)\\](.*)" and
      (
        exists(string oldArgNumber, string rest, int paramOffset |
          oldArgNumber = originalArgSpec.regexpCapture(regex, 1) and
          rest = originalArgSpec.regexpCapture(regex, 2) and
          paramOffset =
            defaultsCallable.getNumberOfParameters() -
              (originalCallable.getNumberOfParameters() + 2) and
          exists(int oldArgParsed |
            oldArgParsed = AccessPathSyntax::AccessPath::parseInt(oldArgNumber.splitAt(",").trim())
          |
            if ktExtensionFunctions(originalCallable, _, _) and oldArgParsed = 0
            then defaultsArgSpec = "Argument[0]"
            else defaultsArgSpec = "Argument[" + (oldArgParsed + paramOffset) + "]" + rest
          )
        )
        or
        not originalArgSpec.regexpMatch(regex) and
        defaultsArgSpec = originalArgSpec
      )
    )
  )
}

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, kind `kind`, and a flag `generated`
 * stating whether the summary is autogenerated.
 */
predicate summaryElement(
  SummarizedCallableBase c, string input, string output, string kind, boolean generated
) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string provenance, string originalInput, string originalOutput, Callable baseCallable
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, originalInput, originalOutput,
      kind, provenance) and
    generated = isGenerated(provenance) and
    baseCallable = interpretElement(namespace, type, subtypes, name, signature, ext) and
    (
      c.asCallable() = baseCallable and input = originalInput and output = originalOutput
      or
      correspondingKotlinParameterDefaultsArgSpec(baseCallable, c.asCallable(), originalInput, input) and
      correspondingKotlinParameterDefaultsArgSpec(baseCallable, c.asCallable(), originalOutput,
        output)
    )
  )
}

/**
 * Holds if a negative flow summary exists for `c`, which means that there is no
 * flow through `c`. The flag `generated` states whether the summary is autogenerated.
 */
predicate negativeSummaryElement(SummarizedCallableBase c, boolean generated) {
  exists(string namespace, string type, string name, string signature, string provenance |
    negativeSummaryModel(namespace, type, name, signature, provenance) and
    generated = isGenerated(provenance) and
    c.asCallable() = interpretElement(namespace, type, false, name, signature, "")
  )
}

/** Gets the summary component for specification component `c`, if any. */
bindingset[c]
SummaryComponent interpretComponentSpecific(AccessPathToken c) {
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
}

/** Gets the textual representation of a parameter position in the format used for flow summaries. */
string getParameterPositionCsv(ParameterPosition pos) { result = pos.toString() }

/** Gets the textual representation of an argument position in the format used for flow summaries. */
string getArgumentPositionCsv(ArgumentPosition pos) { result = pos.toString() }

/** Holds if input specification component `c` needs a reference. */
predicate inputNeedsReferenceSpecific(string c) { none() }

/** Holds if output specification component `c` needs a reference. */
predicate outputNeedsReferenceSpecific(string c) { none() }

class SourceOrSinkElement = Top;

/**
 * Holds if an external source specification exists for `e` with output specification
 * `output`, kind `kind`, and a flag `generated` stating whether the source specification is
 * autogenerated.
 */
predicate sourceElement(SourceOrSinkElement e, string output, string kind, boolean generated) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string provenance, SourceOrSinkElement baseSource, string originalOutput
  |
    sourceModel(namespace, type, subtypes, name, signature, ext, originalOutput, kind, provenance) and
    generated = isGenerated(provenance) and
    baseSource = interpretElement(namespace, type, subtypes, name, signature, ext) and
    (
      e = baseSource and output = originalOutput
      or
      correspondingKotlinParameterDefaultsArgSpec(baseSource, e, originalOutput, output)
    )
  )
}

/**
 * Holds if an external sink specification exists for `e` with input specification
 * `input`, kind `kind` and a flag `generated` stating whether the sink specification is
 * autogenerated.
 */
predicate sinkElement(SourceOrSinkElement e, string input, string kind, boolean generated) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string provenance, SourceOrSinkElement baseSink, string originalInput
  |
    sinkModel(namespace, type, subtypes, name, signature, ext, originalInput, kind, provenance) and
    generated = isGenerated(provenance) and
    baseSink = interpretElement(namespace, type, subtypes, name, signature, ext) and
    (
      e = baseSink and originalInput = input
      or
      correspondingKotlinParameterDefaultsArgSpec(baseSink, e, originalInput, input)
    )
  )
}

/** Gets the return kind corresponding to specification `"ReturnValue"`. */
ReturnKind getReturnValueKind() { any() }

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
  DataFlowCall asCall() { result.asCall() = this.asElement() }

  /** Gets the callable that this node corresponds to, if any. */
  DataFlowCallable asCallable() { result.asCallable() = this.asElement() }

  /** Gets the target of this call, if any. */
  Callable getCallTarget() { result = this.asCall().asCall().getCallee().getSourceDeclaration() }

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
predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) {
  exists(Node n, Top ast |
    n = node.asNode() and
    ast = mid.asElement()
  |
    (c = "Parameter" or c = "") and
    node.asNode().asParameter() = mid.asElement()
    or
    c = "" and
    n.asExpr().(FieldRead).getField() = ast
  )
}

/** Provides additional source specification logic required for annotations. */
pragma[inline]
predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode n) {
  exists(FieldWrite fw |
    c = "" and
    fw.getField() = mid.asElement() and
    n.asNode().asExpr() = fw.getRhs()
  )
}

/** Gets the argument position obtained by parsing `X` in `Parameter[X]`. */
bindingset[s]
ArgumentPosition parseParamBody(string s) { result = AccessPath::parseInt(s) }

/** Gets the parameter position obtained by parsing `X` in `Argument[X]`. */
bindingset[s]
ParameterPosition parseArgBody(string s) { result = AccessPath::parseInt(s) }
