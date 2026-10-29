private import unified
private import AllDataFlow
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.util.Void
private import codeql.unified.internal.mad.DynamicMaD as DynamicMaD
private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax

private newtype TSummaryKey =
  MkSummaryKey(string type, string path) { DynamicMaD::flowSummaryModel(type, path, _, _, _, _) }

/**
 * A `(type, path)` pair identifying a library function that has a flow summary.
 */
class SummaryKey extends TSummaryKey {
  /** Gets the type from which the access path of this summary starts. */
  string getType() { this = MkSummaryKey(result, _) }

  /** Gets the access path leading to the summarized function. */
  string getPath() { this = MkSummaryKey(_, result) }

  /** Holds if `call` is a call to the function identified by this summary key. */
  predicate matchesCall(CallExpr call) {
    DynamicMaD::isCallToPath(this.getType(), this.getPath(), call)
  }

  /** Gets a string representation of this summary key. */
  string toString() { result = this.getType() + ";" + this.getPath() }
}

module FlowSummaryInput implements InputSig<Location, DataFlowInput> {
  class SummarizedCallableBase extends SummaryKey {
    Location getLocation() { none() }
  }

  predicate callableFromSource(SummarizedCallableBase c) { none() }

  predicate neutralElement(SummarizedCallableBase c, string kind, string provenance, boolean isExact) {
    none()
  }

  class FlowSummaryCallBase extends Void {
    Location getLocation() { none() }
  }

  FlowSummaryCallBase getASourceCall(SummarizedCallableBase sc) { none() }

  DataFlowCallable getSummarizedCallableAsDataFlowCallable(SummarizedCallableBase c) {
    result.asSummarizedCallable() = c
  }

  ArgumentPosition callbackSelfParameterPosition() { result.isCallee() }

  DataFlowInput::ReturnKind getStandardReturnValueKind() { result.isStandardReturnValue() }

  string encodeParameterPosition(ParameterPosition pos) { result = pos.asModelOperand() }

  string encodeArgumentPosition(ArgumentPosition pos) { result = pos.asModelOperand() }

  string encodeContent(ContentSet c, string arg) {
    result = "ArrayElement" and
    c.asSingleton().isArrayElement() and
    arg = ""
    or
    result = "Member" and
    arg = c.asSingleton().asNamedMember()
  }

  string encodeReturn(DataFlowInput::ReturnKind rk, string arg) {
    result = "ReturnValue" and
    rk.isStandardReturnValue() and
    arg = ""
  }

  string encodeWithoutContent(ContentSet c, string arg) {
    result = "Without" + encodeContent(c, arg)
  }

  string encodeWithContent(ContentSet c, string arg) { result = "With" + encodeContent(c, arg) }

  bindingset[token]
  ContentSet decodeUnknownContent(AccessPathSyntax::AccessPathTokenBase token) {
    // Adapters for the old Swift MaD models
    token = "OptionalSome" and result = ContentSet::namedMember("some.0")
    or
    token = "CollectionElement" and result = ContentSet::arrayElement()
    or
    token.getName() = "TupleElement" and
    result = ContentSet::namedMember(AccessPathSyntax::parseInt(token.getAnArgument()).toString())
  }

  bindingset[token]
  ContentSet decodeUnknownWithoutContent(AccessPathSyntax::AccessPathTokenBase token) {
    token = "WithoutOptionalSome" and result = ContentSet::namedMember("some.0")
    or
    token = "WithoutCollectionElement" and result = ContentSet::arrayElement()
  }

  bindingset[token]
  ContentSet decodeUnknownWithContent(AccessPathSyntax::AccessPathTokenBase token) {
    token = "WithOptionalSome" and result = ContentSet::namedMember("some.0")
    or
    token = "WithCollectionElement" and result = ContentSet::arrayElement()
  }
}

private module FlowSummaryOutput1 = Make<Location, DataFlowInput, FlowSummaryInput>;

private import FlowSummaryOutput1::Private
private import FlowSummaryOutput1::Public

private module FlowSummaryInput2 implements InputSig2 {
  class SourceSinkReportingElement extends Void {
    Location getLocation() { none() }

    DataFlowCallable getEnclosingCallable() { none() }

    SourceSinkReportingElement getASuccessor(SummaryComponent sc) { none() }
  }
}

private module FlowSummaryOutput2 = Make2<FlowSummaryInput2>;

private import FlowSummaryOutput2

Node getNodeFromSummaryNode(SummaryNode node) { result = TSummaryNode(node) }

SummaryNode getSummaryNode(Node n) { n = TSummaryNode(result) }

private predicate getSummaryNodeAlias = getSummaryNode/1;

private module StepsInput implements StepsInputSig {
  predicate getSummaryNode = getSummaryNodeAlias/1;

  DataFlowCall getACall(SummarizedCallable sc) { sc.matchesCall(result.asExplicitCall()) }
}

private import StepsInput

private module StepsOutput = Steps<StepsInput>;

module FlowSummaryOutput {
  module Private = FlowSummaryOutput1::Private;

  import FlowSummaryOutput1::Public
  import FlowSummaryOutput2
  import StepsOutput

  module RenderSummarizedCallable = FlowSummaryOutput2::RenderSummarizedCallable<StepsInput>;
}

class SummaryNode = FlowSummaryOutput::SummaryNode;

class SummarizedCallable = FlowSummaryOutput::SummarizedCallable;

private class SummarizedCallableFromModel extends SummarizedCallable {
  SummarizedCallableFromModel() { exists(this.getType()) }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance p, boolean isExact, string model
  ) {
    isExact = true and
    p = "manual" and
    model = "" and // TODO
    exists(string kind |
      DynamicMaD::flowSummaryModel(this.getType(), this.getPath(), input, output, kind, _) and
      (
        kind = "value" and
        preservesValue = true
        or
        kind = "taint" and
        preservesValue = false
      )
    )
  }
}
