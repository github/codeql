/**
 * Provides classes and predicates for defining flow summaries.
 */

private import rust
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.internal.PathResolution
private import codeql.rust.dataflow.FlowSummary
private import codeql.rust.dataflow.Ssa
private import codeql.rust.dataflow.internal.ModelsAsData
private import Content

predicate encodeContentTupleField(TupleFieldContent c, string arg) {
  exists(Addressable a, int pos, string prefix |
    arg = prefix + "(" + pos + ")" and prefix = a.getCanonicalPath()
  |
    c.isStructField(a, pos) or c.isVariantField(a, pos)
  )
}

predicate encodeContentStructField(StructFieldContent c, string arg) {
  exists(Addressable a, string field | arg = a.getCanonicalPath() + "::" + field |
    c.isStructField(a, field) or c.isVariantField(a, field)
  )
}

module Input implements InputSig<Location, RustDataFlow> {
  private import codeql.rust.frameworks.stdlib.Stdlib

  class SummarizedCallableBase = Function;

  predicate callableFromSource(SummarizedCallableBase c) { c.fromSource() }

  abstract private class SourceSinkBase extends AstNode {
    /** Gets the associated call. */
    abstract Call getCall();

    /** Holds if the associated call resolves to `path`. */
    final predicate callResolvesTo(string path) {
      path = this.getCall().getResolvedTarget().getCanonicalPath()
    }
  }

  abstract class SourceBase extends SourceSinkBase { }

  abstract class SinkBase extends SourceSinkBase { }

  predicate neutralElement(
    Input::SummarizedCallableBase c, string kind, string provenance, boolean isExact
  ) {
    exists(string path |
      neutralModel(path, kind, provenance, _) and
      c.getCanonicalPath() = path and
      isExact = true
    )
  }

  private class CallExprFunction extends SourceBase, SinkBase {
    private CallExpr call;

    CallExprFunction() { this = call.getFunction() }

    override Call getCall() { result = call }
  }

  private class MethodCallExprNameRef extends SourceBase, SinkBase {
    private MethodCallExpr call;

    MethodCallExprNameRef() { this = call.getIdentifier() }

    override MethodCallExpr getCall() { result = call }
  }

  RustDataFlow::ArgumentPosition callbackSelfParameterPosition() { result.isClosureSelf() }

  ReturnKind getStandardReturnValueKind() { result = TNormalReturnKind() }

  string encodeParameterPosition(RustDataFlow::ParameterPosition pos) { result = pos.toString() }

  string encodeArgumentPosition(RustDataFlow::ArgumentPosition pos) { result = pos.toString() }

  string encodeContent(ContentSet cs, string arg) {
    exists(Content c | cs = TSingletonContentSet(c) |
      result = "Field" and
      (
        encodeContentTupleField(c, arg)
        or
        encodeContentStructField(c, arg)
        or
        exists(int pos | c = TTuplePositionContent(pos) and arg = pos.toString())
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
  RustDataFlow::ParameterPosition decodeUnknownParameterPosition(
    AccessPath::AccessPathTokenBase token
  ) {
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
  DataFlowCall getACall(Public::SummarizedCallable sc) { result.asCall().getStaticTarget() = sc }

  /** Gets the argument of `source` described by `sc`, if any. */
  private Expr getSourceNodeArgument(Input::SourceBase source, Impl::Private::SummaryComponent sc) {
    exists(RustDataFlow::ArgumentPosition pos |
      sc = Impl::Private::SummaryComponent::argument(pos) and
      result = pos.getArgument(source.getCall())
    )
  }

  /** Get the callable that `expr` refers to. */
  private Callable getCallable(Expr expr) {
    result = resolvePath(expr.(PathExpr).getPath()).(Function)
    or
    result = expr.(ClosureExpr)
    or
    // The expression is an SSA read of an assignment of a closure
    exists(Ssa::Definition def |
      def.getARead() = expr and
      def.getAnUltimateDefinition().(Ssa::WriteDefinition).assigns(result.(ClosureExpr))
    )
  }

  RustDataFlow::DataFlowCallable getSourceNodeEnclosingCallable(Input::SourceBase source) {
    result.asCfgScope() = source.getEnclosingCfgScope()
  }

  RustDataFlow::Node getSourceNode(Input::SourceBase source, Impl::Private::SummaryComponentStack s) {
    s.head() = Impl::Private::SummaryComponent::return(_) and
    result.asExpr() = source.getCall()
    or
    exists(RustDataFlow::ArgumentPosition pos, Expr arg |
      s.head() = Impl::Private::SummaryComponent::parameter(pos) and
      arg = getSourceNodeArgument(source, s.tail().headOfSingleton()) and
      result.asParameter() = getCallable(arg).getParam(pos.getPosition())
    )
    or
    result.(RustDataFlow::PostUpdateNode).getPreUpdateNode().asExpr() =
      getSourceNodeArgument(source, s.headOfSingleton())
  }

  RustDataFlow::Node getSinkNode(Input::SinkBase sink, Impl::Private::SummaryComponent sc) {
    exists(InvocationExpr call, Expr arg, RustDataFlow::ArgumentPosition pos |
      result.asExpr() = arg and
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
