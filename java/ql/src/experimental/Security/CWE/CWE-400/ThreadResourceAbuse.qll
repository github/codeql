/** Provides sink models and classes related to pausing thread operations. */
deprecated module;

import java
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.arithmetic.Overflow
import semmle.code.java.dataflow.FlowSteps
import semmle.code.java.controlflow.Guards

private class ActivateModels extends ActiveExperimentalModels {
  ActivateModels() { this = "thread-resource-abuse" }
}

/** A sink representing methods pausing a thread. */
class PauseThreadSink extends DataFlow::Node {
  PauseThreadSink() { sinkNode(this, "thread-pause") }
}

private predicate lessThanGuard(Guard g, Expr e, boolean branch) {
  e = g.(ComparisonExpr).getLesserOperand() and
  branch = true
  or
  e = g.(ComparisonExpr).getGreaterOperand() and
  branch = false
}

/** A sanitizer for lessThan check. */
class LessThanSanitizer extends DataFlow::Node {
  LessThanSanitizer() { this = DataFlow::BarrierGuard<lessThanGuard/3>::getABarrierNode() }
}

/** Value step from the constructor call of a `Runnable` to the instance parameter (this) of `run`. */
private class RunnableStartToRunStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(ConstructorCall cc, Method m |
      m.getDeclaringType() = cc.getConstructedType().getSourceDeclaration() and
      cc.getConstructedType().getAnAncestor().hasQualifiedName("java.lang", "Runnable") and
      m.hasName("run")
    |
      pred.asExpr() = cc and
      succ.(DataFlow::InstanceParameterNode).getEnclosingCallable() = m
    )
  }
}

/**
 * Value step from the constructor call of a `ProgressListener` of Apache File Upload to the
 * instance parameter (this) of `update`.
 */
private class ApacheFileUploadProgressUpdateStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(ConstructorCall cc, Method m |
      m.getDeclaringType() = cc.getConstructedType().getSourceDeclaration() and
      cc.getConstructedType()
          .getAnAncestor()
          .hasQualifiedName(["org.apache.commons.fileupload", "org.apache.commons.fileupload2"],
            "ProgressListener") and
      m.hasName("update")
    |
      pred.asExpr() = cc and
      succ.(DataFlow::InstanceParameterNode).getEnclosingCallable() = m
    )
  }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `ThreadResourceAbuseConfig`.
 */
class ThreadResourceAbuseAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `ThreadResourceAbuseConfig` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** A set of additional taint steps to consider when taint tracking thread resource abuse related data flows. */
private class DefaultThreadResourceAbuseAdditionalTaintStep extends ThreadResourceAbuseAdditionalTaintStep
{
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    threadResourceAbuseArithmeticTaintStep(node1, node2)
  }
}

/**
 * Holds if the step `node1` -> `node2` is an additional taint-step that performs an addition, multiplication,
 * subtraction, or division.
 */
private predicate threadResourceAbuseArithmeticTaintStep(
  DataFlow::Node fromNode, DataFlow::Node toNode
) {
  toNode.asExpr().(ArithExpr).getAnOperand() = fromNode.asExpr()
}
