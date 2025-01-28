/**
 * Provides classes and predicates for defining flow summaries.
 */

private import java
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowUtil
private import DataFlowImplSpecific as DataFlowImplSpecific
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSummary as FlowSummary

/**
 * A module for importing frameworks that define synthetic globals.
 */
private module SyntheticGlobals {
  private import semmle.code.java.frameworks.android.Intent
}

bindingset[pos]
private string positionToString(int pos) {
  if pos = -1 then result = "this" else result = pos.toString()
}

module Input implements InputSig<Location, DataFlowImplSpecific::JavaDataFlow> {
  private import codeql.util.Void

  class SummarizedCallableBase = FlowSummary::SummarizedCallableBase;

  class SourceBase = Void;

  class SinkBase = Void;

  predicate neutralElement(
    Input::SummarizedCallableBase c, string kind, string provenance, boolean isExact
  ) {
    exists(string namespace, string type, string name, string signature |
      neutralModel(namespace, type, name, signature, kind, provenance) and
      c.asCallable() = interpretElement(namespace, type, true, name, signature, "", isExact)
    )
  }

  ArgumentPosition callbackSelfParameterPosition() { result = -1 }

  ReturnKind getStandardReturnValueKind() { any() }

  string encodeParameterPosition(ParameterPosition pos) { result = positionToString(pos) }

  string encodeArgumentPosition(ArgumentPosition pos) { result = positionToString(pos) }

  string encodeContent(ContentSet c, string arg) {
    exists(Field f, string package, string className, string fieldName |
      f = c.(FieldContent).getField() and
      f.hasQualifiedName(package, className, fieldName) and
      result = "Field" and
      arg = package + "." + className + "." + fieldName
    )
    or
    exists(SyntheticField f |
      f = c.(SyntheticFieldContent).getField() and result = "SyntheticField" and arg = f
    )
    or
    c instanceof ArrayContent and result = "ArrayElement" and arg = ""
    or
    c instanceof CollectionContent and result = "Element" and arg = ""
    or
    c instanceof MapKeyContent and result = "MapKey" and arg = ""
    or
    c instanceof MapValueContent and result = "MapValue" and arg = ""
  }

  string encodeWithoutContent(ContentSet c, string arg) {
    result = "WithoutElement" and
    c instanceof CollectionContent and
    arg = ""
  }

  string encodeWithContent(ContentSet c, string arg) {
    result = "WithElement" and
    c instanceof CollectionContent and
    arg = ""
  }

  bindingset[token]
  ParameterPosition decodeUnknownParameterPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Argument[x..y]` ranges and `Argument[-1]`
    token.getName() = "Argument" and
    result = AccessPath::parseInt(token.getAnArgument())
  }

  bindingset[token]
  ArgumentPosition decodeUnknownArgumentPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Parameter[x..y]` ranges and `Parameter[-1]`
    token.getName() = "Parameter" and
    result = AccessPath::parseInt(token.getAnArgument())
  }
}

private import Make<Location, DataFlowImplSpecific::JavaDataFlow, Input> as Impl

private module TypesInput implements Impl::Private::TypesInputSig {
  DataFlowType getSyntheticGlobalType(Impl::Private::SyntheticGlobal sg) {
    exists(sg) and
    result instanceof TypeObject
  }

  DataFlowType getContentType(ContentSet c) { result = c.(Content).getType() }

  DataFlowType getParameterType(Impl::Public::SummarizedCallable c, ParameterPosition pos) {
    result = getErasedRepr(c.getParameterType(pos))
  }

  DataFlowType getReturnType(Impl::Public::SummarizedCallable c, ReturnKind rk) {
    result = getErasedRepr(c.getReturnType()) and
    exists(rk)
  }

  DataFlowType getCallbackParameterType(DataFlowType t, ArgumentPosition pos) {
    result = getErasedRepr(t.(FunctionalInterface).getRunMethod().getParameterType(pos))
    or
    result = getErasedRepr(t.(FunctionalInterface)) and pos = -1
  }

  DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) {
    result = getErasedRepr(t.(FunctionalInterface).getRunMethod().getReturnType()) and
    exists(rk)
  }

  DataFlowType getSourceType(Input::SourceBase source, Impl::Private::SummaryComponent sc) {
    none()
  }

  DataFlowType getSinkType(Input::SinkBase sink, Impl::Private::SummaryComponent sc) { none() }
}

private module StepsInput implements Impl::Private::StepsInputSig {
  DataFlowCall getACall(Public::SummarizedCallable sc) {
    sc = viableCallable(result).asSummarizedCallable()
  }

  Node getSourceNode(Input::SourceBase source, Impl::Private::SummaryComponent sc) { none() }

  Node getSinkNode(Input::SinkBase sink, Impl::Private::SummaryComponent sc) { none() }
}

private predicate relatedArgSpec(Callable c, string spec) {
  exists(
    string namespace, string type, boolean subtypes, string name, string signature, string ext
  |
    summaryModel(namespace, type, subtypes, name, signature, ext, spec, _, _, _, _) or
    summaryModel(namespace, type, subtypes, name, signature, ext, _, spec, _, _, _) or
    sourceModel(namespace, type, subtypes, name, signature, ext, spec, _, _, _) or
    sinkModel(namespace, type, subtypes, name, signature, ext, spec, _, _, _)
  |
    c = interpretElement(namespace, type, subtypes, name, signature, ext, _)
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
            oldArgParsed = AccessPath::parseInt(oldArgNumber.splitAt(",").trim())
          |
            if
              ktExtensionFunctions(originalCallable, _, _) and
              ktExtensionFunctions(defaultsCallable, _, _) and
              oldArgParsed = 0
            then defaultsArgSpec = "Argument[" + paramOffset + "]" // 1 if dispatch receiver is present, 0 otherwise.
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

module SourceSinkInterpretationInput implements
  Impl::Private::External::SourceSinkInterpretationInputSig
{
  private import java as J

  class Element = J::Element;

  predicate sourceElement(
    Element e, string output, string kind, Public::Provenance provenance, string model
  ) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      SourceOrSinkElement baseSource, string originalOutput, QlBuiltins::ExtensionId madId
    |
      sourceModel(namespace, type, subtypes, name, signature, ext, originalOutput, kind, provenance,
        madId) and
      model = "MaD:" + madId.toString() and
      baseSource = interpretElement(namespace, type, subtypes, name, signature, ext, _) and
      (
        e = baseSource and output = originalOutput
        or
        correspondingKotlinParameterDefaultsArgSpec(baseSource, e, originalOutput, output)
      )
    )
  }

  predicate sinkElement(
    Element e, string input, string kind, Public::Provenance provenance, string model
  ) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      SourceOrSinkElement baseSink, string originalInput, QlBuiltins::ExtensionId madId
    |
      sinkModel(namespace, type, subtypes, name, signature, ext, originalInput, kind, provenance,
        madId) and
      model = "MaD:" + madId.toString() and
      baseSink = interpretElement(namespace, type, subtypes, name, signature, ext, _) and
      (
        e = baseSink and originalInput = input
        or
        correspondingKotlinParameterDefaultsArgSpec(baseSink, e, originalInput, input)
      )
    )
  }

  class SourceOrSinkElement = Element;

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
    Element getCallTarget() { result = this.asCall().asCall().getCallee().getSourceDeclaration() }

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
  bindingset[c]
  predicate interpretOutput(string c, InterpretNode mid, InterpretNode node) {
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
  bindingset[c]
  predicate interpretInput(string c, InterpretNode mid, InterpretNode n) {
    exists(FieldWrite fw |
      c = "" and
      fw.getField() = mid.asElement() and
      n.asNode().asExpr() = fw.getASource()
    )
  }
}

module Private {
  import Impl::Private
  import Impl::Private::Types<TypesInput>

  module Steps = Impl::Private::Steps<StepsInput>;

  module External {
    import Impl::Private::External
    import Impl::Private::External::SourceSinkInterpretation<SourceSinkInterpretationInput>

    /**
     * Holds if an external flow summary exists for `c` with input specification
     * `input`, output specification `output`, kind `kind`, and provenance `provenance`.
     */
    predicate summaryElement(
      Input::SummarizedCallableBase c, string input, string output, string kind, string provenance,
      string model, boolean isExact
    ) {
      exists(
        string namespace, string type, boolean subtypes, string name, string signature, string ext,
        string originalInput, string originalOutput, Callable baseCallable,
        QlBuiltins::ExtensionId madId
      |
        summaryModel(namespace, type, subtypes, name, signature, ext, originalInput, originalOutput,
          kind, provenance, madId) and
        model = "MaD:" + madId.toString() and
        baseCallable = interpretElement(namespace, type, subtypes, name, signature, ext, isExact) and
        (
          c.asCallable() = baseCallable and input = originalInput and output = originalOutput
          or
          correspondingKotlinParameterDefaultsArgSpec(baseCallable, c.asCallable(), originalInput,
            input) and
          correspondingKotlinParameterDefaultsArgSpec(baseCallable, c.asCallable(), originalOutput,
            output)
        )
      )
    }

    predicate neutralElement = Input::neutralElement/4;
  }

  /** Provides predicates for constructing summary components. */
  module SummaryComponent {
    import Impl::Private::SummaryComponent

    /** Gets a summary component that represents a qualifier. */
    SummaryComponent qualifier() { result = argument(-1) }

    /** Gets a summary component for field `f`. */
    SummaryComponent field(Field f) { result = content(any(FieldContent c | c.getField() = f)) }

    /** Gets a summary component for `Element`. */
    SummaryComponent element() { result = content(any(CollectionContent c)) }

    /** Gets a summary component for `ArrayElement`. */
    SummaryComponent arrayElement() { result = content(any(ArrayContent c)) }

    /** Gets a summary component for `MapValue`. */
    SummaryComponent mapValue() { result = content(any(MapValueContent c)) }

    /** Gets a summary component that represents the return value of a call. */
    SummaryComponent return() { result = return(_) }

    class SyntheticGlobal = Impl::Private::SyntheticGlobal;
  }

  module SummaryComponentStack {
    import Impl::Private::SummaryComponentStack

    /** Gets a singleton stack representing a qualifier. */
    SummaryComponentStack qualifier() { result = singleton(SummaryComponent::qualifier()) }

    /** Gets a stack representing a field `f` of `object`. */
    SummaryComponentStack fieldOf(Field f, SummaryComponentStack object) {
      result = push(SummaryComponent::field(f), object)
    }

    /** Gets a stack representing `Element` of `object`. */
    SummaryComponentStack elementOf(SummaryComponentStack object) {
      result = push(SummaryComponent::element(), object)
    }

    /** Gets a stack representing `ArrayElement` of `object`. */
    SummaryComponentStack arrayElementOf(SummaryComponentStack object) {
      result = push(SummaryComponent::arrayElement(), object)
    }

    /** Gets a stack representing `MapValue` of `object`. */
    SummaryComponentStack mapValueOf(SummaryComponentStack object) {
      result = push(SummaryComponent::mapValue(), object)
    }

    /** Gets a singleton stack representing a (normal) return. */
    SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
  }

  /** Gets the argument position obtained by parsing `X` in `Parameter[X]`. */
  bindingset[s]
  ArgumentPosition parseParamBody(string s) {
    result = AccessPath::parseInt(s)
    or
    s = "this" and result = -1
  }

  /** Gets the parameter position obtained by parsing `X` in `Argument[X]`. */
  bindingset[s]
  ParameterPosition parseArgBody(string s) {
    result = AccessPath::parseInt(s)
    or
    s = "this" and result = -1
  }
}

module Public = Impl::Public;
