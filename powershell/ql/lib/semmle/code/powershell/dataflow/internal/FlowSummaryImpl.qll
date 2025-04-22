/**
 * Provides classes and predicates for defining flow summaries.
 */

private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import powershell
private import semmle.code.powershell.dataflow.internal.DataFlowImplSpecific as DataFlowImplSpecific
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public

module Input implements InputSig<Location, DataFlowImplSpecific::PowershellDataFlow> {
  private import codeql.util.Void

  class SummarizedCallableBase = string;

  class SourceBase = Void;

  class SinkBase = Void;

  ArgumentPosition callbackSelfParameterPosition() { none() }

  ReturnKind getStandardReturnValueKind() { result instanceof NormalReturnKind }

  string encodeParameterPosition(ParameterPosition pos) {
    exists(int i |
      pos.isPositional(i, emptyNamedSet()) and
      result = i.toString()
    )
    or
    exists(string name |
      pos.isKeyword(name) and
      result = "-" + name
    )
    or
    pos.isThis() and
    result = "this"
    or
    pos.isPipeline() and
    result = "pipeline"
  }

  string encodeArgumentPosition(ArgumentPosition pos) {
    pos.isThis() and result = "this"
    or
    pos.isPipeline() and result = "pipeline"
    or
    exists(int i |
      pos.isPositional(i, emptyNamedSet()) and
      result = i.toString()
    )
    or
    exists(string name |
      pos.isKeyword(name) and
      result = "-" + name
    )
  }

  string encodeContent(ContentSet cs, string arg) {
    exists(Content c | cs.isSingleton(c) |
      c = TFieldContent(arg) and result = "Field"
      or
      exists(ConstantValue cv | c = TKnownKeyContent(cv) or c = TKnownPositionalContent(cv) |
        result = "Element" and
        arg = cv.serialize() + "!"
      )
    )
    or
    cs.isAnyPositional() and result = "Element" and arg = "?"
    or
    cs.isUnknownKeyContent() and result = "Element" and arg = "#"
    or
    cs.isAnyElement() and result = "Element" and arg = "any"
    or
    exists(Content::KnownElementContent kec |
      cs = TKnownOrUnknownKeyContentSet(kec) or cs = TKnownOrUnknownPositionalContentSet(kec)
    |
      result = "Element" and
      arg = kec.getIndex().serialize()
    )
  }

  string encodeReturn(ReturnKind rk, string arg) {
    not rk = Input::getStandardReturnValueKind() and
    result = "ReturnValue" and
    arg = rk.toString()
  }

  string encodeWithoutContent(ContentSet c, string arg) {
    result = "Without" + encodeContent(c, arg)
  }

  string encodeWithContent(ContentSet c, string arg) { result = "With" + encodeContent(c, arg) }

  bindingset[token]
  ParameterPosition decodeUnknownParameterPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Argument[x..y]` ranges
    token.getName() = "Argument" and
    result.isPositional(AccessPath::parseInt(token.getAnArgument()), emptyNamedSet())
  }

  bindingset[token]
  ArgumentPosition decodeUnknownArgumentPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Parameter[x..y]` ranges
    token.getName() = "Parameter" and
    result.isPositional(AccessPath::parseInt(token.getAnArgument()), emptyNamedSet())
  }

  bindingset[token]
  ContentSet decodeUnknownContent(AccessPath::AccessPathTokenBase token) {
    token.getName() = "Element" and
    result = TSingletonContentSet(TUnknownKeyOrPositionContent())
  }

  bindingset[token]
  ContentSet decodeUnknownWithContent(AccessPath::AccessPathTokenBase token) {
    token.getName() = "WithElement" and
    result = TAnyElementContentSet()
  }
}

private import Make<Location, DataFlowImplSpecific::PowershellDataFlow, Input> as Impl

private module StepsInput implements Impl::Private::StepsInputSig {
  DataFlowCall getACall(Public::SummarizedCallable sc) {
    result.asCall().getAstNode() = sc.(LibraryCallable).getACall()
    or
    result.asCall().getAstNode() = sc.(LibraryCallable).getACallSimple()
  }

  Node getSourceNode(Input::SourceBase source, Impl::Private::SummaryComponent sc) { none() }

  Node getSinkNode(Input::SinkBase source, Impl::Private::SummaryComponent sc) { none() }
}

module Private {
  import Impl::Private

  module Steps = Impl::Private::Steps<StepsInput>;

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

    /** Gets a summary component that represents a receiver. */
    SummaryComponent receiver() { result = argument(any(ParameterPosition pos | pos.isThis())) }

    /** Gets a summary component that represents an element in a collection at an unknown index. */
    SummaryComponent elementUnknown() {
      result = SC::content(TSingletonContentSet(TUnknownKeyOrPositionContent()))
    }

    /** Gets a summary component that represents an element in a collection at a known index. */
    SummaryComponent elementKnown(ConstantValue cv) {
      result = SC::content(TSingletonContentSet(Content::getKnownElementContent(cv)))
    }

    /**
     * Gets a summary component that represents an element in a collection at a specific
     * known index `cv`, or an unknown index.
     */
    SummaryComponent elementKnownOrUnknown(ConstantValue cv) {
      result =
        SC::content(any(ContentSet cs |
            cs.isKnownOrUnknownElement(Content::getKnownElementContent(cv))
          ))
      or
      not exists(
        any(ContentSet cs | cs.isKnownOrUnknownElement(Content::getKnownElementContent(cv)))
      ) and
      result = elementUnknown()
    }

    /**
     * Gets a summary component that represents an element in a collection at either an unknown
     * index or known index. This has the same semantics as
     *
     * ```ql
     * elementKnown() or elementUnknown(_)
     * ```
     *
     * but is more efficient, because it is represented by a single value.
     */
    SummaryComponent elementAny() { result = SC::content(TAnyElementContentSet()) }

    /** Gets a summary component that represents the return value of a call. */
    SummaryComponent return() { result = SC::return(any(NormalReturnKind rk)) }
  }

  /**
   * Provides predicates for constructing stacks of summary components.
   */
  module SummaryComponentStack {
    private import Impl::Private::SummaryComponentStack as SCS

    predicate singleton = SCS::singleton/1;

    predicate push = SCS::push/2;

    predicate argument = SCS::argument/1;

    /** Gets a singleton stack representing a receiver. */
    SummaryComponentStack receiver() { result = singleton(SummaryComponent::receiver()) }

    /** Gets a singleton stack representing the return value of a call. */
    SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
  }
}

module Public = Impl::Public;

module ParsePositions {
  private import Private

  private predicate isParamBody(string body) {
    body = any(AccessPathToken tok).getAnArgument("Parameter")
  }

  private predicate isArgBody(string body) {
    body = any(AccessPathToken tok).getAnArgument("Argument")
  }

  predicate isParsedParameterPosition(string c, int i) {
    isParamBody(c) and
    i = AccessPath::parseInt(c)
  }

  predicate isParsedArgumentPosition(string c, int i) {
    isArgBody(c) and
    i = AccessPath::parseInt(c)
  }

  predicate isParsedKeywordParameterPosition(string c, string paramName) {
    isParamBody(c) and
    c = paramName + ":"
  }

  predicate isParsedKeywordArgumentPosition(string c, string paramName) {
    isArgBody(c) and
    c = paramName + ":"
  }
}
