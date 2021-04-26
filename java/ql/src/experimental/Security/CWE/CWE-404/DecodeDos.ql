/**
 * @name Denial Of Service due to decoding of untrusted input
 * @description During the process of decoding of an untrusted input, `Exception`s can be thrown.
 *              When these are not caught, they can lead to application crash causing a denial of service.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/decode
 * @tags security
 *       external/cwe/cwe-918
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

private class DecodeSink extends DataFlow::Node {
  DecodeSink() {
    exists(MethodAccess ma | ma.getMethod().hasQualifiedName(_, _, "decode") |
      ma.getArgument(_) = this.asExpr() and
      not exists(TryStmt ts | ma.getAnEnclosingStmt() = ts)
    )
  }
}

class DecodeDosConfiguration extends TaintTracking::Configuration {
  DecodeDosConfiguration() { this = "DoS due to decode of untrusted input" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DecodeSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, DecodeDosConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential server side request forgery due to $@.",
  source.getNode(), "a user-provided value"
