private import unified
private import AllDataFlow
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.util.Void
private import codeql.unified.internal.mad.LegacyMaD as LegacyMaD
private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax

module FlowSummaryInput implements InputSig<Location, DataFlowInput> {
  class SummarizedCallableBase extends LegacyMaD::Selector {
    SummarizedCallableBase() { LegacyMaD::normalizedSummaryModel(this, _, _, _, _) }

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
  import FlowSummaryOutput1::Public
  import FlowSummaryOutput2
  import StepsOutput
}

class SummaryNode = FlowSummaryOutput::SummaryNode;

class SummarizedCallable = FlowSummaryOutput::SummarizedCallable;

private class SummarizedCallableFromModel extends SummarizedCallable {
  SummarizedCallableFromModel() { LegacyMaD::normalizedSummaryModel(this, _, _, _, _) }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance p, boolean isExact, string model
  ) {
    isExact = true and
    model = "" and // TODO
    exists(string kind |
      LegacyMaD::normalizedSummaryModel(this, input, output, kind, p) and
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
