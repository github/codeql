import cpp
import utils.modelgenerator.internal.CaptureModels
import InlineModelsAsDataTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(MadRelevantFunction c) { result = Heuristic::captureFlow(c) }

  string getKind() { result = "heuristic-summary" }
}

import InlineMadTest<InlineMadTestConfig>
