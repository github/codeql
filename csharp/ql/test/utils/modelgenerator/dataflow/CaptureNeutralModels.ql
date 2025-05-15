import csharp
import utils.modelgenerator.internal.CaptureModels
import SummaryModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = captureNeutral(c) }

  string getKind() { result = "neutral" }
}

import InlineMadTest<InlineMadTestConfig>
