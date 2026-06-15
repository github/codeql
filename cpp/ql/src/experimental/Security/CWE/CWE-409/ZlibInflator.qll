/**
 * https://www.zlib.net/
 */

import cpp
import DecompressionBomb

/**
 * The `inflate` and `inflateSync` functions are used in flow sink.
 *
 * `inflate(z_stream strm, int flush)`
 *
 * `inflateSync(z_stream strm)`
 */
class InflateFunction extends DecompressionFunction {
  InflateFunction() { this.hasGlobalName(["inflate", "inflateSync"]) }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `next_in` member of a `z_stream` variable is used in a flow steps.
 */
class NextInMemberStep extends DecompressionFlowStep {
  NextInMemberStep() { this = "NextInMemberStep" }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Variable nextInVar |
      nextInVar.getDeclaringType().hasName("z_stream") and
      nextInVar.hasName("next_in")
    |
      node1.asIndirectExpr() = nextInVar.getAnAssignedValue() and
      node2.asExpr() =
        nextInVar.getAnAccess().getQualifier().(VariableAccess).getTarget().getAnAccess()
    )
  }
}
