import rust
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Function f) { result = captureSink(f) }

  string getKind() { result = "sink" }
}

import InlineMadTest<InlineMadTestConfig>
