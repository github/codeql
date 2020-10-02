/**
 * @name Temporary Directory Local information disclosure
 * @description Detect local information disclosure via the java temporary directory
 * @kind path-problem
 * @problem.severity warning
 * @precision very-high
 * @id java/local-information-disclosure
 * @tags security
 *       external/cwe/cwe-200
 */

import TempDirUtils
import DataFlow::PathGraph

private class MethodFileSystemCreation extends Method {
  MethodFileSystemCreation() {
    getDeclaringType() instanceof TypeFile and
    (
      hasName("mkdir") or
      hasName("createNewFile")
    )
  }
}

private class TempDirSystemGetPropertyToCreateConfig extends TaintTracking::Configuration {
  TempDirSystemGetPropertyToCreateConfig() { this = "TempDirSystemGetPropertyToCreateConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof MethodAccessSystemGetPropertyTempDir
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalFileTaintStep(node1, node2)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists (MethodAccess ma |
      ma.getMethod() instanceof MethodFileSystemCreation and
      ma.getQualifier() = sink.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TempDirSystemGetPropertyToCreateConfig conf
where conf.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "Local information disclosure vulnerability from $@ due to use of file or directory readable by other local users.", source.getNode(),
  "system temp directory"
