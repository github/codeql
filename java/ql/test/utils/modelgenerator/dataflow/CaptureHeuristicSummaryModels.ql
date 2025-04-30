import java
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = Heuristic::captureFlow(c) }

  string getKind() { result = "heuristic-summary" }
}

import InlineMadTest<InlineMadTestConfig>
