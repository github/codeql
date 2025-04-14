/** Provides classes to reason about local information disclosure in a temporary directory. */

import java
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.os.OSCheck
private import semmle.code.java.security.TempDirUtils

/**
 * A method which creates a file or directory in the file system.
 */
abstract private class MethodFileSystemFileCreation extends Method {
  MethodFileSystemFileCreation() { this.getDeclaringType() instanceof TypeFile }
}

/**
 * A method which creates a directory in the file system.
 */
private class MethodFileDirectoryCreation extends MethodFileSystemFileCreation {
  MethodFileDirectoryCreation() { this.hasName(["mkdir", "mkdirs"]) }
}

/**
 * A method which creates a file in the file system.
 */
private class MethodFileFileCreation extends MethodFileSystemFileCreation {
  MethodFileFileCreation() { this.hasName("createNewFile") }
}

/**
 * A dataflow node that creates a file or directory in the file system.
 */
abstract private class FileCreationSink extends ApiSinkNode { }

/**
 * The qualifier of a call to one of `File`'s file-creating or directory-creating methods,
 * treated as a sink by `TempDirSystemGetPropertyToCreateConfig`.
 */
private class FileFileCreationSink extends FileCreationSink {
  FileFileCreationSink() {
    exists(MethodCall ma |
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
    exists(FilesVulnerableCreationMethodCall ma | ma.getArgument(0) = this.asExpr())
  }
}

/**
 * A call to a `Files` method that create files/directories without explicitly
 * setting the newly-created file or directory's permissions.
 */
private class FilesVulnerableCreationMethodCall extends MethodCall {
  FilesVulnerableCreationMethodCall() {
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
private class FilesSanitizingCreationMethodCall extends MethodCall {
  FilesSanitizingCreationMethodCall() {
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
    exists(MethodCall ma |
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
    exists(FilesSanitizingCreationMethodCall sanitisingMethodCall |
      sanitizer.asExpr() = sanitisingMethodCall.getArgument(0)
    )
    or
    sanitizer instanceof WindowsOsSanitizer
  }
}

/**
 * Taint-tracking flow which tracks the access of the system temporary directory
 * flowing to the creation of files or directories.
 */
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
    exists(MethodCall ma | ma.getMethod() instanceof MethodFileDirectoryCreation |
      ma.getQualifier() = node.asExpr()
    )
  }

  predicate isBarrier(DataFlow::Node sanitizer) {
    isFileConstructorArgument(sanitizer.asExpr(), _, _)
  }
}

/**
 * Taint-tracking flow that tracks calls to to `mkdir` or `mkdirs` that are are directly on the temp directory system property.
 * Examples:
 * - `File tempDir = new File(System.getProperty("java.io.tmpdir")); tempDir.mkdir();`
 * - `File tempDir = new File(System.getProperty("java.io.tmpdir")); tempDir.mkdirs();`
 *
 * These are examples of code that is simply verifying that the temp directory exists.
 * As such, this code pattern is filtered out as an explicit vulnerability in
 * `TempDirSystemGetPropertyToCreateConfig::isSink`.
 */
module TempDirSystemGetPropertyDirectlyToMkdir =
  TaintTracking::Global<TempDirSystemGetPropertyDirectlyToMkdirConfig>;

//
// Begin configuration for tracking single-method calls that are vulnerable.
//
/**
 * A `MethodCall` against a method that creates a temporary file or directory in a shared temporary directory.
 */
abstract class MethodCallInsecureFileCreation extends MethodCall {
  /**
   * Gets the type of entity created (e.g. `file`, `directory`, ...).
   */
  abstract string getFileSystemEntityType();

  /**
   * Gets the dataflow node representing the file system entity created.
   */
  DataFlow::Node getNode() { result.asExpr() = this }
}

/**
 * An insecure call to `java.io.File.createTempFile`.
 */
class MethodCallInsecureFileCreateTempFile extends MethodCallInsecureFileCreation {
  MethodCallInsecureFileCreateTempFile() {
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
class MethodCallInsecureGuavaFilesCreateTempFile extends MethodCallInsecureFileCreation {
  MethodCallInsecureGuavaFilesCreateTempFile() {
    this.getMethod() instanceof MethodGuavaFilesCreateTempFile
  }

  override string getFileSystemEntityType() { result = "directory" }
}
