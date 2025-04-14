/**
 * Provides classes and predicates for defining flow summaries.
 */

private import cpp as Cpp
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplSpecific as DataFlowImplSpecific
private import semmle.code.cpp.dataflow.ExternalFlow
private import semmle.code.cpp.ir.IR

module Input implements InputSig<Location, DataFlowImplSpecific::CppDataFlow> {
  private import codeql.util.Void

  class SummarizedCallableBase = Function;

  class SourceBase = Void;

  class SinkBase = Void;

  ArgumentPosition callbackSelfParameterPosition() { result = TDirectPosition(-1) }

  ReturnKind getStandardReturnValueKind() { result.(NormalReturnKind).getIndirectionIndex() = 0 }

  string encodeParameterPosition(ParameterPosition pos) { result = pos.toString() }

  string encodeArgumentPosition(ArgumentPosition pos) { result = pos.toString() }

  string encodeReturn(ReturnKind rk, string arg) {
    rk != getStandardReturnValueKind() and
    result = "ReturnValue" and
    arg = repeatStars(rk.(NormalReturnKind).getIndirectionIndex())
  }

  string encodeContent(ContentSet cs, string arg) {
    exists(FieldContent c |
      cs.isSingleton(c) and
      // FieldContent indices have 0 for the address, 1 for content, so we need to subtract one.
      result = "Field" and
      arg = repeatStars(c.getIndirectionIndex() - 1) + c.getField().getName()
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

private module StepsInput implements Impl::Private::StepsInputSig {
  DataFlowCall getACall(Public::SummarizedCallable sc) {
    result.getStaticCallTarget().getUnderlyingCallable() = sc
  }

  Node getSourceNode(Input::SourceBase source, Impl::Private::SummaryComponent sc) { none() }

  Node getSinkNode(Input::SinkBase sink, Impl::Private::SummaryComponent sc) { none() }
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
    // Allow variables to be picked as output nodes.
    exists(Node n, Element ast |
      n = node.asNode() and
      ast = mid.asElement()
    |
      c = "" and
      n.asExpr().(VariableAccess).getTarget() = ast
    )
  }

  /** Provides additional source specification logic. */
  bindingset[c]
  predicate interpretInput(string c, InterpretNode mid, InterpretNode node) {
    exists(Node n, Element ast, VariableAccess e |
      n = node.asNode() and
      ast = mid.asElement() and
      e.getTarget() = ast
    |
      // Allow variables to be picked as input nodes.
      // We could simply do this as `e = n.asExpr()`, but that would not allow
      // us to pick `x` as a sink in an example such as `x = source()` (but
      // only subsequent uses of `x`) since the variable access on `x` doesn't
      // actually load the value of `x`. So instead, we pick the instruction
      // node corresponding to the generated `StoreInstruction` and use the
      // expression associated with the destination instruction. This means
      // that the `x` in `x = source()` can be marked as an input.
      c = "" and
      exists(StoreInstruction store |
        store.getDestinationAddress().getUnconvertedResultExpression() = e and
        n.asInstruction() = store
      )
    )
  }
}

module Private {
  import Impl::Private

  module Steps = Impl::Private::Steps<StepsInput>;

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
