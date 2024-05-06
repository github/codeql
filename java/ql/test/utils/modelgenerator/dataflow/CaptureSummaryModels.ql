import java
import utils.modelgenerator.internal.CaptureSummaryFlowQuery
import TestUtilities.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel() { result = captureFlow(_) }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
