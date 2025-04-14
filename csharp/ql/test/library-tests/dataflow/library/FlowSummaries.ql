import shared.FlowSummaries
import semmle.code.csharp.dataflow.internal.ExternalFlow

module R implements RelevantNeutralCallableSig<NeutralSummaryCallable> {
  class RelevantNeutralCallable extends NeutralSummaryCallable {
    final string getCallableCsv() { result = getSignature(this) }
  }
}

class RelevantSourceCallable extends SourceCallable {
  string getCallableCsv() { result = getSignature(this) }
}

class RelevantSinkCallable extends SinkCallable {
  string getCallableCsv() { result = getSignature(this) }
}

import TestSummaryOutput<IncludeSummarizedCallable>
import TestNeutralOutput<NeutralSummaryCallable, R>
import External::TestSourceSinkOutput<RelevantSourceCallable, RelevantSinkCallable>
