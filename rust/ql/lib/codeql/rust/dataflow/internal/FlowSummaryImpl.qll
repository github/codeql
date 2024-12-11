/**
 * Provides classes and predicates for defining flow summaries.
 */

private import rust
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.FlowSummary

module Input implements InputSig<Location, RustDataFlow> {
  class SummarizedCallableBase = string;

  RustDataFlow::ArgumentPosition callbackSelfParameterPosition() { none() }

  ReturnKind getStandardReturnValueKind() { result = TNormalReturnKind() }

  string encodeParameterPosition(ParameterPosition pos) { result = pos.toString() }

  predicate encodeArgumentPosition = encodeParameterPosition/1;

  string encodeContent(ContentSet cs, string arg) {
    exists(Content c | cs = TSingletonContentSet(c) |
      exists(VariantCanonicalPath v | result = "Variant" |
        exists(int pos |
          c = TVariantPositionContent(v, pos) and
          arg = v.getExtendedCanonicalPath() + "(" + pos + ")"
        )
        or
        exists(string field |
          c = TVariantFieldContent(v, field) and
          arg = v.getExtendedCanonicalPath() + "::" + field
        )
      )
      or
      exists(StructCanonicalPath s, string field |
        result = "Struct" and
        c = TStructFieldContent(s, field) and
        arg = s.getExtendedCanonicalPath() + "::" + field
      )
      or
      result = "ArrayElement" and
      c = TArrayElement() and
      arg = ""
      or
      exists(int pos |
        result = "Tuple" and
        c = TTuplePositionContent(pos) and
        arg = pos.toString()
      )
    )
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
}

module Private {
  import Impl::Private

  module Steps = Impl::Private::Steps<StepsInput>;
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
