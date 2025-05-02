import cpp
import utils.modelgenerator.internal.CaptureModels
import SummaryModels
import InlineModelsAsDataTest

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getCapturedModel(MadRelevantFunction c) { result = Heuristic::captureHeuristicFlow(c, _) }

  string getKind() { result = "heuristic-summary" }
}

import InlineMadTest<InlineMadTestConfig>
