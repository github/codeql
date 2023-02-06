/** Provides sink models and classes related to pausing thread operations. */

import java
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
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
