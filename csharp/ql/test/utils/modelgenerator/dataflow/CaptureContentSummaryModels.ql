import csharp
import utils.modelgenerator.internal.CaptureModels
import TestUtilities.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Callable c) { result = ContentSensitive::captureFlow(c, _) }

  string getKind() { result = "contentbased-summary" }
}

import InlineMadTest<InlineMadTestConfig>
