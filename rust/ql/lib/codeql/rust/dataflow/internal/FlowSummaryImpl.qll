/**
 * Provides classes and predicates for defining flow summaries.
 */

private import rust
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.FlowSummary
private import Content

module Input implements InputSig<Location, RustDataFlow> {
  private import codeql.rust.elements.internal.CallExprBaseImpl::Impl as CallExprBaseImpl
  private import codeql.rust.frameworks.stdlib.Stdlib

  class SummarizedCallableBase = string;

  abstract private class SourceSinkBase extends AstNode {
    /** Gets the associated call. */
    abstract CallExprBase getCall();

    /** Holds if the associated call resolves to `crate, path`. */
    final predicate callResolvesTo(string crate, string path) {
      exists(Resolvable r |
        r = CallExprBaseImpl::getCallResolvable(this.getCall()) and
        path = r.getResolvedPath()
      |
        crate = r.getResolvedCrateOrigin()
        or
        not r.hasResolvedCrateOrigin() and
        crate = ""
      )
    }
  }

  abstract class SourceBase extends SourceSinkBase { }

  abstract class SinkBase extends SourceSinkBase { }

  private class CallExprFunction extends SourceBase, SinkBase {
    private CallExpr call;

    CallExprFunction() { this = call.getFunction() }

    override CallExpr getCall() { result = call }
  }

  private class MethodCallExprNameRef extends SourceBase, SinkBase {
    private MethodCallExpr call;

    MethodCallExprNameRef() { this = call.getIdentifier() }

    override MethodCallExpr getCall() { result = call }
  }

  RustDataFlow::ArgumentPosition callbackSelfParameterPosition() { result.isClosureSelf() }

  ReturnKind getStandardReturnValueKind() { result = TNormalReturnKind() }

  string encodeParameterPosition(ParameterPosition pos) { result = pos.toString() }

  string encodeArgumentPosition(RustDataFlow::ArgumentPosition pos) {
    result = encodeParameterPosition(pos)
  }

  string encodeContent(ContentSet cs, string arg) {
    exists(Content c | cs = TSingletonContentSet(c) |
      result = "Field" and
      (
        exists(Addressable a, int pos, string prefix |
          // TODO: calculate in QL
          arg = prefix + "(" + pos + ")" and
          (
            prefix = a.getExtendedCanonicalPath()
            or
            a = any(OptionEnum o).getSome() and
            prefix = "crate::option::Option::Some"
            or
            exists(string name |
              a = any(ResultEnum r).getVariant(name) and
              prefix = "crate::result::Result::" + name
            )
          )
        |
          c.(TupleFieldContent).isStructField(a, pos)
          or
          c.(TupleFieldContent).isVariantField(a, pos)
        )
        or
        exists(Addressable a, string field |
          // TODO: calculate in QL
          arg = a.getExtendedCanonicalPath() + "::" + field
        |
          c.(StructFieldContent).isStructField(a, field)
          or
          c.(StructFieldContent).isVariantField(a, field)
        )
        or
        exists(int pos |
          c = TTuplePositionContent(pos) and
          arg = pos.toString()
        )
      )
      or
      result = "Reference" and
      c = TReferenceContent() and
      arg = ""
      or
      result = "Element" and
      c = TElementContent() and
      arg = ""
      or
      result = "Future" and
      c = TFutureContent() and
      arg = ""
    )
    or
    cs = TOptionalStep(arg) and result = "OptionalStep"
    or
    cs = TOptionalBarrier(arg) and result = "OptionalBarrier"
  }

  string encodeReturn(ReturnKind rk, string arg) { none() }

  string encodeWithoutContent(ContentSet c, string arg) {
    result = "Without" + encodeContent(c, arg)
  }

  string encodeWithContent(ContentSet c, string arg) { result = "With" + encodeContent(c, arg) }

  bindingset[token]
  ParameterPosition decodeUnknownParameterPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Argument[x..y]` ranges
    token.getName() = "Argument" and
    result.getPosition() = AccessPath::parseInt(token.getAnArgument())
  }

  bindingset[token]
  RustDataFlow::ArgumentPosition decodeUnknownArgumentPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Parameter[x..y]` ranges
    token.getName() = "Parameter" and
    result.getPosition() = AccessPath::parseInt(token.getAnArgument())
  }

  bindingset[token]
  ContentSet decodeUnknownContent(AccessPath::AccessPathTokenBase token) { none() }

  bindingset[token]
  ContentSet decodeUnknownWithContent(AccessPath::AccessPathTokenBase token) { none() }
}

private import Make<Location, RustDataFlow, Input> as Impl

private module StepsInput implements Impl::Private::StepsInputSig {
  DataFlowCall getACall(Public::SummarizedCallable sc) {
    result.asCallBaseExprCfgNode().getCallExprBase() = sc.(LibraryCallable).getACall()
  }

  RustDataFlow::Node getSourceNode(Input::SourceBase source, Impl::Private::SummaryComponent sc) {
    sc = Impl::Private::SummaryComponent::return(_) and
    result.asExpr().getExpr() = source.getCall()
    or
    exists(CallExprBase call, Expr arg, ArgumentPosition pos |
      result.(RustDataFlow::PostUpdateNode).getPreUpdateNode().asExpr().getExpr() = arg and
      sc = Impl::Private::SummaryComponent::argument(pos) and
      call = source.getCall() and
      arg = pos.getArgument(call)
    )
  }

  RustDataFlow::Node getSinkNode(Input::SinkBase sink, Impl::Private::SummaryComponent sc) {
    exists(CallExprBase call, Expr arg, ArgumentPosition pos |
      result.asExpr().getExpr() = arg and
      sc = Impl::Private::SummaryComponent::argument(pos) and
      call = sink.getCall() and
      arg = pos.getArgument(call)
    )
  }
}

module Private {
  import Impl::Private

  module Steps = Impl::Private::Steps<StepsInput>;

  private import codeql.rust.dataflow.FlowSource
  private import codeql.rust.dataflow.FlowSink
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
}
