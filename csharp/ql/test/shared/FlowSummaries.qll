import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Public
private import semmle.code.csharp.dataflow.internal.ExternalFlow

class IncludeSummarizedCallable instanceof SummarizedCallableImpl {
  IncludeSummarizedCallable() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic()
  }

  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final string getCallableCsv() { result = asPartialModel(this) }

  string toString() { result = super.toString() }
}
