/**
 * @name Delayed deserialization of user-controlled data
 * @description Delayed deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/delayed-unsafe-deserialization
 * @tags security
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.security.UnsafeDeserializationQuery
import DataFlow::PathGraph

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that stores data to a byte array field.
 */
private predicate byteArrayFieldFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(FieldRead access, Field field | field = access.getField() |
    field.getType().hasName("byte[]") and
    access = fromNode.asExpr() and
    field.getAnAccess().(FieldRead) = toNode.asExpr()
  )
}

/**
 * Tracks flows from remote user input to a deserialization sink
 * taking into account that taited data can be stored in a byte field.
 */
private class DelayedUnsafeDeserializationConfig extends UnsafeDeserializationConfig {
  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    UnsafeDeserializationConfig.super.isAdditionalTaintStep(pred, succ)
    or
    byteArrayFieldFlowStep(pred, succ)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, DelayedUnsafeDeserializationConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(UnsafeDeserializationSink).getMethodAccess(), source, sink,
  "Delayed unsafe deserialization of $@.", source.getNode(), "user input"
