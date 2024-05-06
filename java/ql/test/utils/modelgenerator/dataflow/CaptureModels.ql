import java
import utils.modelgenerator.internal.CaptureSummaryFlowQuery
import TestUtilities.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getComment() { result = any(Javadoc doc).getChild(0).toString() }

  string getCapturedSummary() { result = captureFlow(_) }
}

import InlineMadTest<InlineMadTestConfig>
