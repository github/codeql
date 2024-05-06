import java
import utils.modelgenerator.internal.CaptureSummaryFlowQuery
import TestUtilities.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel() { result = captureNoFlow(_) }

  string getKind() { result = "neutral" }
}

import InlineMadTest<InlineMadTestConfig>
