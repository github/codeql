import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Public
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private::TestOutput
private import semmle.code.csharp.dataflow.internal.ExternalFlow

abstract class IncludeSummarizedCallable extends RelevantSummarizedCallable {
  IncludeSummarizedCallable() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic()
  }

  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final override string getCallableCsv() { result = asPartialModel(this) }
}
