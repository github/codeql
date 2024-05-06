import java
import utils.modelgenerator.internal.CaptureModels
import TestUtilities.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel() { result = captureSink(_) }

  string getKind() { result = "sink" }
}

import InlineMadTest<InlineMadTestConfig>
