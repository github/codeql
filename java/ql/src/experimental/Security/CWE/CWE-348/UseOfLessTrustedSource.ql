/**
 * @name X-Forwarded-For spoofing
 * @description The software obtains the client ip through `X-Forwarded-For`,
 *              and the attacker can modify the value of `X-Forwarded-For` to forge the ip.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/use-of-less-trusted-source
 * @tags security
 *       external/cwe/cwe-348
 */

import java
import UseOfLessTrustedSourceLib
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class UseOfLessTrustedSourceConfig extends TaintTracking::Configuration {
  UseOfLessTrustedSourceConfig() { this = "UseOfLessTrustedSourceConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UseOfLessTrustedSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UseOfLessTrustedSink }

  /**
   * When using `,` split request data and not taking the first value of
   *  the array, it is considered as `good`.
   */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(ArrayAccess aa, MethodAccess ma | aa.getArray() = ma |
      ma.getQualifier() = node.asExpr() and
      ma.getMethod() instanceof SplitMethod and
      not aa.getIndexExpr().toString() = "0"
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UseOfLessTrustedSourceConfig conf
where
  conf.hasFlowPath(source, sink) and
  source.getNode().getEnclosingCallable() = sink.getNode().getEnclosingCallable() and
  xffIsFirstGet(source.getNode())
select sink.getNode(), source, sink, "X-Forwarded-For spoofing might include code from $@.",
  source.getNode(), "this user input"
