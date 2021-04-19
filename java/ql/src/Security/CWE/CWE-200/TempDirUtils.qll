/**
 * Provides classes and predicates for reasoning about temporary file/directory creations.
 */

import java
import semmle.code.java.dataflow.FlowSources

/**
 * A method that returns a `String` or `File` that has been tainted by `System.getProperty("java.io.tmpdir")`.
 */
abstract class MethodAccessSystemGetPropertyTempDirTainted extends MethodAccess { }

/**
 * Method access `System.getProperty("java.io.tmpdir")`.
 */
private class MethodAccessSystemGetPropertyTempDir extends MethodAccessSystemGetPropertyTempDirTainted,
  MethodAccessSystemGetProperty {
  MethodAccessSystemGetPropertyTempDir() {
    this.hasCompileTimeConstantGetPropertyName("java.io.tmpdir")
  }
}

/**
 * A method call to the `org.apache.commons.io.FileUtils` methods `getTempDirectory` or `getTempDirectoryPath`.
 */
private class MethodAccessApacheFileUtilsTempDir extends MethodAccessSystemGetPropertyTempDirTainted {
  MethodAccessApacheFileUtilsTempDir() {
    exists(Method m |
      m.getDeclaringType().hasQualifiedName("org.apache.commons.io", "FileUtils") and
      m.hasName(["getTempDirectory", "getTempDirectoryPath"]) and
      this.getMethod() = m
    )
  }
}

/**
 * A `java.io.File::createTempFile` method.
 */
class MethodFileCreateTempFile extends Method {
  MethodFileCreateTempFile() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName("createTempFile")
  }
}

/**
 * Find dataflow from the temp directory system property to the `File` constructor.
 * Examples:
 *  - `new File(System.getProperty("java.io.tmpdir"))`
 *  - `new File(new File(System.getProperty("java.io.tmpdir")), "/child")`
 */
private predicate isFileConstructorArgument(Expr expSource, Expr exprDest) {
  exists(ConstructorCall construtorCall |
    construtorCall.getConstructedType() instanceof TypeFile and
    construtorCall.getArgument(0) = expSource and
    construtorCall = exprDest
  )
}

/**
 * A `File` method where the temporary directory is still part of the root path.
 */
private class TaintFollowingFileMethod extends Method {
  TaintFollowingFileMethod() {
    getDeclaringType() instanceof TypeFile and
    hasName(["getAbsoluteFile", "getCanonicalFile"])
  }
}

private predicate isTaintPropagatingFileTransformation(Expr expSource, Expr exprDest) {
  exists(MethodAccess fileMethodAccess |
    fileMethodAccess.getMethod() instanceof TaintPropagatingFileMethod and
    fileMethodAccess.getQualifier() = expSource and
    fileMethodAccess = exprDest
  )
}

/**
 * Holds if taint should propagate from `node1` to `node2` across some file creation or transformation operation.
 * For example, `taintedFile.getCanonicalFile()` is itself tainted.
 */
predicate isAdditionalFileTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  isTaintedFileCreation(node1.asExpr(), node2.asExpr()) or
  isTaintFollowingFileTransformation(node1.asExpr(), node2.asExpr())
}
