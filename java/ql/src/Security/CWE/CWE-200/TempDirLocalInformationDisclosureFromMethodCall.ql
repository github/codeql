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

/**
 * All `java.io.File::createTempFile` methods.
 */
class MethodFileCreateTempFile extends Method {
  MethodFileCreateTempFile() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName("createTempFile")
  }
}

class TempDirSystemGetPropertyToAnyConfig extends TaintTracking::Configuration {
  TempDirSystemGetPropertyToAnyConfig() { this = "TempDirSystemGetPropertyToAnyConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof MethodAccessSystemGetPropertyTempDirTainted
  }

  override predicate isSink(DataFlow::Node source) { any() }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalFileTaintStep(node1, node2)
  }
}

abstract class MethodAccessInsecureFileCreation extends MethodAccess { }

/**
 * Insecure calls to `java.io.File::createTempFile`.
 */
class MethodAccessInsecureFileCreateTempFile extends MethodAccessInsecureFileCreation {
  MethodAccessInsecureFileCreateTempFile() {
    this.getMethod() instanceof MethodFileCreateTempFile and
    (
      this.getNumArgument() = 2 or
      // Vulnerablilty exists when the last argument is `null`
      getArgument(2) instanceof NullLiteral or
      // There exists a flow from the 'java.io.tmpdir' system property to this argument
      exists(TempDirSystemGetPropertyToAnyConfig config |
        config.hasFlowTo(DataFlow::exprNode(getArgument(2)))
      )
    )
  }
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
}

from MethodAccessInsecureFileCreation methodAccess
select methodAccess,
  "Local information disclosure vulnerability due to use of file or directory readable by other local users."
