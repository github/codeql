/**
 * @name Overly-general catch clause
 * @description Catching 'Throwable' or 'Exception' is dangerous because these can include
 *              'Error' or 'RuntimeException'.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/overly-general-catch
 * @tags reliability
 *       external/cwe/cwe-396
 */

import java

private predicate relevantTypeNames(string typeName, string message) {
  // `Throwable` is the more severe case due to `Error`s such as `OutOfMemoryError`.
  typeName = "Throwable" and message = "Error"
  or
  // `Exception` includes `RuntimeException`s such as `ArrayIndexOutOfBoundsException`.
  typeName = "Exception" and message = "RuntimeException"
}

private Type getAThrownExceptionType(TryStmt t) {
  exists(MethodAccess ma, Exception e |
    t.getBlock() = ma.getEnclosingStmt().getEnclosingStmt*() and
    ma.getMethod().getAnException() = e and
    result = e.getType()
  )
  or
  exists(ClassInstanceExpr cie, Exception e |
    t.getBlock() = cie.getEnclosingStmt().getEnclosingStmt*() and
    cie.getConstructor().getAnException() = e and
    result = e.getType()
  )
  or
  exists(ThrowStmt ts |
    t.getBlock() = ts.getEnclosingStmt*() and
    result = ts.getExpr().getType()
  )
}

from CatchClause cc, LocalVariableDeclExpr v, TryStmt t, string typeName, string message
where
  relevantTypeNames(typeName, message) and
  t.getACatchClause() = cc and
  cc.getVariable() = v and
  v.getType().(RefType).hasQualifiedName("java.lang", typeName) and
  // It's usually OK if the exception is logged in some way, or re-thrown.
  not exists(v.getAnAccess()) and
  // Exclude results in test code.
  not cc.getEnclosingCallable().getDeclaringType() instanceof TestClass and
  // Check that all exceptions thrown in the try block are
  // either more specific than the caught type or unrelated to it.
  not exists(Type et | et = getAThrownExceptionType(t) |
    et.(RefType).getADescendant().hasQualifiedName("java.lang", typeName)
  )
select cc,
  "Do not catch '" + cc.getVariable().getType() + "'" + "; " + message +
    "s should normally be propagated."
