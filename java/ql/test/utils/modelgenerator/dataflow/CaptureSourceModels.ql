import java
import utils.modelgenerator.internal.CaptureModels
import SourceModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = Heuristic::captureSource(c) }

  string getKind() { result = "source" }
}

import InlineMadTest<InlineMadTestConfig>
