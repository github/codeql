import cpp
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(MadRelevantFunction c) { result = captureFlow(c) }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
