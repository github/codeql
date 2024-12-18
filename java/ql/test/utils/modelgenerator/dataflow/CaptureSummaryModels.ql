import java
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = captureFlow(c) }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
