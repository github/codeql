/**
 * @name Exposure of private information
 * @description If private information is written to an external location, it may be accessible by
 *              unauthorized persons.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.5
 * @precision high
 * @id cs/exposure-of-sensitive-information
 * @tags security
 *       external/cwe/cwe-359
 */

import csharp
import semmle.code.csharp.security.dataflow.ExposureOfPrivateInformationQuery
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Private data returned by $@ is written to an external location.", source.getNode(),
  source.getNode().toString()
