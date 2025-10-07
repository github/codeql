/**
 * @name Uncontrolled thread resource consumption from local input source
 * @description Using user input directly to control a thread's sleep time could lead to
 *              performance problems or even resource exhaustion.
 * @kind path-problem
 * @id java/local-thread-resource-abuse
 * @problem.severity recommendation
 * @tags security
 *       external/cwe/cwe-400
 */

import java
deprecated import ThreadResourceAbuse
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
deprecated import ThreadResourceAbuseFlow::PathGraph

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
class GetInitParameterAccess extends MethodCall {
  GetInitParameterAccess() { this.getMethod() instanceof GetInitParameter }
}

/* Init parameter input of a Java EE web application. */
class InitParameterInput extends LocalUserInput {
  InitParameterInput() { this.asExpr() instanceof GetInitParameterAccess }
}

/** Taint configuration of uncontrolled thread resource consumption from local user input. */
deprecated module ThreadResourceAbuseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof PauseThreadSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(AdditionalValueStep r).step(pred, succ)
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(
      MethodCall ma // Math.min(sleepTime, MAX_INTERVAL)
    |
      ma.getMethod().hasQualifiedName("java.lang", "Math", "min") and
      node.asExpr() = ma.getAnArgument()
    )
    or
    node instanceof LessThanSanitizer // if (sleepTime > 0 && sleepTime < 5000) { ... }
  }
}

deprecated module ThreadResourceAbuseFlow = TaintTracking::Global<ThreadResourceAbuseConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, ThreadResourceAbuseFlow::PathNode source,
  ThreadResourceAbuseFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2
) {
  ThreadResourceAbuseFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Possible uncontrolled resource consumption due to $@." and
  sourceNode = source.getNode() and
  message2 = "local user-provided value"
}
