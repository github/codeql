/**
 * Provides classes and predicates for reasoning about temporary file/directory creations.
 */

import java
private import semmle.code.java.environment.SystemProperty
import semmle.code.java.dataflow.FlowSources

/**
 * A method or field access that returns a `String` or `File` that has been tainted by `System.getProperty("java.io.tmpdir")`.
 */
class ExprSystemGetPropertyTempDirTainted extends Expr {
  ExprSystemGetPropertyTempDirTainted() { this = getSystemProperty("java.io.tmpdir") }
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
 * Holds if `expDest` is some constructor call `new java.io.File(expSource)`, where the specific `File` constructor being used has `paramCount` parameters.
 */
predicate isFileConstructorArgument(Expr expSource, Expr exprDest, int paramCount) {
  exists(ConstructorCall construtorCall |
    construtorCall.getConstructedType() instanceof TypeFile and
    construtorCall.getArgument(0) = expSource and
    construtorCall = exprDest and
    construtorCall.getConstructor().getNumberOfParameters() = paramCount
  )
}

/**
 * A method call to `java.io.File::setReadable`.
 */
private class FileSetRedableMethodCall extends MethodCall {
  FileSetRedableMethodCall() {
    exists(Method m | this.getMethod() = m |
      m.getDeclaringType() instanceof TypeFile and
      m.hasName("setReadable")
    )
  }

  predicate isCallWithArguments(boolean arg1, boolean arg2) {
    this.isCallWithArgument(0, arg1) and this.isCallToSecondArgumentWithValue(arg2)
  }

  private predicate isCallToSecondArgumentWithValue(boolean value) {
    this.getMethod().getNumberOfParameters() = 1 and value = true
    or
    this.isCallWithArgument(1, value)
  }

  private predicate isCallWithArgument(int index, boolean arg) {
    DataFlow::localExprFlow(any(CompileTimeConstantExpr e | e.getBooleanValue() = arg),
      this.getArgument(index))
  }
}

/**
 * Hold's if temporary directory's use is protected if there is an explicit call to
 * `setReadable(false, false)`, then `setRedabale(true, true)`.
 */
predicate isPermissionsProtectedTempDirUse(DataFlow::Node sink) {
  exists(FileSetRedableMethodCall setReadable1, FileSetRedableMethodCall setReadable2 |
    setReadable1.isCallWithArguments(false, false) and
    setReadable2.isCallWithArguments(true, true)
  |
    exists(DataFlow::Node setReadableNode1, DataFlow::Node setReadableNode2 |
      setReadableNode1.asExpr() = setReadable1.getQualifier() and
      setReadableNode2.asExpr() = setReadable2.getQualifier()
    |
      DataFlow::localFlow(sink, setReadableNode1) and // Flow from sink to setReadable(false, false)
      DataFlow::localFlow(sink, setReadableNode2) and // Flow from sink to setReadable(true, true)
      DataFlow::localFlow(setReadableNode1, setReadableNode2) // Flow from setReadable(false, false) to setReadable(true, true)
    )
  )
}
