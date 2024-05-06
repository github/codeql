import java
import TestUtilities.InlineMadTest
import utils.modelgenerator.internal.CaptureTypeBasedSummaryModels

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getComment() { result = any(Javadoc doc).getChild(0).toString() }

  string getCapturedSummary() { result = captureFlow(_) }
}

import InlineMadTest<InlineMadTestConfig>
