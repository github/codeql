import rust
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Function c) { result = captureMixedFlow(c, _) }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
