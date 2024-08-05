/**
 * Provides classes and predicates for defining flow summaries.
 */

private import go
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import DataFlowImplSpecific as DataFlowImplSpecific
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
private import DataFlowImplCommon
private import semmle.go.dataflow.ExternalFlow

private module FlowSummaries {
  private import semmle.go.dataflow.FlowSummary as F
}

bindingset[pos]
private string positionToString(int pos) {
  if pos = -1 then result = "receiver" else result = pos.toString()
}

module Input implements InputSig<Location, DataFlowImplSpecific::GoDataFlow> {
  class SummarizedCallableBase = Callable;

  ArgumentPosition callbackSelfParameterPosition() { result = -1 }

  ReturnKind getStandardReturnValueKind() { result = getReturnKind(0) }

  string encodeParameterPosition(ParameterPosition pos) { result = positionToString(pos) }

  string encodeArgumentPosition(ArgumentPosition pos) { result = positionToString(pos) }

  string encodeReturn(ReturnKind rk, string arg) {
    exists(int pos |
      rk = getReturnKind(pos) and
      result = "ReturnValue"
    |
      pos = 0 and arg = ""
      or
      pos != 0 and
      arg = pos.toString()
    )
  }

  string encodeContent(ContentSet cs, string arg) {
    exists(Field f, string package, string className, string fieldName |
      f = cs.(FieldContent).getField() and
      f.hasQualifiedName(package, className, fieldName) and
      result = "Field" and
      arg = package + "." + className + "." + fieldName
    )
    or
    exists(SyntheticField f |
      f = cs.(SyntheticFieldContent).getField() and result = "SyntheticField" and arg = f
    )
    or
    cs instanceof ArrayContent and result = "ArrayElement" and arg = ""
    or
    cs instanceof CollectionContent and result = "Element" and arg = ""
    or
    cs instanceof MapKeyContent and result = "MapKey" and arg = ""
    or
    cs instanceof MapValueContent and result = "MapValue" and arg = ""
    or
    cs instanceof PointerContent and result = "Dereference" and arg = ""
  }

  bindingset[token]
  ParameterPosition decodeUnknownParameterPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Argument[x..y]` ranges
    token.getName() = "Argument" and
    result = AccessPath::parseInt(token.getAnArgument())
  }

  bindingset[token]
  ArgumentPosition decodeUnknownArgumentPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Parameter[x..y]` ranges
    token.getName() = "Parameter" and
    result = AccessPath::parseInt(token.getAnArgument())
  }

  bindingset[token]
  ReturnKind decodeUnknownReturn(AccessPath::AccessPathTokenBase token) {
    // needed to support `ReturnValue[x..y]` ranges, and `ReturnValue[0]` in addition to `ReturnValue`
    token.getName() = "ReturnValue" and
    result.getIndex() = AccessPath::parseInt(token.getAnArgument())
  }
}

private import Make<Location, DataFlowImplSpecific::GoDataFlow, Input> as Impl

private module StepsInput implements Impl::Private::StepsInputSig {
  DataFlowCall getACall(Public::SummarizedCallable sc) {
    exists(DataFlow::CallNode call |
      call.asExpr() = result and
      call.getACalleeIncludingExternals() = sc
    )
  }
}

module SourceSinkInterpretationInput implements
  Impl::Private::External::SourceSinkInterpretationInputSig
{
  class Element = SourceOrSinkElement;

  /**
   * Holds if an external source specification exists for `e` with output specification
   * `output`, kind `kind`, and provenance `provenance`.
   */
  predicate sourceElement(
    SourceOrSinkElement e, string output, string kind, Public::Provenance provenance, string model
  ) {
    exists(
      string package, string type, boolean subtypes, string name, string signature, string ext,
      QlBuiltins::ExtensionId madId
    |
      sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance, madId) and
      model = "MaD:" + madId.toString() and
      e = interpretElement(package, type, subtypes, name, signature, ext)
    )
  }

  /**
   * Holds if an external sink specification exists for `e` with input specification
   * `input`, kind `kind` and provenance `provenance`.
   */
  predicate sinkElement(
    SourceOrSinkElement e, string input, string kind, Public::Provenance provenance, string model
  ) {
    exists(
      string package, string type, boolean subtypes, string name, string signature, string ext,
      QlBuiltins::ExtensionId madId
    |
      sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance, madId) and
      model = "MaD:" + madId.toString() and
      e = interpretElement(package, type, subtypes, name, signature, ext)
    )
  }

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

    /** Gets the location of this element. */
    Location getLocation() {
      exists(string fp, int sl, int sc, int el, int ec |
        this.hasLocationInfo(fp, sl, sc, el, ec) and
        result.hasLocationInfo(fp, sl, sc, el, ec)
      )
    }

    /** Holds if this element is at the specified location. */
    predicate hasLocationInfo(string fp, int sl, int sc, int el, int ec) {
      this.asEntity().hasLocationInfo(fp, sl, sc, el, ec) or
      this.asAstNode().hasLocationInfo(fp, sl, sc, el, ec)
    }
  }

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
      result.asSummarizedCallable().asFunction() = this.asElement().asEntity()
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

    Location getLocation() {
      exists(string fp, int sl, int sc, int el, int ec |
        this.hasLocationInfo(fp, sl, sc, el, ec) and
        result.hasLocationInfo(fp, sl, sc, el, ec)
      )
    }
  }

  /** Provides additional sink specification logic. */
  bindingset[c]
  predicate interpretOutput(string c, InterpretNode mid, InterpretNode node) {
    exists(int pos |
      node.asNode() = getAnOutNodeExt(mid.asCall(), TValueReturn(getReturnKind(pos)))
    |
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

  /** Provides additional source specification logic. */
  bindingset[c]
  predicate interpretInput(string c, InterpretNode mid, InterpretNode node) {
    exists(int pos, ReturnNode ret |
      parseReturn(c, pos) and
      ret = node.asNode() and
      ret.getKind() = getReturnKind(pos) and
      mid.asCallable() = getNodeEnclosingCallable(ret)
    )
    or
    exists(DataFlow::Write fw, Field f |
      c = "" and
      f = mid.asElement().asEntity() and
      fw.writesField(_, f, node.asNode())
    )
  }
}

/**
 * Holds if specification component `c` parses as return value `n` or a range
 * containing `n`.
 */
bindingset[c]
private predicate parseReturn(AccessPath::AccessPathTokenBase c, int n) {
  (
    c = "ReturnValue" and n = 0
    or
    c.getName() = "ReturnValue" and
    n = AccessPath::parseInt(c.getAnArgument())
  )
}

module Private {
  import Impl::Private

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
      string model
    ) {
      exists(
        string namespace, string type, boolean subtypes, string name, string signature, string ext,
        QlBuiltins::ExtensionId madId
      |
        summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind,
          provenance, madId) and
        model = "MaD:" + madId.toString() and
        c.asFunction() =
          interpretElement(namespace, type, subtypes, name, signature, ext).asEntity()
      )
    }

    /**
     * Holds if a neutral model exists for `c` of kind `kind`
     * and with provenance `provenance`.
     */
    predicate neutralElement(Input::SummarizedCallableBase c, string kind, string provenance) {
      exists(string namespace, string type, string name, string signature |
        neutralModel(namespace, type, name, signature, kind, provenance) and
        c.asFunction() = interpretElement(namespace, type, false, name, signature, "").asEntity()
      )
    }
  }

  /**
   * Provides predicates for constructing summary components.
   */
  module SummaryComponent {
    private import Impl::Private::SummaryComponent as SC

    predicate parameter = SC::parameter/1;

    predicate argument = SC::argument/1;

    predicate content = SC::content/1;

    predicate withoutContent = SC::withoutContent/1;

    predicate withContent = SC::withContent/1;

    /** Gets a summary component that represents a qualifier. */
    SummaryComponent qualifier() { result = argument(-1) }

    /** Gets a summary component for field `f`. */
    SummaryComponent field(Field f) { result = content(any(FieldContent c | c.getField() = f)) }

    /** Gets a summary component that represents the return value of a call. */
    SummaryComponent return() { result = SC::return(_) }
  }

  /**
   * Provides predicates for constructing stacks of summary components.
   */
  module SummaryComponentStack {
    private import Impl::Private::SummaryComponentStack as SCS

    predicate singleton = SCS::singleton/1;

    predicate push = SCS::push/2;

    predicate argument = SCS::argument/1;

    /** Gets a singleton stack representing a qualifier. */
    SummaryComponentStack qualifier() { result = singleton(SummaryComponent::qualifier()) }

    /** Gets a stack representing a field `f` of `object`. */
    SummaryComponentStack fieldOf(Field f, SummaryComponentStack object) {
      result = push(SummaryComponent::field(f), object)
    }

    /** Gets a singleton stack representing a (normal) return. */
    SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
  }
}

module Public = Impl::Public;
