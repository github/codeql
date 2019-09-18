/**
 * @name Resource injection
 * @description Building a resource descriptor from untrusted user input is vulnerable to a
 *              malicious user providing an unintended resource.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/resource-injection
 * @tags security
 *       external/cwe/cwe-099
 */

import csharp
import semmle.code.csharp.security.dataflow.ResourceInjection::ResourceInjection
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in a resource descriptor.",
  source.getNode(), "User-provided value"
