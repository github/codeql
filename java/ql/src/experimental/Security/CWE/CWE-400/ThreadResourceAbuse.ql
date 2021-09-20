/**
 * @name Uncontrolled thread resource consumption
 * @description Use user input directly to control thread sleep time could lead to performance problems
 *              or even resource exhaustion.
 * @kind path-problem
 * @id java/thread-resource-abuse
 * @tags security
 *       external/cwe/cwe-400
 */

import java
import ThreadPauseSink
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** The `getInitParameter` method of servlet or JSF. */
class GetInitParameter extends Method {
  GetInitParameter() {
    (
      this.getDeclaringType()
          .getASupertype*()
          .hasQualifiedName(["javax.servlet", "jakarta.servlet"],
            ["FilterConfig", "Registration", "ServletConfig", "ServletContext"]) or
      this.getDeclaringType()
          .getASupertype*()
          .hasQualifiedName(["javax.faces.context", "jakarta.faces.context"], "ExternalContext")
    ) and
    this.getName() = "getInitParameter"
  }
}

/** An access to the `getInitParameter` method. */
class GetInitParameterAccess extends MethodAccess {
  GetInitParameterAccess() { this.getMethod() instanceof GetInitParameter }
}

/* Init parameter input of a Java EE web application. */
class InitParameterInput extends LocalUserInput {
  InitParameterInput() { this.asExpr() instanceof GetInitParameterAccess }
}

private class LessThanSanitizer extends DataFlow::BarrierGuard {
  LessThanSanitizer() { this instanceof LTExpr }

  override predicate checks(Expr e, boolean branch) {
    e = this.(LTExpr).getLeftOperand() and
    branch = true
  }
}

/** Taint configuration of uncontrolled thread resource consumption. */
class ThreadResourceAbuse extends TaintTracking::Configuration {
  ThreadResourceAbuse() { this = "ThreadResourceAbuse" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource or source instanceof LocalUserInput
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PauseThreadSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ConditionalExpr ce | ce.getAChildExpr() = node1.asExpr() and ce = node2.asExpr()) // request.getParameter("nodelay") != null ? 0 : sleepTime
    or
    exists(
      Method rm, ClassInstanceExpr ce, Argument arg, FieldAccess fa // thread.start() invokes the run() method of thread implementation
    |
      rm.hasName("run") and
      ce.getConstructedType() = rm.getSourceDeclaration().getDeclaringType() and
      ce.getConstructedType().getASupertype*().hasQualifiedName("java.lang", "Runnable") and
      ce.getAnArgument() = arg and
      fa = rm.getAnAccessedField().getAnAccess() and
      arg.getType() = fa.getField().getType() and
      node1.asExpr() = arg and
      node2.asExpr() = fa
    )
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof LessThanSanitizer // if (sleepTime > 0 && sleepTime < 5000) { ... }
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ThreadResourceAbuse conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Vulnerability of uncontrolled resource consumption due to $@.", source.getNode(),
  "user-provided value"
