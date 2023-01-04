/**
 * @name Assembly path injection
 * @description Loading a .NET assembly based on a path constructed from user-controlled sources
 *              may allow a malicious user to load code which modifies the program in unintended
 *              ways.
 * @kind path-problem
 * @id cs/assembly-path-injection
 * @problem.severity error
 * @security-severity 8.2
 * @precision high
 * @tags security
 *       external/cwe/cwe-114
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.commons.Util
import DataFlow::PathGraph

/**
 * A taint-tracking configuration for untrusted user input used to load a DLL.
 */
class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "DLLInjection" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource or
    source.asExpr() = any(MainMethod main).getParameter(0).getAnAccess()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc, string name, int arg |
      mc.getTarget().getName().matches(name) and
      mc.getTarget()
          .getDeclaringType()
          .getABaseType*()
          .hasQualifiedName("System.Reflection", "Assembly") and
      mc.getArgument(arg) = sink.asExpr()
    |
      name = "LoadFrom" and arg = 0 and mc.getNumberOfArguments() = [1 .. 2]
      or
      name = "LoadFile" and arg = 0
      or
      name = "LoadWithPartialName" and arg = 0
      or
      name = "UnsafeLoadFrom" and arg = 0
    )
  }
}

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This assembly path depends on a $@.", source,
  "user-provided value"
