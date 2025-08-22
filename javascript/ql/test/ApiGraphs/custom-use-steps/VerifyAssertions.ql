import ApiGraphs.VerifyAssertions
private import semmle.javascript.dataflow.internal.PreCallGraphStep

class CustomUseStep extends PreCallGraphStep {
  override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    exists(DataFlow::CallNode call |
      call.getCalleeName() = "customLoad" and
      pred = call.getArgument(0) and
      succ = call and
      prop = call.getArgument(1).getStringValue()
    )
  }
}
