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

private class MethodFileSystemFileCreation extends Method {
  MethodFileSystemFileCreation() {
    getDeclaringType() instanceof TypeFile and
    (
      hasName(["mkdir", "mkdirs"]) or
      hasName("createNewFile")
    )
  }
}

abstract private class FileCreationSink extends DataFlow::Node { }

private class FileFileCreationSink extends FileCreationSink {
  FileFileCreationSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof MethodFileSystemFileCreation and
      ma.getQualifier() = this.asExpr()
    )
  }
}

private class FilesFileCreationSink extends FileCreationSink {
  FilesFileCreationSink() {
    exists(FilesVulnerableCreationMethodAccess ma | ma.getArgument(0) = this.asExpr())
  }
}

private class FilesVulnerableCreationMethodAccess extends MethodAccess {
  FilesVulnerableCreationMethodAccess() {
    getMethod().getDeclaringType().hasQualifiedName("java.nio.file", "Files") and
    (
      getMethod().hasName(["write", "newBufferedWriter", "newOutputStream"])
      or
      getMethod().hasName(["createFile", "createDirectory", "createDirectories"]) and getNumArgument() = 1
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

  override predicate isSink(DataFlow::Node sink) { sink instanceof FileCreationSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TempDirSystemGetPropertyToCreateConfig conf
where conf.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "Local information disclosure vulnerability from $@ due to use of file or directory readable by other local users.",
  source.getNode(), "system temp directory"
