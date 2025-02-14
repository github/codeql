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
  private import codeql.util.Void

  class SummarizedCallableBase = Callable;

  class SourceBase = Void;

  class SinkBase = Void;

  predicate neutralElement(
    Input::SummarizedCallableBase c, string kind, string provenance, boolean isExact
  ) {
    exists(string namespace, string type, string name, string signature |
      neutralModel(namespace, type, name, signature, kind, provenance) and
      c.asFunction() = interpretElement(namespace, type, false, name, signature, "").asEntity()
    ) and
    // isExact is not needed for Go.
    isExact = false
  }

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
    exists(Content c | cs.asOneContent() = c |
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
      or
      c instanceof PointerContent and result = "Dereference" and arg = ""
    )
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

  Node getSourceNode(Input::SourceBase source, Impl::Private::SummaryComponent sc) { none() }

  Node getSinkNode(Input::SinkBase sink, Impl::Private::SummaryComponent sc) { none() }
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

  // Note that due to embedding, which is currently implemented via some
  // Methods having multiple qualified names, a given Method is liable to have
  // more than one SourceOrSinkElement, one for each of the names it claims.
  private newtype TSourceOrSinkElement =
    TMethodEntityElement(Method m, string pkg, string type, boolean subtypes) {
      m.hasQualifiedName(pkg, type, _) and
      subtypes = [true, false]
    } or
    TFieldEntityElement(Field f, string pkg, string type, boolean subtypes) {
      f.hasQualifiedName(pkg, type, _) and
      subtypes = [true, false]
    } or
    TOtherEntityElement(Entity e) {
      not e instanceof Method and
      not e instanceof Field
    } or
    TAstElement(AstNode n)

  /** An element representable by CSV modeling. */
  class SourceOrSinkElement extends TSourceOrSinkElement {
    /** Gets this source or sink element as an entity, if it is one. */
    Entity asEntity() {
      result = [this.asMethodEntity(), this.asFieldEntity(), this.asOtherEntity()]
    }

    /** Gets this source or sink element as a method, if it is one. */
    Method asMethodEntity() { this = TMethodEntityElement(result, _, _, _) }

    /** Gets this source or sink element as a field, if it is one. */
    Field asFieldEntity() { this = TFieldEntityElement(result, _, _, _) }

    /** Gets this source or sink element as an entity which isn't a field or method, if it is one. */
    Entity asOtherEntity() { this = TOtherEntityElement(result) }

    /** Gets this source or sink element as an AST node, if it is one. */
    AstNode asAstNode() { this = TAstElement(result) }

    /**
     * Holds if this source or sink element is a method or field that was specified
     * with the given values for `e`, `pkg`, `type` and `subtypes`.
     */
    predicate hasFullInfo(Entity e, string pkg, string type, boolean subtypes) {
      this = TMethodEntityElement(e, pkg, type, subtypes) or
      this = TFieldEntityElement(e, pkg, type, subtypes)
    }

    /** Gets a textual representation of this source or sink element. */
    string toString() {
      (this instanceof TOtherEntityElement or this instanceof TAstElement) and
      result = "element representing " + [this.asEntity().toString(), this.asAstNode().toString()]
      or
      exists(Entity e, string pkg, string name, boolean subtypes |
        this.hasFullInfo(e, pkg, name, subtypes) and
        result =
          "element representing " + e.toString() + " with receiver type " + pkg + "." + name +
            " and subtypes=" + subtypes
      )
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
      this.asElement().asEntity() = result.asSummarizedCallable().asFunction() or
      this.asElement().asEntity() = result.asCallable().asFunction() or
      this.asElement().asAstNode() = result.asCallable().asFuncLit()
    }

    /** Gets the target of this call, if any. */
    SourceOrSinkElement getCallTarget() {
      exists(DataFlow::CallNode cn, Function callTarget |
        cn = this.asCall().getNode() and
        callTarget = cn.getTarget()
      |
        (
          result.asOtherEntity() = callTarget
          or
          callTarget instanceof Method and
          result = getElementWithQualifier(callTarget, cn.getReceiver())
        )
      )
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

  /**
   * Gets a method or field spec for `e` which applies in the context of
   * qualifier `qual`.
   *
   * Note that naively checking `e`'s qualified name is not correct, because
   * `Method`s and `Field`s may have multiple qualified names due to embedding.
   * We must instead check that the package and type name given by
   * `result.hasFullInfo` refer to either `qual`'s type or to a type it embeds.
   */
  bindingset[e, qual]
  pragma[inline_late]
  private SourceOrSinkElement getElementWithQualifier(Entity e, DataFlow::Node qual) {
    exists(boolean subtypes, Type syntacticQualBaseType, Type targetType |
      syntacticQualBaseType = getSyntacticQualifierBaseType(qual) and
      result = constructElement(e, targetType, subtypes)
    |
      subtypes = [true, false] and
      syntacticQualBaseType = targetType
      or
      subtypes = true and
      (
        // `syntacticQualBaseType`'s underlying type might be an interface type and `sse`
        // might refer to a method defined on an interface embedded within it.
        targetType =
          syntacticQualBaseType.getUnderlyingType().(InterfaceType).getAnEmbeddedInterface()
        or
        // `syntacticQualBaseType`'s underlying type might be a struct type and `sse`
        // might be a promoted method or field in it.
        targetType = getAnIntermediateEmbeddedType(e, syntacticQualBaseType.getUnderlyingType())
      )
    )
  }

  bindingset[e, targetType, subtypes]
  pragma[inline_late]
  private SourceOrSinkElement constructElement(Entity e, Type targetType, boolean subtypes) {
    exists(string pkg, string typename |
      targetType.hasQualifiedName(pkg, typename) and
      result.hasFullInfo(e, pkg, typename, subtypes)
    )
  }

  /**
   * Gets the type of an embedded field of `st` which is on the path to `e`,
   * which is a promoted method or field of `st`, or its base type if it's a
   * pointer type.
   */
  private Type getAnIntermediateEmbeddedType(Entity e, StructType st) {
    exists(Field field1, Field field2, int depth1, int depth2, Type t2 |
      field1 = st.getFieldAtDepth(_, depth1) and
      field2 = st.getFieldAtDepth(_, depth2) and
      result = lookThroughPointerType(field1.getType()) and
      t2 = lookThroughPointerType(field2.getType()) and
      (
        field1 = field2
        or
        field2 = result.getUnderlyingType().(StructType).getFieldAtDepth(_, depth2 - depth1 - 1)
      )
    |
      e.(Method).getReceiverBaseType() = t2
      or
      e.(Field).getDeclaringType() = t2.getUnderlyingType()
    )
  }

  /**
   * Gets the base type of `underlying`, where `n` is of the form
   * `implicitDeref?(underlying.implicitFieldRead1.implicitFieldRead2...)`
   *
   * For Go syntax like `qualifier.method()` or `qualifier.field`, this is the type of `qualifier`, before any
   * implicit dereference is interposed because `qualifier` is of pointer type, or implicit field accesses
   * navigate to any embedded struct types that truly host `field`.
   */
  private Type getSyntacticQualifierBaseType(DataFlow::Node n) {
    exists(DataFlow::Node n2 |
      // look through implicit dereference, if there is one
      not exists(n.asInstruction().(IR::EvalImplicitDerefInstruction).getOperand()) and
      n2 = n
      or
      n2.asExpr() = n.asInstruction().(IR::EvalImplicitDerefInstruction).getOperand()
    |
      result = lookThroughPointerType(skipImplicitFieldReads(n2).getType())
    )
  }

  private DataFlow::Node skipImplicitFieldReads(DataFlow::Node n) {
    not exists(lookThroughImplicitFieldRead(n)) and result = n
    or
    result = skipImplicitFieldReads(lookThroughImplicitFieldRead(n))
  }

  private DataFlow::Node lookThroughImplicitFieldRead(DataFlow::Node n) {
    result.asInstruction() =
      n.(DataFlow::InstructionNode)
          .asInstruction()
          .(IR::ImplicitFieldReadInstruction)
          .getBaseInstruction()
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
      n.asParameter() = pragma[only_bind_into](e).asEntity()
      or
      exists(DataFlow::FieldReadNode frn | frn = n |
        c = "" and
        pragma[only_bind_into](e) = getElementWithQualifier(frn.getField(), frn.getBase())
      )
      or
      // A package-scope (or universe-scope) variable
      exists(Variable v | not v instanceof Field |
        c = "" and
        n.(DataFlow::ReadNode).reads(v) and
        pragma[only_bind_into](e).asEntity() = v
      )
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
    exists(SourceOrSinkElement e, DataFlow::Write fw, DataFlow::Node base, Field f |
      e = mid.asElement() and
      f = e.asFieldEntity()
    |
      c = "" and
      fw.writesField(base, f, node.asNode()) and
      pragma[only_bind_into](e) = getElementWithQualifier(f, base)
    )
    or
    // A package-scope (or universe-scope) variable
    exists(Node n, SourceOrSinkElement e, DataFlow::Write w, Variable v |
      n = node.asNode() and
      e = mid.asElement() and
      not v instanceof Field
    |
      c = "" and
      w.writes(v, n) and
      pragma[only_bind_into](e).asEntity() = v
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
      Input::neutralElement(c, kind, provenance, _)
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
    SummaryComponent field(Field f) {
      result = content(any(FieldContent c | c.getField() = f).asContentSet())
    }

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
