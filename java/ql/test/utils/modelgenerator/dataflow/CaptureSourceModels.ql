import java
import utils.modelgenerator.internal.CaptureModels
import TestUtilities.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel() { result = captureSource(_) }

  string getKind() { result = "source" }
}

import InlineMadTest<InlineMadTestConfig>
