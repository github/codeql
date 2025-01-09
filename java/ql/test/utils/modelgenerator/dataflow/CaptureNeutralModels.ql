import java
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = captureNoFlow(c) }

  string getKind() { result = "neutral" }
}

import InlineMadTest<InlineMadTestConfig>
