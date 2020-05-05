/**
 * @name Information exposure through an exception
 * @description Leaking information about an exception, such as messages and stack traces, to an
 *              external user can expose implementation details that are useful to an attacker for
 *              developing a subsequent exploit.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/information-exposure-through-exception
 * @tags security
 *       external/cwe/cwe-209
 *       external/cwe/cwe-497
 */

import csharp
import semmle.code.csharp.frameworks.System
import semmle.code.csharp.security.dataflow.flowsinks.Remote
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

/**
 * A taint-tracking configuration for reasoning about stack traces that flow to web page outputs.
 */
class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "StackTrace" }

  override predicate isSource(DataFlow::Node source) {
    exists(Expr exceptionExpr |
      // Writing an exception directly is bad
      source.asExpr() = exceptionExpr
      or
      // Writing an exception property is bad
      source.asExpr().(PropertyAccess).getQualifier() = exceptionExpr
      or
      // Writing the result of ToString is bad
      source.asExpr() =
        any(MethodCall mc | mc.getQualifier() = exceptionExpr and mc.getTarget().hasName("ToString"))
    |
      // Expr has type `System.Exception`.
      exceptionExpr.getType().(RefType).getABaseType*() instanceof SystemExceptionClass and
      // And is not within an exception callable.
      not exists(Callable enclosingCallable |
        enclosingCallable = exceptionExpr.getEnclosingCallable()
      |
        enclosingCallable.getDeclaringType().getABaseType*() instanceof SystemExceptionClass
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RemoteFlowSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    // Do not flow through Message
    sanitizer.asExpr() = any(SystemExceptionClass se).getProperty("Message").getAnAccess()
  }
}

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Exception information from $@ flows to here, and is exposed to the user.", source.getNode(),
  source.toString()
