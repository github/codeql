/**
 * @name Temporary directory local information disclosure (file creation without explicit mode)
 * @description Creating a temporary file in the system shared temporary directory without specifying explicit access rights (mode) may disclose its contents to other users.
 * @kind path-problem
 * @problem.severity warning
 * @precision very-high
 * @id java/local-temp-file-or-directory-information-disclosure-missing-mode
 * @tags security
 *       external/cwe/cwe-200
 *       external/cwe/cwe-732
 */

import java
import TempDirUtils
import DataFlow::PathGraph

private class MethodFileSystemFileCreation extends Method {
  MethodFileSystemFileCreation() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName(["mkdir", "mkdirs", "createNewFile"])
  }
}

abstract private class FileCreationSink extends DataFlow::Node { }

/**
 * The qualifier of a call to one of `File`'s file-creating or directory-creating methods, treated as a sink by `TempDirSystemGetPropertyToCreateConfig`.
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
 * The argument to
 * a call to one of `Files` file-creating or directory-creating methods, treated as a sink by `TempDirSystemGetPropertyToCreateConfig`.
 */
private class FilesFileCreationSink extends FileCreationSink {
  FilesFileCreationSink() {
    exists(FilesVulnerableCreationMethodAccess ma | ma.getArgument(0) = this.asExpr())
  }
}

/**
 * A call to a `Files` method that create files/directories without explicitly
 * setting the newly-created file or directory's permissions.
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
      this.getNumArgument() = 1
      or
      m.hasName("newByteChannel") and
      this.getNumArgument() = 2
    )
  }
}

/**
 * A call to a `File` method that create files/directories with a specific set of permissions explicitly set.
 * We can safely assume that any calls to these methods with explicit `PosixFilePermissions.asFileAttribute` contains a certain level of intentionality behind it.
 */
private class FilesSanitiznignCreationMethodAccess extends MethodAccess {
  FilesSanitiznignCreationMethodAccess() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType().hasQualifiedName("java.nio.file", "Files")
    |
      m.hasName(["createFile", "createDirectory", "createDirectories"]) and
      this.getNumArgument() = 2
    )
  }
}

/**
 * The temp directory argument to a call to `java.io.File::createTempFile`, treated as a sink by `TempDirSystemGetPropertyToCreateConfig`.
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

  /**
   * Find dataflow from the temp directory system property to the `File` constructor.
   * Examples:
   *  - `new File(System.getProperty("java.io.tmpdir"))`
   *  - `new File(new File(System.getProperty("java.io.tmpdir")), "/child")`
   */
  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalFileTaintStep(node1, node2)
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof FileCreationSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    exists(FilesSanitiznignCreationMethodAccess sanitisingMethodAccess |
      sanitizer.asExpr() = sanitisingMethodAccess.getArgument(0)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TempDirSystemGetPropertyToCreateConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Local information disclosure vulnerability from $@ due to use of file or directory readable by other local users.",
  source.getNode(), "system temp directory"
