import rust
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest
import codeql.rust.dataflow.internal.ModelsAsData

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Function c) { result = captureSource(c) }

  string getKind() { result = "source" }
}

import InlineMadTest<InlineMadTestConfig>
