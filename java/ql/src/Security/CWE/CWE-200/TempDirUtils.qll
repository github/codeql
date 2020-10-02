import java
import semmle.code.java.dataflow.FlowSources

class MethodAccessSystemGetPropertyTempDir extends MethodAccessSystemGetProperty {
  MethodAccessSystemGetPropertyTempDir() { this.hasCompileTimeConstantGetPropertyName("java.io.tmpdir") }
}

/**
 * Find dataflow from the temp directory system property to the `File` constructor.
 * Examples:
 *  - `new File(System.getProperty("java.io.tmpdir"))`
 *  - `new File(new File(System.getProperty("java.io.tmpdir")), "/child")`
 */
private predicate isTaintedFileCreation(Expr expSource, Expr exprDest) {
  exists(ConstructorCall construtorCall |
    construtorCall.getConstructedType() instanceof TypeFile and
    construtorCall.getArgument(0) = expSource and
    construtorCall = exprDest
  )
}

/**
 * Any `File` methods that 
 */
private class TaintFollowingFileMethod extends Method {
  TaintFollowingFileMethod() {
    getDeclaringType() instanceof TypeFile and
    (
      hasName("getAbsoluteFile") or
      hasName("getCanonicalFile")
    )
  }
}

private predicate isTaintFollowingFileTransformation(Expr expSource, Expr exprDest) {
  exists(MethodAccess fileMethodAccess |
    fileMethodAccess.getMethod() instanceof TaintFollowingFileMethod and
    fileMethodAccess.getQualifier() = expSource and
    fileMethodAccess = exprDest
  )
}

predicate isAdditionalFileTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  isTaintedFileCreation(node1.asExpr(), node2.asExpr()) or
  isTaintFollowingFileTransformation(node1.asExpr(), node2.asExpr())
}
