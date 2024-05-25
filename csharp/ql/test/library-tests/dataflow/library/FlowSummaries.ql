import shared.FlowSummaries
import semmle.code.csharp.dataflow.internal.ExternalFlow

final private class NeutralCallableFinal = NeutralCallable;

class RelevantNeutralCallable extends NeutralCallableFinal {
  final string getCallableCsv() { result = getSignature(this) }
}

class RelevantSourceCallable extends SourceCallable {
  string getCallableCsv() { result = getSignature(this) }
}

class RelevantSinkCallable extends SinkCallable {
  string getCallableCsv() { result = getSignature(this) }
}

import TestSummaryOutput<IncludeSummarizedCallable>
import TestNeutralOutput<RelevantNeutralCallable>
import External::TestSourceSinkOutput<RelevantSourceCallable, RelevantSinkCallable>
