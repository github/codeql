import shared.FlowSummaries
import semmle.code.csharp.dataflow.internal.ExternalFlow
import External

module TestSummaryInput implements TestSummaryInputSig {
  class RelevantSummarizedCallable = IncludeSummarizedCallable;
}

module TestNeutralInput implements TestNeutralInputSig {
  class RelevantNeutralCallable instanceof NeutralCallable {
    final string getCallableCsv() { result = asPartialNeutralModel(this) }

    string toString() { result = super.toString() }
  }
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

import TestSummaryOutput<TestSummaryInput>
import TestNeutralOutput<TestNeutralInput>
import TestSourceSinkOutput<TestSourceSinkInput>
