/**
 * @name Temporary Directory Local information disclosure
 * @description Writing information without explicit permissions to a shared temporary directory may disclose it to other users.
 * @kind path-problem
 * @problem.severity warning
 * @precision very-high
 * @id java/local-temp-file-or-directory-information-disclosure
 * @tags security
 *       external/cwe/cwe-200
 *       external/cwe/cwe-732
 */

import java
import TempDirUtils
import DataFlow::PathGraph

private class MethodFileSystemFileCreation extends Method {
  MethodFileSystemFileCreation() {
    getDeclaringType() instanceof TypeFile and
    hasName(["mkdir", "mkdirs", "createNewFile"])
  }
}

abstract private class FileCreationSink extends DataFlow::Node { }

/**
 * Sink for tainted `File` having a file or directory creation method called on it.
 */
private class FileFileCreationSink extends FileCreationSink {
  FileFileCreationSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof MethodFileSystemFileCreation and
      ma.getQualifier() = this.asExpr()
    )
  }
}

/**
 * Sink for if tained File/Path having some `Files` method called on it that creates a file or directory.
 */
private class FilesFileCreationSink extends FileCreationSink {
  FilesFileCreationSink() {
    exists(FilesVulnerableCreationMethodAccess ma | ma.getArgument(0) = this.asExpr())
  }
}

/**
 * Captures all of the vulnerable methods on `Files` that create files/directories without explicitly
 * setting the permissions.
 */
private class FilesVulnerableCreationMethodAccess extends MethodAccess {
  FilesVulnerableCreationMethodAccess() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType().hasQualifiedName("java.nio.file", "Files")
    |
      m.hasName(["write", "newBufferedWriter", "newOutputStream"])
      or
      m.hasName(["createFile", "createDirectory", "createDirectories"]) and
      getNumArgument() = 1
    )
  }
}

/**
 * A call to `java.io.File::createTempFile` where the the system temp dir sinks to the last argument.
 */
private class FileCreateTempFileSink extends FileCreationSink {
  FileCreateTempFileSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof MethodFileCreateTempFile and ma.getArgument(2) = this.asExpr()
    )
  }
}

private class TempDirSystemGetPropertyToCreateConfig extends TaintTracking::Configuration {
  TempDirSystemGetPropertyToCreateConfig() { this = "TempDirSystemGetPropertyToCreateConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof MethodAccessSystemGetPropertyTempDirTainted
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalFileTaintStep(node1, node2)
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof FileCreationSink }
}

abstract class MethodAccessInsecureFileCreation extends MethodAccess {
  /**
   * Docstring describing the file system type (ie. file, directory, etc...) returned.
   */
  abstract string getFileSystemType();
}

/**
 * Insecure calls to `java.io.File::createTempFile`.
 */
class MethodAccessInsecureFileCreateTempFile extends MethodAccessInsecureFileCreation {
  MethodAccessInsecureFileCreateTempFile() {
    this.getMethod() instanceof MethodFileCreateTempFile and
    (
      this.getNumArgument() = 2
      or
      // Vulnerablilty exists when the last argument is `null`
      getArgument(2) instanceof NullLiteral
    )
  }

  override string getFileSystemType() { result = "file" }
}

class MethodGuavaFilesCreateTempFile extends Method {
  MethodGuavaFilesCreateTempFile() {
    getDeclaringType().hasQualifiedName("com.google.common.io", "Files") and
    hasName("createTempDir")
  }
}

class MethodAccessInsecureGuavaFilesCreateTempFile extends MethodAccessInsecureFileCreation {
  MethodAccessInsecureGuavaFilesCreateTempFile() {
    getMethod() instanceof MethodGuavaFilesCreateTempFile
  }

  override string getFileSystemType() { result = "directory" }
}

/**
 * This is a hack: we include use of inherently insecure methods, which don't have any associated
 * flow path, in with results describing a path from reading java.io.tmpdir or similar to use
 * in a file creation op.
 *
 * We achieve this by making inherently-insecure method invocations both a source and a sink in
 * this configuration, resulting in a zero-length path which is type-compatible with the actual
 * path-flow results.
 */
class InsecureMethodPseudoConfiguration extends DataFlow::Configuration {
  InsecureMethodPseudoConfiguration() { this = "InsecureMethodPseudoConfiguration " }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof MethodAccessInsecureFileCreation
  }

  override predicate isSink(DataFlow::Node node) {
    node.asExpr() instanceof MethodAccessInsecureFileCreation
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, string message
where
  any(TempDirSystemGetPropertyToCreateConfig conf).hasFlowPath(source, sink) and
  message =
    "Local information disclosure vulnerability from $@ due to use of file or directory readable by other local users."
  or
  any(InsecureMethodPseudoConfiguration conf).hasFlowPath(source, sink) and
  // Note this message has no "$@" placeholder, so the "system temp directory" template parameter below is not used.
  message =
    "Local information disclosure vulnerability due to use of " +
      source.getNode().asExpr().(MethodAccessInsecureFileCreation).getFileSystemType() +
      " readable by other local users."
select source.getNode(), source, sink, message, source.getNode(), "system temp directory"
