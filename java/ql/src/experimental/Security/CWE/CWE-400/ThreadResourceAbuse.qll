/** Provides sink models and classes related to pausing thread operations. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

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
    e = this.(ComparisonExpr).getLesserOperand() and
    branch = true
    or
    e = this.(ComparisonExpr).getGreaterOperand() and
    branch = false
  }
}

/**
 * A unit class for adding additional taint steps that are specific to thread resource abuse.
 */
class ThreadResourceAbuseAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `pred` to `succ` should be considered a taint
   * step for thread resource abuse.
   */
  abstract predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ);
}

private class RunnableAdditionalTaintStep extends ThreadResourceAbuseAdditionalTaintStep {
  override predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      Method rm, ClassInstanceExpr ce, Argument arg, Parameter p, FieldAccess fa, int i // thread.start() invokes the run() method of thread implementation
    |
      rm.hasName("run") and
      ce.getConstructedType().getSourceDeclaration() = rm.getSourceDeclaration().getDeclaringType() and
      ce.getConstructedType().getASupertype*().hasQualifiedName("java.lang", "Runnable") and
      ce.getArgument(i) = arg and
      ce.getConstructor().getParameter(i) = p and
      fa.getEnclosingCallable() = rm and
      DataFlow::localExprFlow(p.getAnAccess(), fa.getField().getAnAssignedValue()) and
      pred.asExpr() = arg and
      succ.asExpr() = fa
    )
  }
}

private class ApacheFileUploadAdditionalTaintStep extends ThreadResourceAbuseAdditionalTaintStep {
  override predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Method um, VarAccess va, FieldAccess fa, Constructor ce, AssignExpr ar |
      um.getDeclaringType()
          .getASupertype*()
          .hasQualifiedName("org.apache.commons.fileupload", "ProgressListener") and
      um.hasName("update") and
      fa.getEnclosingCallable() = um and
      ce.getDeclaringType() = um.getDeclaringType() and
      va = ce.getAParameter().getAnAccess() and
      pred.asExpr() = va and
      succ.asExpr() = fa and
      ar.getSource() = va and
      ar.getDest() = fa.getField().getAnAccess()
    )
  }
}
