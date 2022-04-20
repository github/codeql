/** Provides sink models and classes related to pausing thread operations. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.FlowSteps

/** `java.lang.Math` data model for value comparison in the new CSV format. */
private class MathCompDataModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.lang;Math;false;min;;;Argument[0..1];ReturnValue;value",
        "java.lang;Math;false;max;;;Argument[0..1];ReturnValue;value"
      ]
  }
}

/** Thread pause data model in the new CSV format. */
private class PauseThreadDataModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.lang;Thread;true;sleep;;;Argument[0];thread-pause",
        "java.util.concurrent;TimeUnit;true;sleep;;;Argument[0];thread-pause"
      ]
  }
}

/** A sink representing methods pausing a thread. */
class PauseThreadSink extends DataFlow::Node {
  PauseThreadSink() { sinkNode(this, "thread-pause") }
}

/** A sanitizer for lessThan check. */
class LessThanSanitizer extends DataFlow::BarrierGuard instanceof ComparisonExpr {
  override predicate checks(Expr e, boolean branch) {
    e = super.getLesserOperand() and
    branch = true
    or
    e = super.getGreaterOperand() and
    branch = false
  }
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
