import rust
import utils.modelgenerator.internal.CaptureModels
import SummaryModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Function f) {
    exists(QualifiedCallable qc | f = qc.getFunction() |
      result = ContentSensitive::captureFlow(qc, _, _, _, _)
    )
  }

  string getKind() { result = "summary" }
}

import InlineMadTest<InlineMadTestConfig>
