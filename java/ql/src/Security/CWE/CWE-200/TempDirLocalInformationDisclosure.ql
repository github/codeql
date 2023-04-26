/**
 * @name Local information disclosure in a temporary directory
 * @description Writing information without explicit permissions to a shared temporary directory may disclose it to other users.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision medium
 * @id java/local-temp-file-or-directory-information-disclosure
 * @tags security
 *       external/cwe/cwe-200
 *       external/cwe/cwe-732
 */

import java
import semmle.code.java.os.OSCheck
import TempDirUtils
import semmle.code.java.dataflow.TaintTracking

abstract private class MethodFileSystemFileCreation extends Method {
  MethodFileSystemFileCreation() { this.getDeclaringType() instanceof TypeFile }
}

private class MethodFileDirectoryCreation extends MethodFileSystemFileCreation {
  MethodFileDirectoryCreation() { this.hasName(["mkdir", "mkdirs"]) }
}

private class MethodFileFileCreation extends MethodFileSystemFileCreation {
  MethodFileFileCreation() { this.hasName("createNewFile") }
}

abstract private class FileCreationSink extends DataFlow::Node { }

/**
 * The qualifier of a call to one of `File`'s file-creating or directory-creating methods,
 * treated as a sink by `TempDirSystemGetPropertyToCreateConfig`.
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
 * The argument to a call to one of `Files` file-creating or directory-creating methods,
 * treated as a sink by `TempDirSystemGetPropertyToCreateConfig`.
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
 * We can safely assume that any calls to these methods with explicit `PosixFilePermissions.asFileAttribute`
 * contains a certain level of intentionality behind it.
 */
private class FilesSanitizingCreationMethodAccess extends MethodAccess {
  FilesSanitizingCreationMethodAccess() {
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
 * The temp directory argument to a call to `java.io.File::createTempFile`,
 * treated as a sink by `TempDirSystemGetPropertyToCreateConfig`.
 */
private class FileCreateTempFileSink extends FileCreationSink {
  FileCreateTempFileSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof MethodFileCreateTempFile and ma.getArgument(2) = this.asExpr()
    )
  }
}

/**
 * A sanitizer that holds when the program is definitely running under some version of Windows.
 */
abstract private class WindowsOsSanitizer extends DataFlow::Node { }

private class IsNotUnixSanitizer extends WindowsOsSanitizer {
  IsNotUnixSanitizer() { any(IsUnixGuard guard).controls(this.asExpr().getBasicBlock(), false) }
}

private class IsWindowsSanitizer extends WindowsOsSanitizer {
  IsWindowsSanitizer() { any(IsWindowsGuard guard).controls(this.asExpr().getBasicBlock(), true) }
}

private class IsSpecificWindowsSanitizer extends WindowsOsSanitizer {
  IsSpecificWindowsSanitizer() {
    any(IsSpecificWindowsVariant guard).controls(this.asExpr().getBasicBlock(), true)
  }
}

/**
 * A taint tracking configuration tracking the access of the system temporary directory
 * flowing to the creation of files or directories.
 */
module TempDirSystemGetPropertyToCreateConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof ExprSystemGetPropertyTempDirTainted
  }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof FileCreationSink and
    not TempDirSystemGetPropertyDirectlyToMkdir::flowTo(sink)
  }

  predicate isBarrier(DataFlow::Node sanitizer) {
    exists(FilesSanitizingCreationMethodAccess sanitisingMethodAccess |
      sanitizer.asExpr() = sanitisingMethodAccess.getArgument(0)
    )
    or
    sanitizer instanceof WindowsOsSanitizer
  }
}

module TempDirSystemGetPropertyToCreate =
  TaintTracking::Global<TempDirSystemGetPropertyToCreateConfig>;

/**
 * Configuration that tracks calls to to `mkdir` or `mkdirs` that are are directly on the temp directory system property.
 * Examples:
 * - `File tempDir = new File(System.getProperty("java.io.tmpdir")); tempDir.mkdir();`
 * - `File tempDir = new File(System.getProperty("java.io.tmpdir")); tempDir.mkdirs();`
 *
 * These are examples of code that is simply verifying that the temp directory exists.
 * As such, this code pattern is filtered out as an explicit vulnerability in
 * `TempDirSystemGetPropertyToCreateConfig::isSink`.
 */
module TempDirSystemGetPropertyDirectlyToMkdirConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(ExprSystemGetPropertyTempDirTainted propertyGetExpr, DataFlow::Node callSite |
      DataFlow::localFlow(DataFlow::exprNode(propertyGetExpr), callSite)
    |
      isFileConstructorArgument(callSite.asExpr(), node.asExpr(), 1)
    )
  }

  predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma | ma.getMethod() instanceof MethodFileDirectoryCreation |
      ma.getQualifier() = node.asExpr()
    )
  }

  predicate isBarrier(DataFlow::Node sanitizer) {
    isFileConstructorArgument(sanitizer.asExpr(), _, _)
  }
}

module TempDirSystemGetPropertyDirectlyToMkdir =
  TaintTracking::Global<TempDirSystemGetPropertyDirectlyToMkdirConfig>;

//
// Begin configuration for tracking single-method calls that are vulnerable.
//
/**
 * A `MethodAccess` against a method that creates a temporary file or directory in a shared temporary directory.
 */
abstract class MethodAccessInsecureFileCreation extends MethodAccess {
  /**
   * Gets the type of entity created (e.g. `file`, `directory`, ...).
   */
  abstract string getFileSystemEntityType();

  DataFlow::Node getNode() { result.asExpr() = this }
}

/**
 * An insecure call to `java.io.File.createTempFile`.
 */
class MethodAccessInsecureFileCreateTempFile extends MethodAccessInsecureFileCreation {
  MethodAccessInsecureFileCreateTempFile() {
    this.getMethod() instanceof MethodFileCreateTempFile and
    (
      // `File.createTempFile(string, string)` always uses the default temporary directory
      this.getNumArgument() = 2
      or
      // The default temporary directory is used when the last argument of `File.createTempFile(string, string, File)` is `null`
      DataFlow::localExprFlow(any(NullLiteral n), this.getArgument(2))
    )
  }

  override string getFileSystemEntityType() { result = "file" }
}

/**
 * The `com.google.common.io.Files.createTempDir` method.
 */
class MethodGuavaFilesCreateTempFile extends Method {
  MethodGuavaFilesCreateTempFile() {
    this.getDeclaringType().hasQualifiedName("com.google.common.io", "Files") and
    this.hasName("createTempDir")
  }
}

/**
 * A call to the `com.google.common.io.Files.createTempDir` method.
 */
class MethodAccessInsecureGuavaFilesCreateTempFile extends MethodAccessInsecureFileCreation {
  MethodAccessInsecureGuavaFilesCreateTempFile() {
    this.getMethod() instanceof MethodGuavaFilesCreateTempFile
  }

  override string getFileSystemEntityType() { result = "directory" }
}

/**
 * We include use of inherently insecure methods, which don't have any associated
 * flow path, in with results describing a path from reading `java.io.tmpdir` or similar to use
 * in a file creation op.
 *
 * We achieve this by making inherently-insecure method invocations into an edge-less graph,
 * resulting in a zero-length paths.
 */
module InsecureMethodPathGraph implements DataFlow::PathGraphSig<MethodAccessInsecureFileCreation> {
  predicate edges(MethodAccessInsecureFileCreation n1, MethodAccessInsecureFileCreation n2) {
    none()
  }

  predicate nodes(MethodAccessInsecureFileCreation n, string key, string val) {
    key = "semmle.label" and val = n.toString()
  }

  predicate subpaths(
    MethodAccessInsecureFileCreation n1, MethodAccessInsecureFileCreation n2,
    MethodAccessInsecureFileCreation n3, MethodAccessInsecureFileCreation n4
  ) {
    none()
  }
}

module Flow =
  DataFlow::MergePathGraph<TempDirSystemGetPropertyToCreate::PathNode,
    MethodAccessInsecureFileCreation, TempDirSystemGetPropertyToCreate::PathGraph,
    InsecureMethodPathGraph>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, string message
where
  (
    TempDirSystemGetPropertyToCreate::flowPath(source.asPathNode1(), sink.asPathNode1()) and
    message =
      "Local information disclosure vulnerability from $@ due to use of file or directory readable by other local users."
    or
    source = sink and
    // Note this message has no "$@" placeholder, so the "system temp directory" template parameter below is not used.
    message =
      "Local information disclosure vulnerability due to use of " +
        source.asPathNode2().getFileSystemEntityType() + " readable by other local users."
  ) and
  not isPermissionsProtectedTempDirUse(sink.getNode())
select source.getNode(), source, sink, message, source.getNode(), "system temp directory"
