import csharp
import TestUtilities.InlineMadTest
import utils.modelgenerator.internal.CaptureTypeBasedSummaryModels

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = captureFlow(c) }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
