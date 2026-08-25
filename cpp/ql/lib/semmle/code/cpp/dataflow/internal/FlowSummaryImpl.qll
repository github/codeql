/**
 * Provides classes and predicates for defining flow summaries.
 */

private import cpp as Cpp
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import semmle.code.cpp.ir.dataflow.internal.DataFlowNodes
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplSpecific as DataFlowImplSpecific
private import semmle.code.cpp.dataflow.ExternalFlow
private import semmle.code.cpp.ir.IR

module Input implements InputSig<Location, DataFlowImplSpecific::CppDataFlow> {
  private import codeql.util.Void

  class SummarizedCallableBase = Function;

  class SourceBase = Function;

  class SinkBase = Function;

  class FlowSummaryCallBase = CallInstruction;

  predicate callableFromSource(SummarizedCallableBase c) { exists(c.getBlock()) }

  FlowSummaryCallBase getASourceCall(SummarizedCallableBase sc) {
    result.getStaticCallTarget() = sc
  }

  DataFlowCallable getSummarizedCallableAsDataFlowCallable(SummarizedCallableBase c) {
    result.asSummarizedCallable() = c
  }

  DataFlowCallable getSourceCallEnclosingCallable(FlowSummaryCallBase call) {
    result.asSourceCallable() = call.getEnclosingFunction()
  }

  ArgumentPosition callbackSelfParameterPosition() { result = TDirectPosition(-1) }

  ReturnKind getStandardReturnValueKind() { result = getReturnValueKind("") }

  ReturnKind getReturnValueKind(string arg) {
    arg = repeatStars(result.(NormalReturnKind).getIndirectionIndex())
  }

  ParameterPosition getFlowSummaryParameterPosition(ReturnKind rk) {
    result = TFlowSummaryPosition(rk)
  }

  string encodeParameterPosition(ParameterPosition pos) { result = pos.toString() }

  string encodeArgumentPosition(ArgumentPosition pos) { result = pos.toString() }

  string encodeReturn(ReturnKind rk, string arg) {
    rk != getStandardReturnValueKind() and
    result = "ReturnValue" and
    arg = repeatStars(rk.(NormalReturnKind).getIndirectionIndex())
  }

  bindingset[namespace, type, base]
  private string formatQualifiedName(string namespace, string type, string base) {
    if namespace = ""
    then result = type + "::" + base
    else result = namespace + "::" + type + "::" + base
  }

  string encodeContent(ContentSet cs, string arg) {
    exists(FieldContent c, string namespace, string type, string base |
      cs.isSingleton(c) and
      // FieldContent indices have 0 for the address, 1 for content, so we need to subtract one.
      result = "Field" and
      c.getField().hasQualifiedName(namespace, type, base)
    |
      arg = repeatStars(c.getIndirectionIndex() - 1) + formatQualifiedName(namespace, type, base)
      or
      // TODO: This disjunct can be removed once we stop supporting unqualified field names.
      arg = repeatStars(c.getIndirectionIndex() - 1) + base
    )
    or
    exists(ElementContent ec |
      cs.isSingleton(ec) and
      result = "Element" and
      arg = repeatStars(ec.getIndirectionIndex() - 1)
    )
  }

  string encodeWithoutContent(ContentSet c, string arg) {
    // used for type tracking, not currently used in C/C++.
    none()
  }

  string encodeWithContent(ContentSet c, string arg) {
    // used for type tracking, not currently used in C/C++.
    none()
  }

  /**
   * Decodes an argument / parameter position string, for example the `0` in `Argument[0]`.
   * Supports ranges (`Argument[x..y]`), qualifiers (`Argument[-1]`), indirections
   * (`Argument[*x]`) and combinations (such as `Argument[**0..1]`).
   */
  bindingset[argString]
  private TPosition decodePosition(string argString) {
    exists(int indirection, string posString, int pos |
      argString = repeatStars(indirection) + posString and
      pos = AccessPath::parseInt(posString) and
      (
        pos >= 0 and indirection = 0 and result = TDirectPosition(pos)
        or
        pos >= 0 and indirection > 0 and result = TIndirectionPosition(pos, indirection)
        or
        // `Argument[-1]` / `Parameter[-1]` is the qualifier object `*this`, not the `this` pointer itself.
        pos = -1 and result = TIndirectionPosition(pos, indirection + 1)
      )
    )
  }

  bindingset[token]
  ParameterPosition decodeUnknownParameterPosition(AccessPath::AccessPathTokenBase token) {
    token.getName() = "Argument" and
    result = decodePosition(token.getAnArgument())
  }

  bindingset[token]
  ArgumentPosition decodeUnknownArgumentPosition(AccessPath::AccessPathTokenBase token) {
    token.getName() = "Parameter" and
    result = decodePosition(token.getAnArgument())
  }
}

private import Make<Location, DataFlowImplSpecific::CppDataFlow, Input> as Impl

private class ConversionCall extends Call {
  ConversionCall() { this.getTarget() instanceof ConversionOperator }
}

private module Input2 implements Impl::Private::InputSig2 {
  private import codeql.util.Void

  pragma[nomagic]
  private predicate hasFunctionAndIndirectionIndex(
    Function f, int indirectionIndex, Ssa::ExplicitDefinition def
  ) {
    def.getFunction() = f and
    def.getSourceVariable().getIRVariable() instanceof IRReturnVariable and
    def.getIndirectionIndex() = indirectionIndex
  }

  /** Holds if `def` defines `e` as a returned value with return kind `rk`. */
  bindingset[rk, e]
  private predicate isReturnExpr(Function f, ReturnKind rk, Expr e) {
    exists(Ssa::ExplicitDefinition def |
      hasFunctionAndIndirectionIndex(f, rk.getIndirectionIndex(), def) and
      e =
        def.getAssignedInstruction()
            .(StoreInstruction)
            .getSourceValue()
            .getUnconvertedResultExpression()
    )
  }

  private MemberFunction getFunctionFromType(Expr e) {
    result.getClassAndName("operator()").getADerivedClass*() = e.getUnspecifiedType()
  }

  private Function getFunctionFromExpr(Expr e) {
    result = e.(FunctionAccess).getTarget()
    or
    result = e.(ConversionCall).getQualifier().(LambdaExpression).getLambdaFunction()
  }

  private module GetAnUltimateDefinitionInput implements Ssa::GetAnUltimateDefinitionSig {
    predicate isRelevantUltimateDefinition(Ssa::Definition def) {
      exists(
        getFunctionFromExpr(def.(Ssa::DirectExplicitDefinition)
              .getAssignedInstruction()
              .(StoreInstruction)
              .getSourceValue()
              .getUnconvertedResultExpression())
      )
    }
  }

  private Ssa::Definition getAnUltimateDefinition(Ssa::Definition def) {
    result =
      Ssa::GetAnUltimateDefinition<GetAnUltimateDefinitionInput>::getAnUltimateDefinition(def)
  }

  class SourceSinkReportingElement extends Element {
    SourceSinkReportingElement() { this instanceof Expr or this instanceof Parameter }

    DataFlowCallable getEnclosingCallable() {
      result.asSourceCallable() =
        [this.(Expr).getEnclosingFunction(), this.(Parameter).getFunction()]
    }

    /** Gets the function invoked when this element is used as a callback. */
    private Function getCallable() {
      // The expression is a struct which implements `operator()`.
      result = getFunctionFromType(this)
      or
      // The expression is a function pointer
      result = getFunctionFromExpr(this)
      or
      // The expression is an SSA read of an assignment of a callable
      exists(Ssa::Definition def |
        def.getAUse().getDef().getUnconvertedResultExpression() = this and
        result =
          getFunctionFromExpr(getAnUltimateDefinition(def)
                .(Ssa::DirectExplicitDefinition)
                .getAssignedInstruction()
                .(StoreInstruction)
                .getSourceValue()
                .getUnconvertedResultExpression())
      )
    }

    SourceSinkReportingElement getASuccessor(Impl::Private::SummaryComponent sc) {
      exists(Function f | f = this.getCallable() |
        exists(ParameterPosition pos | sc = Impl::Private::SummaryComponent::parameter(pos) |
          result = pos.getParameter(f)
        )
        or
        exists(ReturnKind rk |
          sc = Impl::Private::SummaryComponent::return(rk) and
          isReturnExpr(f, rk, result)
        )
      )
    }
  }

  bindingset[source, sc]
  SourceSinkReportingElement getASourceReportingElement(
    Input::SourceBase source, Impl::Private::SummaryComponent sc
  ) {
    exists(Call call | call.getTarget() = source |
      sc = Impl::Private::SummaryComponent::return(_) and
      result = call
      or
      exists(ArgumentPosition pos |
        sc = Impl::Private::SummaryComponent::argument(pos) and
        result = pos.getArgument(call)
      )
    )
    or
    exists(ParameterPosition pos |
      sc = Impl::Private::SummaryComponent::parameter(pos) and
      result = pos.getParameter(source)
    )
  }

  pragma[nomagic]
  private IndirectReturnOutNode getIndirectReturn(CallInstruction call, NormalReturnKind rk) {
    result.getCallInstruction() = call and
    pragma[only_bind_out](result.getIndirectionIndex()) =
      pragma[only_bind_out](rk.getIndirectionIndex())
  }

  pragma[nomagic]
  private predicate hasKindAndEnclosingFunction(Function f, ReturnKind rk, ReturnNode r) {
    r.getEnclosingCallable().asSourceCallable() = f and
    r.getKind() = rk
  }

  pragma[nomagic]
  private predicate hasParameterAndIndirectionIndex(
    Parameter p, int indirectionIndex, ParameterNode n
  ) {
    n.getParameter() = p and
    n.getIndirectionIndex() = indirectionIndex
  }

  bindingset[e, sc]
  Node getSourceDataFlowNode(SourceSinkReportingElement e, Impl::Private::SummaryComponent sc) {
    exists(DataFlowCall call |
      exists(ArgumentPosition pos |
        sc = Impl::Private::SummaryComponent::argument(pos) and
        pos.getArgument(call.asCallInstruction().getUnconvertedResultExpression()) = e
      |
        pos.getIndirectionIndex() = 0 and
        result.(PostUpdateNode).getPreUpdateNode().asExpr() = e
        or
        result.(PostUpdateNode).getPreUpdateNode().asIndirectExpr(pos.getIndirectionIndex()) = e
      )
      or
      exists(ReturnKind rk |
        sc = Impl::Private::SummaryComponent::return(rk) and
        // When `e` is a call the node becomes an `OutNode`.
        e = call.asCallInstruction().getUnconvertedResultExpression()
      |
        rk.getIndirectionIndex() = 0 and
        simpleOutNode(result, call.asCallInstruction())
        or
        result = getIndirectReturn(call.asCallInstruction(), rk)
      )
    )
    or
    exists(ParameterPosition pos |
      sc = Impl::Private::SummaryComponent::parameter(pos) and
      hasParameterAndIndirectionIndex(e, pos.getIndirectionIndex(), result)
    )
    or
    exists(Function f, ReturnKind rk |
      sc = Impl::Private::SummaryComponent::return(rk) and
      // When `e` is the returned expression from a function the node is
      // the `ReturnNode`.
      isReturnExpr(f, rk, e) and
      hasKindAndEnclosingFunction(f, rk, result)
    )
  }

  bindingset[sink, sc]
  SourceSinkReportingElement getASinkReportingElement(
    Input::SinkBase sink, Impl::Private::SummaryComponent sc
  ) {
    exists(Call call, ArgumentPosition pos |
      call.getTarget() = sink and
      sc = Impl::Private::SummaryComponent::argument(pos) and
      result = pos.getArgument(call)
    )
  }

  bindingset[e, sc]
  Node getSinkDataFlowNode(SourceSinkReportingElement e, Impl::Private::SummaryComponent sc) {
    exists(ArgumentPosition pos, CallInstruction call |
      sc = Impl::Private::SummaryComponent::argument(pos) and
      pos.getArgument(call.getUnconvertedResultExpression()) = e and
      result.(ArgumentNode).sourceArgumentOf(call, pos)
    )
    or
    exists(Function f, ReturnKind rk |
      sc = Impl::Private::SummaryComponent::return(rk) and
      isReturnExpr(f, rk, e) and
      hasKindAndEnclosingFunction(f, rk, result)
    )
  }
}

private import Impl::Private::Make2<Input2> as Impl2

private module StepsInput implements Impl2::StepsInputSig {
  Impl2::SummaryNode getSummaryNode(Node n) { result = n.(FlowSummaryNode).getSummaryNode() }

  DataFlowCall getACall(Public::SummarizedCallable sc) {
    result.getStaticCallTarget().getUnderlyingCallable() = sc
  }

  Node getSourceOutNode(Input::FlowSummaryCallBase call, ReturnKind rk) {
    exists(IndirectReturnOutNode out | result = out |
      out.getCallInstruction() = call and
      pragma[only_bind_out](rk.(NormalReturnKind).getIndirectionIndex()) =
        pragma[only_bind_out](out.getIndirectionIndex())
    )
  }
}

module SourceSinkInterpretationInput implements
  Impl::Private::External::SourceSinkInterpretationInputSig
{
  class Element = Cpp::Element;

  class SourceOrSinkElement = Element;

  /**
   * Holds if an external source specification exists for `e` with output specification
   * `output`, kind `kind`, and provenance `provenance`.
   */
  predicate sourceElement(
    SourceOrSinkElement e, string output, string kind, Public::Provenance provenance, string model
  ) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext
    |
      sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance, model) and
      e = interpretElement(namespace, type, subtypes, name, signature, ext)
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
      string package, string type, boolean subtypes, string name, string signature, string ext
    |
      sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance, model) and
      e = interpretElement(package, type, subtypes, name, signature, ext)
    )
  }

  predicate barrierElement(
    Element e, string output, string kind, Public::Provenance provenance, string model
  ) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext
    |
      barrierModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance, model) and
      e = interpretElement(namespace, type, subtypes, name, signature, ext)
    )
  }

  predicate barrierGuardElement(
    Element e, string input, Public::AcceptingValue acceptingValue, string kind,
    Public::Provenance provenance, string model
  ) {
    exists(
      string package, string type, boolean subtypes, string name, string signature, string ext
    |
      barrierGuardModel(package, type, subtypes, name, signature, ext, input, acceptingValue, kind,
        provenance, model) and
      e = interpretElement(package, type, subtypes, name, signature, ext)
    )
  }

  private newtype TInterpretNode =
    TElement_(Element n) or
    TNode_(Node n)

  /** An entity used to interpret a source/sink specification. */
  class InterpretNode extends TInterpretNode {
    /** Gets the element that this node corresponds to, if any. */
    SourceOrSinkElement asElement() { this = TElement_(result) }

    /** Gets the data-flow node that this node corresponds to, if any. */
    Node asNode() { this = TNode_(result) }

    /** Gets the call that this node corresponds to, if any. */
    DataFlowCall asCall() {
      this.asElement() = result.asCallInstruction().getUnconvertedResultExpression()
    }

    /** Gets the callable that this node corresponds to, if any. */
    DataFlowCallable asCallable() { result.getUnderlyingCallable() = this.asElement() }

    /** Gets the target of this call, if any. */
    Element getCallTarget() { result = this.asCall().getStaticCallTarget().getUnderlyingCallable() }

    /** Gets a textual representation of this node. */
    string toString() {
      result = this.asElement().toString()
      or
      result = this.asNode().toStringImpl()
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
  predicate interpretOutput(string c, InterpretNode mid, InterpretNode node) { none() }

  /** Provides additional source specification logic. */
  bindingset[c]
  predicate interpretInput(string c, InterpretNode mid, InterpretNode node) { none() }
}

module Private {
  import Impl::Private
  import Impl2

  module Steps = Impl2::Steps<StepsInput>;

  module External {
    import Impl::Private::External
    import Impl::Private::External::SourceSinkInterpretation<SourceSinkInterpretationInput>
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
  }

  /**
   * Provides predicates for constructing stacks of summary components.
   */
  module SummaryComponentStack {
    private import Impl::Private::SummaryComponentStack as SCS

    predicate singleton = SCS::singleton/1;

    predicate push = SCS::push/2;

    predicate argument = SCS::argument/1;
  }
}

module Public = Impl::Public;

private class SourceModelFunction extends Public::SourceElement instanceof Function {
  private string namespace;
  private string type;
  private boolean subtypes;
  private string name;
  private string signature;
  private string ext;

  SourceModelFunction() {
    sourceModel(namespace, type, subtypes, name, signature, ext, _, _, _, _) and
    this = interpretElement(namespace, type, subtypes, name, signature, ext)
  }

  override predicate isSource(
    string output, string kind, Public::Provenance provenance, string model
  ) {
    sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance, model)
  }
}

private class SinkModelFunction extends Public::SinkElement instanceof Function {
  private string namespace;
  private string type;
  private boolean subtypes;
  private string name;
  private string signature;
  private string ext;

  SinkModelFunction() {
    sinkModel(namespace, type, subtypes, name, signature, ext, _, _, _, _) and
    this = interpretElement(namespace, type, subtypes, name, signature, ext)
  }

  override predicate isSink(string input, string kind, Public::Provenance provenance, string model) {
    sinkModel(namespace, type, subtypes, name, signature, ext, input, kind, provenance, model)
  }
}
