import cpp
import utils.modelgenerator.internal.CaptureModels
import InlineModelsAsDataTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(MadRelevantFunction c) { result = captureFlow(c) }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
