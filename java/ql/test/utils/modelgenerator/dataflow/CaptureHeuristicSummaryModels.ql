import java
import utils.modelgenerator.internal.CaptureModels
import SummaryModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = Heuristic::captureFlow(c, _) }

  string getKind() { result = "heuristic-summary" }
}

import InlineMadTest<InlineMadTestConfig>
