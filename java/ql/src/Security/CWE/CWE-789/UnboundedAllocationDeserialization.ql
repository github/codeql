/**
 * @name Unbounded allocation during deserialization
 * @description Allocating an unbounded amount of memory during a deserialization method can lead to a Denial of Service attack.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/unbounded-allocation-deserialization
 * @tags security
 *       external/cwe/cwe-789
 */

import java
import UnboundedAllocationCommon
import DataFlow::PathGraph

class DeserializeMethod extends Method {
  DeserializeMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof TypeSerializable and
    this.hasName("readObject") and
    this.getParameterType(0).(RefType).hasQualifiedName("java.io", "ObjectInputStream")
  }

  Parameter getInputStreamParameter() { result = getParameter(0) }
}

class DeserializeParameter extends DataFlow::Node {
  DeserializeParameter() { this.asParameter() = any(DeserializeMethod m).getInputStreamParameter() }
}

class UnboundedDeserializationConfig extends TaintTracking::Configuration {
  UnboundedDeserializationConfig() { this = "UnboundedDeserializationConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof DeserializeParameter }

  override predicate isSink(DataFlow::Node sink) { sink instanceof AllocationSink }

  override predicate isSanitizer(DataFlow::Node node) { hasUpperBound(node.asExpr()) }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnboundedDeserializationConfig config
where config.hasFlowPath(source, sink)
select sink, source, sink, "Unbounded memory allocation during deserialization of $@.", source,
  "this input stream"
