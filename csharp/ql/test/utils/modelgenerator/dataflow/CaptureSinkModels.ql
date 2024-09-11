import csharp
import utils.modelgenerator.internal.CaptureModels
import TestUtilities.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = captureSink(c) }

  string getKind() { result = "sink" }
}

import InlineMadTest<InlineMadTestConfig>
