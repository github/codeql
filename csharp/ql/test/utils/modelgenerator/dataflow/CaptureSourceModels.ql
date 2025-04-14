import csharp
import utils.modelgenerator.internal.CaptureModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = captureSource(c) }

  string getKind() { result = "source" }
}

import InlineMadTest<InlineMadTestConfig>
