/**
 * Provides classes and predicates for defining flow summaries.
 */

private import csharp
private import semmle.code.csharp.commons.QualifiedName
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import DataFlowImplSpecific as DataFlowImplSpecific
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
private import semmle.code.csharp.Unification
private import semmle.code.csharp.dataflow.internal.ExternalFlow

module Input implements InputSig<Location, DataFlowImplSpecific::CsharpDataFlow> {
  private import codeql.util.Void

  class SummarizedCallableBase = UnboundCallable;

  class SourceBase = Void;

  class SinkBase = Void;

  predicate neutralElement(SummarizedCallableBase c, string kind, string provenance, boolean isExact) {
    interpretNeutral(c, kind, provenance) and
    // isExact is not needed for C#.
    isExact = false
  }

  ArgumentPosition callbackSelfParameterPosition() { result.isDelegateSelf() }

  ReturnKind getStandardReturnValueKind() { result instanceof NormalReturnKind }

  string encodeParameterPosition(ParameterPosition pos) {
    result = pos.getPosition().toString()
    or
    pos.isThisParameter() and
    result = "this"
    or
    pos.isDelegateSelf() and
    result = "delegate-self"
  }

  string encodeArgumentPosition(ArgumentPosition pos) {
    result = pos.getPosition().toString()
    or
    pos.isQualifier() and
    result = "this"
    or
    pos.isDelegateSelf() and
    result = "delegate-self"
  }

  private string encodeCont(Content c, string arg) {
    c = TElementContent() and result = "Element" and arg = ""
    or
    exists(Field f, string qualifier, string name |
      c = TFieldContent(f) and
      f.hasFullyQualifiedName(qualifier, name) and
      arg = getQualifiedName(qualifier, name) and
      result = "Field"
    )
    or
    exists(SyntheticField f |
      c = TSyntheticFieldContent(f) and result = "SyntheticField" and arg = f
    )
  }

  string encodeContent(ContentSet c, string arg) {
    exists(Content cont |
      c.isSingleton(cont) and
      result = encodeCont(cont, arg)
    )
    or
    exists(Property p, string qualifier, string name |
      c.isProperty(p) and
      p.hasFullyQualifiedName(qualifier, name) and
      arg = getQualifiedName(qualifier, name) and
      result = "Property"
    )
  }

  string encodeWithoutContent(ContentSet c, string arg) {
    result = "WithoutElement" and
    c.isElement() and
    arg = ""
  }

  string encodeWithContent(ContentSet c, string arg) {
    result = "WithElement" and
    c.isElement() and
    arg = ""
  }

  bindingset[token]
  ParameterPosition decodeUnknownParameterPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Argument[x..y]` ranges
    token.getName() = "Argument" and
    result.getPosition() = AccessPath::parseInt(token.getAnArgument())
  }

  bindingset[token]
  ArgumentPosition decodeUnknownArgumentPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Parameter[x..y]` ranges
    token.getName() = "Parameter" and
    result.getPosition() = AccessPath::parseInt(token.getAnArgument())
  }
}

private import Make<Location, DataFlowImplSpecific::CsharpDataFlow, Input> as Impl

private module TypesInput implements Impl::Private::TypesInputSig {
  DataFlowType getSyntheticGlobalType(Impl::Private::SyntheticGlobal sg) {
    exists(sg) and
    result.asGvnType() = Gvn::getGlobalValueNumber(any(ObjectType t))
  }

  private DataFlowType getContType(Content c) {
    exists(Type t | result.asGvnType() = Gvn::getGlobalValueNumber(t) |
      t = c.(FieldContent).getField().getType()
      or
      t = c.(SyntheticFieldContent).getField().getType()
      or
      c instanceof ElementContent and
      t instanceof ObjectType // we don't know what the actual element type is
    )
  }

  DataFlowType getContentType(ContentSet c) {
    exists(Content cont |
      c.isSingleton(cont) and
      result = getContType(cont)
    )
    or
    exists(Property p |
      c.isProperty(p) and result.asGvnType() = Gvn::getGlobalValueNumber(p.getType())
    )
  }

  DataFlowType getParameterType(Impl::Public::SummarizedCallable c, ParameterPosition pos) {
    exists(Type t | result.asGvnType() = Gvn::getGlobalValueNumber(t) |
      exists(int i |
        pos.getPosition() = i and
        t = c.getParameter(i).getType()
      )
      or
      pos.isThisParameter() and
      t = c.getDeclaringType()
    )
  }

  DataFlowType getReturnType(Impl::Public::SummarizedCallable c, ReturnKind rk) {
    exists(Type t | result.asGvnType() = Gvn::getGlobalValueNumber(t) |
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

  DataFlowType getCallbackParameterType(DataFlowType t, ArgumentPosition pos) {
    exists(SystemLinqExpressions::DelegateExtType dt |
      t.asGvnType() = Gvn::getGlobalValueNumber(dt) and
      result.asGvnType() =
        Gvn::getGlobalValueNumber(dt.getDelegateType().getParameter(pos.getPosition()).getType())
    )
    or
    pos.isDelegateSelf() and
    result = t
  }

  DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) {
    rk instanceof NormalReturnKind and
    exists(SystemLinqExpressions::DelegateExtType dt |
      t.asGvnType() = Gvn::getGlobalValueNumber(dt) and
      result.asGvnType() = Gvn::getGlobalValueNumber(dt.getDelegateType().getReturnType())
    )
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

module SourceSinkInterpretationInput implements
  Impl::Private::External::SourceSinkInterpretationInputSig
{
  private import csharp as Cs

  class Element = Cs::Element;

  predicate sourceElement(
    Element e, string output, string kind, Public::Provenance provenance, string model
  ) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      QlBuiltins::ExtensionId madId
    |
      sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance, madId) and
      model = "MaD:" + madId.toString() and
      e = interpretElement(namespace, type, subtypes, name, signature, ext)
    )
  }

  predicate sinkElement(
    Element e, string input, string kind, Public::Provenance provenance, string model
  ) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      QlBuiltins::ExtensionId madId
    |
      sinkModel(namespace, type, subtypes, name, signature, ext, input, kind, provenance, madId) and
      model = "MaD:" + madId.toString() and
      e = interpretElement(namespace, type, subtypes, name, signature, ext)
    )
  }

  class SourceOrSinkElement = Element;

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
    Element getCallTarget() { result = this.asCall().(NonDelegateDataFlowCall).getATarget(_) }

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

  /** Provides additional sink specification logic. */
  bindingset[c]
  predicate interpretOutput(string c, InterpretNode mid, InterpretNode node) {
    exists(Node n | n = node.asNode() |
      (c = "Parameter" or c = "") and
      n.asParameter() = mid.asElement()
      or
      c = "" and
      n.asExpr().(AssignableRead).getTarget().getUnboundDeclaration() = mid.asElement()
    )
  }

  /** Provides additional source specification logic. */
  bindingset[c]
  predicate interpretInput(string c, InterpretNode mid, InterpretNode node) {
    c = "" and
    exists(Assignable a |
      node.asNode().asExpr() = a.getAnAssignedValue() and
      a.getUnboundDeclaration() = mid.asElement()
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
  }

  private module SummaryComponentInternal = Impl::Private::SummaryComponent;

  /** Provides predicates for constructing summary components. */
  module SummaryComponent {
    predicate content = SummaryComponentInternal::content/1;

    /** Gets a summary component for parameter `i`. */
    SummaryComponent parameter(int i) {
      exists(ArgumentPosition pos |
        result = SummaryComponentInternal::parameter(pos) and
        i = pos.getPosition()
      )
    }

    /** Gets a summary component for argument `i`. */
    SummaryComponent argument(int i) {
      exists(ParameterPosition pos |
        result = SummaryComponentInternal::argument(pos) and
        i = pos.getPosition()
      )
    }

    predicate return = SummaryComponentInternal::return/1;

    /** Gets a summary component that represents a qualifier. */
    SummaryComponent qualifier() {
      exists(ParameterPosition pos |
        result = SummaryComponentInternal::argument(pos) and
        pos.isThisParameter()
      )
    }

    /** Gets a summary component that represents an element in a collection. */
    SummaryComponent element() { result = content(any(ContentSet cs | cs.isElement())) }

    /** Gets a summary component for property `p`. */
    SummaryComponent property(Property p) {
      result = content(any(DataFlow::ContentSet c | c.isProperty(p.getUnboundDeclaration())))
    }

    /** Gets a summary component for field `f`. */
    SummaryComponent field(Field f) {
      result = content(any(DataFlow::ContentSet c | c.isField(f.getUnboundDeclaration())))
    }

    /** Gets a summary component that represents the return value of a call. */
    SummaryComponent return() { result = return(any(NormalReturnKind rk)) }

    predicate syntheticGlobal = SummaryComponentInternal::syntheticGlobal/1;

    class SyntheticGlobal = Impl::Private::SyntheticGlobal;
  }

  private module SummaryComponentStackInternal = Impl::Private::SummaryComponentStack;

  /** Provides predicates for constructing stacks of summary components. */
  module SummaryComponentStack {
    predicate singleton = SummaryComponentStackInternal::singleton/1;

    predicate push = SummaryComponentStackInternal::push/2;

    /** Gets a singleton stack for argument `i`. */
    SummaryComponentStack argument(int i) { result = singleton(SummaryComponent::argument(i)) }

    predicate return = SummaryComponentStackInternal::return/1;

    /** Gets a singleton stack representing a qualifier. */
    SummaryComponentStack qualifier() { result = singleton(SummaryComponent::qualifier()) }

    /** Gets a stack representing an element of `container`. */
    SummaryComponentStack elementOf(SummaryComponentStack container) {
      result = push(SummaryComponent::element(), container)
    }

    /** Gets a stack representing a property `p` of `object`. */
    SummaryComponentStack propertyOf(Property p, SummaryComponentStack object) {
      result = push(SummaryComponent::property(p), object)
    }

    /** Gets a stack representing a field `f` of `object`. */
    SummaryComponentStack fieldOf(Field f, SummaryComponentStack object) {
      result = push(SummaryComponent::field(f), object)
    }

    /** Gets a singleton stack representing the return value of a call. */
    SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }

    /** Gets a singleton stack representing a synthetic global with name `name`. */
    SummaryComponentStack syntheticGlobal(string synthetic) {
      result = singleton(SummaryComponent::syntheticGlobal(synthetic))
    }
  }
}

module Public = Impl::Public;

// import all instances below
private module BidirectionalImports {
  private import semmle.code.csharp.dataflow.internal.ExternalFlow
  private import semmle.code.csharp.frameworks.EntityFramework
}

private import semmle.code.csharp.frameworks.system.linq.Expressions

private predicate mayInvokeCallback(Callable c, int n) {
  c.getParameter(n).getType() instanceof SystemLinqExpressions::DelegateExtType and
  not c.hasBody() and
  (if c instanceof Accessor then not c.fromSource() else any())
}

private class SummarizedCallableWithCallback extends Public::SummarizedCallable {
  private int pos;

  SummarizedCallableWithCallback() { mayInvokeCallback(this, pos) }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    input = "Argument[" + pos + "]" and
    output = "Argument[" + pos + "].Parameter[delegate-self]" and
    preservesValue = true and
    model = "heuristic-callback"
  }

  override predicate hasProvenance(Public::Provenance provenance) { provenance = "hq-generated" }
}
