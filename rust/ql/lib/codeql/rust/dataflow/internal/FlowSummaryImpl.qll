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
private import Node

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
  private import codeql.util.Void

  class SummarizedCallableBase = Function;

  class FlowSummaryCallBase extends Void {
    Location getLocation() { none() }
  }

  predicate callableFromSource(SummarizedCallableBase c) { c.fromSource() }

  DataFlowCallable getSummarizedCallableAsDataFlowCallable(SummarizedCallableBase c) {
    result.asSummarizedCallable() = c
  }

  class SourceBase = Function;

  class SinkBase = Function;

  predicate neutralElement(
    Input::SummarizedCallableBase c, string kind, string provenance, boolean isExact
  ) {
    exists(string path |
      neutralModel(path, kind, provenance, _) and
      c.getCanonicalPath() = path and
      isExact = true
    )
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

/** Gets the argument of `call` described by `sc`, if any. */
private Expr getArg(Call call, Impl::Private::SummaryComponent sc) {
  exists(RustDataFlow::ArgumentPosition pos |
    sc = Impl::Private::SummaryComponent::argument(pos) and
    result = pos.getArgument(call)
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

module Input2 implements Impl::Private::InputSig2 {
  private import codeql.rust.controlflow.CfgNodes

  class SourceSinkReportingElement extends AstNode {
    DataFlowCallable getEnclosingCallable() { result.asCfgScope() = this.getEnclosingCfgScope() }

    SourceSinkReportingElement getASuccessor(Impl::Private::SummaryComponent sc) {
      exists(RustDataFlow::ArgumentPosition pos |
        sc = Impl::Private::SummaryComponent::parameter(pos) and
        result = pos.getParameter(getCallable(this))
      )
      or
      exists(Callable c |
        sc = Impl::Private::SummaryComponent::return(_) and
        c = getCallable(this) and
        result.getACfgNode().getASuccessor() instanceof AnnotatedExitCfgNode and
        result.getEnclosingCfgScope() = c
      )
    }
  }

  SourceSinkReportingElement getASourceReportingElement(
    Input::SourceBase source, Impl::Private::SummaryComponent sc
  ) {
    exists(Call call | call.getResolvedTarget() = source |
      sc = Impl::Private::SummaryComponent::return(_) and
      result = call
      or
      result = getArg(call, sc)
    )
    or
    exists(RustDataFlow::ArgumentPosition pos |
      sc = Impl::Private::SummaryComponent::parameter(pos)
    |
      exists(Function f |
        f = source
        or
        f.implements(source)
      |
        result = pos.getParameter(f)
      )
    )
  }

  bindingset[e, sc]
  NodePublic getSourceDataFlowNode(SourceSinkReportingElement e, Impl::Private::SummaryComponent sc) {
    if sc = Impl::Private::SummaryComponent::argument(_)
    then result.(PostUpdateNode).getPreUpdateNode().(Node).getAstNode() = e
    else result.(Node).getAstNode() = e
  }

  SourceSinkReportingElement getASinkReportingElement(
    Input::SinkBase sink, Impl::Private::SummaryComponent sc
  ) {
    exists(Call call |
      call.getResolvedTarget() = sink and
      result = getArg(call, sc)
    )
  }

  bindingset[e, sc]
  NodePublic getSinkDataFlowNode(SourceSinkReportingElement e, Impl::Private::SummaryComponent sc) {
    result.asExpr() = e and
    exists(sc)
  }
}

private import Impl::Private::Make2<Input2> as Impl2

module StepsInput implements Impl2::StepsInputSig {
  Impl2::SummaryNode getSummaryNode(RustDataFlow::Node n) {
    result = n.(FlowSummaryNode).getSummaryNode()
  }

  DataFlowCall getACall(Public::SummarizedCallable sc) { result.asCall().getStaticTarget() = sc }
}

module Private {
  import Impl::Private
  import Impl2

  module Steps = Impl2::Steps<StepsInput>;

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
