import shared.FlowSummaries
import semmle.code.csharp.dataflow.internal.ExternalFlow
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private::External

private class IncludeAllSummarizedCallable extends IncludeSummarizedCallable {
  IncludeAllSummarizedCallable() { exists(this) }
}

private class IncludeNeutralSummarizedCallable extends RelevantNeutralCallable {
  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final override string getCallableCsv() { result = asPartialNeutralModel(this) }
}

module TestSourceSinkInput implements TestSourceSinkInputSig {
  class RelevantSourceCallable instanceof SourceCallable {
    string getCallableCsv() { result = asPartialModel(this) }

    string toString() { result = super.toString() }
  }

  class RelevantSinkCallable instanceof SinkCallable {
    string getCallableCsv() { result = asPartialModel(this) }

    string toString() { result = super.toString() }
  }
}

import TestSourceSinkOutput<TestSourceSinkInput>
