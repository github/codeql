/**
 * @name Deserialization of untrusted data
 * @description Calling an unsafe deserializer with data controlled by an attacker
 *              can lead to denial of service and other security problems.
 * @kind path-problem
 * @id cs/unsafe-deserialization-untrusted-input
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.dataflow.UnsafeDeserialization::UnsafeDeserialization
import DataFlow::PathGraph

from TaintTrackingConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to unsafe deserializer.", source.getNode(),
  "User-provided data"
