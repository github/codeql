/**
 * @name Temporary Directory Local information disclosure
 * @description Detect local information disclosure via the java temporary directory
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/local-temp-file-or-directory-information-disclosure-method
 * @tags security
 *       external/cwe/cwe-200
 *       external/cwe/cwe-732
 */

import TempDirUtils

abstract class MethodAccessInsecureFileCreation extends MethodAccess {
  /**
   * Docstring describing the file system type (ie. file, directory, ect...) returned.
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

from MethodAccessInsecureFileCreation methodAccess
select methodAccess,
  "Local information disclosure vulnerability due to use of " + methodAccess.getFileSystemType() +
    " readable by other local users."
