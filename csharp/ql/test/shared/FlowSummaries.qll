import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Public
private import semmle.code.csharp.dataflow.internal.ExternalFlow

final private class SummarizedCallableImplFinal = SummarizedCallableImpl;

class IncludeSummarizedCallable extends SummarizedCallableImplFinal {
  IncludeSummarizedCallable() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic()
  }

  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final string getCallableCsv() { result = getSignature(this) }

  predicate relevantSummary(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    this.propagatesFlow(input, output, preservesValue, _)
  }
}
