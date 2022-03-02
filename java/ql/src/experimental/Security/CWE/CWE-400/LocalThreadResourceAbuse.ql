/**
 * @name Uncontrolled thread resource consumption from local input source
 * @description Using user input directly to control a thread's sleep time could lead to
 *              performance problems or even resource exhaustion.
 * @kind path-problem
 * @id java/thread-resource-abuse
 * @problem.severity recommendation
 * @tags security
 *       external/cwe/cwe-400
 */

import java
import ThreadResourceAbuse
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** The `getInitParameter` method of servlet or JSF. */
class GetInitParameter extends Method {
  GetInitParameter() {
    (
      this.getDeclaringType()
          .getAnAncestor()
          .hasQualifiedName(["javax.servlet", "jakarta.servlet"],
            ["FilterConfig", "Registration", "ServletConfig", "ServletContext"]) or
      this.getDeclaringType()
          .getAnAncestor()
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

/** Taint configuration of uncontrolled thread resource consumption from local user input. */
class ThreadResourceAbuse extends TaintTracking::Configuration {
  ThreadResourceAbuse() { this = "ThreadResourceAbuse" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PauseThreadSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(AdditionalValueStep r).step(pred, succ)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(
      MethodAccess ma // Math.min(sleepTime, MAX_INTERVAL)
    |
      ma.getMethod().hasQualifiedName("java.lang", "Math", "min") and
      node.asExpr() = ma.getAnArgument()
    )
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof LessThanSanitizer // if (sleepTime > 0 && sleepTime < 5000) { ... }
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ThreadResourceAbuse conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Possible uncontrolled resource consumption due to $@.",
  source.getNode(), "local user-provided value"
