import cpp
import utils.modelgenerator.internal.CaptureModels
import InlineModelsAsDataTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(MadRelevantFunction c) { result = ContentSensitive::captureFlow(c, _) }

  string getKind() { result = "contentbased-summary" }
}

import InlineMadTest<InlineMadTestConfig>
