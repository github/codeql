/**
 * Provides classes and predicates for defining flow summaries.
 */

private import swift
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import DataFlowImplSpecific as DataFlowImplSpecific
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
private import DataFlowImplCommon
private import codeql.swift.dataflow.ExternalFlow

module Input implements InputSig<Location, DataFlowImplSpecific::SwiftDataFlow> {
  private import codeql.util.Void

  class SummarizedCallableBase = Function;

  class SourceBase = Void;

  class SinkBase = Void;

  ArgumentPosition callbackSelfParameterPosition() { result instanceof ThisArgumentPosition }

  ReturnKind getStandardReturnValueKind() { result instanceof NormalReturnKind }

  string encodeParameterPosition(ParameterPosition pos) { result = pos.toString() }

  string encodeArgumentPosition(ArgumentPosition pos) { result = pos.toString() }

  string encodeReturn(ReturnKind rk, string arg) {
    rk != getStandardReturnValueKind() and
    result = "ReturnValue" and
    arg = rk.toString()
  }

  string encodeContent(ContentSet cs, string arg) {
    exists(Content::FieldContent c |
      cs.isSingleton(c) and
      result = "Field" and
      arg = c.getField().getName()
    )
    or
    exists(Content::TupleContent c |
      cs.isSingleton(c) and
      result = "TupleElement" and
      arg = c.getIndex().toString()
    )
    or
    exists(Content::EnumContent c, string sig |
      cs.isSingleton(c) and
      sig = c.getSignature()
    |
      if sig = "some:0"
      then
        result = "OptionalSome" and
        arg = ""
      else (
        result = "EnumElement" and
        arg = sig
      )
    )
    or
    exists(Content::CollectionContent c |
      cs.isSingleton(c) and
      result = "CollectionElement" and
      arg = ""
    )
  }

  string encodeWithoutContent(ContentSet c, string arg) {
    result = "WithoutContent" + c and arg = ""
  }

  string encodeWithContent(ContentSet c, string arg) { result = "WithContent" + c and arg = "" }

  bindingset[token]
  ContentSet decodeUnknownContent(AccessPath::AccessPathTokenBase token) {
    // map legacy "ArrayElement" specification components to `CollectionContent`
    token.getName() = "ArrayElement" and
    result.isSingleton(any(Content::CollectionContent c))
    or
    token.getName() = "CollectionElement" and
    result.isSingleton(any(Content::CollectionContent c))
  }

  bindingset[token]
  ParameterPosition decodeUnknownParameterPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Argument[x..y]` ranges and `Argument[-1]`
    token.getName() = "Argument" and
    exists(int pos | pos = AccessPath::parseInt(token.getAnArgument()) |
      result.(PositionalParameterPosition).getIndex() = pos
      or
      pos = -1 and result instanceof ThisParameterPosition
    )
  }

  bindingset[token]
  ArgumentPosition decodeUnknownArgumentPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Parameter[x..y]` ranges and `Parameter[-1]`
    token.getName() = "Parameter" and
    exists(int pos | pos = AccessPath::parseInt(token.getAnArgument()) |
      result.(PositionalArgumentPosition).getIndex() = pos
      or
      pos = -1 and
      result instanceof ThisArgumentPosition
    )
  }
}

private import Make<Location, DataFlowImplSpecific::SwiftDataFlow, Input> as Impl

private module StepsInput implements Impl::Private::StepsInputSig {
  DataFlowCall getACall(Public::SummarizedCallable sc) { result.asCall().getStaticTarget() = sc }

  Node getSourceNode(Input::SourceBase source, Impl::Private::SummaryComponent sc) { none() }

  Node getSinkNode(Input::SinkBase sink, Impl::Private::SummaryComponent sc) { none() }
}

module SourceSinkInterpretationInput implements
  Impl::Private::External::SourceSinkInterpretationInputSig
{
  class Element = AstNode;

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
      sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance) and
      model = "" and // TODO: Insert MaD provenance from sourceModel
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
      sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance) and
      model = "" and // TODO: Insert MaD provenance from sinkModel
      e = interpretElement(package, type, subtypes, name, signature, ext)
    )
  }

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
    Element getCallTarget() { result = this.asCall().asCall().getStaticTarget() }

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
    // Allow fields to be picked as output nodes.
    exists(Node n, AstNode ast |
      n = node.asNode() and
      ast = mid.asElement()
    |
      c = "" and
      n.asExpr().(MemberRefExpr).getMember() = ast
    )
  }

  /** Provides additional source specification logic. */
  bindingset[c]
  predicate interpretInput(string c, InterpretNode mid, InterpretNode node) {
    exists(Node n, AstNode ast, MemberRefExpr e |
      n = node.asNode() and
      ast = mid.asElement() and
      e.getMember() = ast
    |
      // Allow post update nodes to be picked as input nodes when the `input` column
      // of the row is `PostUpdate`.
      c = "PostUpdate" and
      e.getBase() = n.(PostUpdateNode).getPreUpdateNode().asExpr()
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
