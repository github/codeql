import rust
import utils.modelgenerator.internal.CaptureModels
import SinkModels
import utils.test.InlineMadTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(Function f) {
    exists(QualifiedCallable qc | f = qc.asFunction() | result = Heuristic::captureSink(qc))
  }

  string getKind() { result = "sink" }
}

import InlineMadTest<InlineMadTestConfig>
