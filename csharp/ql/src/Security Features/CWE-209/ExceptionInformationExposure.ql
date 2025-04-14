/**
 * @name Information exposure through an exception
 * @description Leaking information about an exception, such as messages and stack traces, to an
 *              external user can expose implementation details that are useful to an attacker for
 *              developing a subsequent exploit.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.4
 * @precision high
 * @id cs/information-exposure-through-exception
 * @tags security
 *       external/cwe/cwe-209
 *       external/cwe/cwe-497
 */

import csharp
import semmle.code.csharp.frameworks.System
import semmle.code.csharp.security.dataflow.flowsinks.Remote
import ExceptionInformationExposure::PathGraph

/**
 * A taint-tracking configuration for reasoning about stack traces that flow to web page outputs.
 */
module ExceptionInformationExposureConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Expr expr |
      // Writing an exception directly is bad
      source.asExpr() = expr
      or
      // Writing a property of an exception is bad
      source.asExpr().(PropertyAccess).getQualifier() = expr
    |
      // Expr has type `System.Exception`.
      expr.getType().(RefType).getABaseType*() instanceof SystemExceptionClass and
      // And is not within an exception callable.
      not exists(Callable enclosingCallable | enclosingCallable = expr.getEnclosingCallable() |
        enclosingCallable.getDeclaringType().getABaseType*() instanceof SystemExceptionClass
      )
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node source, DataFlow::Node sink) {
    sink.asExpr() =
      any(MethodCall mc |
        source.asExpr() = mc.getQualifier() and
        mc.getTarget().hasName("ToString") and
        mc.getQualifier().getType().(RefType).getABaseType*() instanceof SystemExceptionClass
      )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof RemoteFlowSink }

  predicate isBarrier(DataFlow::Node sanitizer) {
    // Do not flow through Message
    sanitizer.asExpr() = any(SystemExceptionClass se).getProperty("Message").getAnAccess()
  }

  predicate isBarrierIn(DataFlow::Node sanitizer) {
    // Do not flow through Message
    sanitizer.asExpr().getType().(RefType).getABaseType*() instanceof SystemExceptionClass
  }
}

/**
 * A taint-tracking module for reasoning about stack traces that flow to web page outputs.
 */
module ExceptionInformationExposure = TaintTracking::Global<ExceptionInformationExposureConfig>;

from ExceptionInformationExposure::PathNode source, ExceptionInformationExposure::PathNode sink
where ExceptionInformationExposure::flowPath(source, sink)
select sink.getNode(), source, sink, "This information exposed to the user depends on $@.",
  source.getNode(), "exception information"
