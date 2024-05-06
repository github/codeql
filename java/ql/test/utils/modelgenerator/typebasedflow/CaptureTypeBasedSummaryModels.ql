import java
import TestUtilities.InlineMadTest
import utils.modelgenerator.internal.CaptureTypeBasedSummaryModels

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel() { result = captureFlow(_) }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
