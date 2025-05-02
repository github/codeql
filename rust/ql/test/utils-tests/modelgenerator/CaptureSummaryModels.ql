import rust
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Function f) { result = ContentSensitive::captureFlow(f, _, _) }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
