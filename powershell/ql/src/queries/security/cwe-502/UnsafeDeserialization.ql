/**
 * @name Unsafe deserializer
 * @description Calling an unsafe deserializer with data controlled by an attacker
 *              can lead to denial of service and other security problems.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id powershell/microsoft/public/unsafe-deserialization
 * @tags correctness
 *       security
 *       external/cwe/cwe-502
 */

import powershell
import semmle.code.powershell.security.UnsafeDeserializationQuery
import UnsafeDeserializationFlow::PathGraph

from
  UnsafeDeserializationFlow::PathNode source, UnsafeDeserializationFlow::PathNode sink,
  Source sourceNode
where
  UnsafeDeserializationFlow::flowPath(source, sink) and
  sourceNode = source.getNode()
select sink.getNode(), source, sink, "This unsafe deserializer deserializes  on a $@.", sourceNode,
  sourceNode.getSourceType()
