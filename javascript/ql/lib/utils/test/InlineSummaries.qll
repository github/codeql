import javascript
import semmle.javascript.dataflow.FlowSummary

class MkSummary extends SummarizedCallable {
  private CallExpr mkSummary;

  MkSummary() {
    mkSummary.getCalleeName() = "mkSummary" and
    this =
      "mkSummary at " + mkSummary.getFile().getRelativePath() + ":" +
        mkSummary.getLocation().getStartLine()
  }

  override DataFlow::InvokeNode getACallSimple() {
    result = mkSummary.flow().(DataFlow::CallNode).getAnInvocation()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      // mkSummary(input, output)
      input = mkSummary.getArgument(0).getStringValue() and
      output = mkSummary.getArgument(1).getStringValue()
      or
      // mkSummary([
      //   [input1, output1],
      //   [input2, output2],
      //   ...
      // ])
      exists(ArrayExpr pair |
        pair = mkSummary.getArgument(0).(ArrayExpr).getAnElement() and
        input = pair.getElement(0).getStringValue() and
        output = pair.getElement(1).getStringValue()
      )
    )
  }
}
