/**
 * @name File Path Injection
 * @description Loading files based on unvalidated user-input may cause file information disclosure
 *              and uploading files with unvalidated file types to an arbitrary directory may lead to
 *              Remote Command Execution (RCE).
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/file-path-injection
 * @tags security
 *       external/cwe-073
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.PathCreation
import JFinalController
import experimental.semmle.code.java.PathSanitizer
import DataFlow::PathGraph

class InjectFilePathConfig extends TaintTracking::Configuration {
  InjectFilePathConfig() { this = "InjectFilePathConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(PathCreation p).getAnInput() and
    not sink instanceof NormalizedPathNode
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(Type t | t = node.getType() | t instanceof BoxedType or t instanceof PrimitiveType)
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof PathTraversalBarrierGuard
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, InjectFilePathConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "External control of file name or path due to $@.",
  source.getNode(), "user-provided value"
