/**
 * @name Container contents are never initialized
 * @description Querying the contents of a collection or map that is never initialized is not normally useful.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/empty-container
 * @tags reliability
 *       maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.Reflection
import Containers

from Variable v
where
  v.fromSource() and
  v.getType() instanceof ContainerType and
  // Exclude parameters and non-private fields.
  (v instanceof LocalVariableDecl or v.(Field).isPrivate()) and
  // Exclude fields that may be written to reflectively.
  not reflectivelyWritten(v) and
  // Every access to `v` is either...
  forall(VarAccess va | va = v.getAnAccess() |
    // ...an assignment storing a fresh container into `v`,
    exists(AssignExpr assgn | va = assgn.getDest() | assgn.getSource() instanceof FreshContainer)
    or
    // ...a return (but only if `v` is a local variable)
    v instanceof LocalVariableDecl and exists(ReturnStmt ret | ret.getResult() = va)
    or
    // ...or a call to a query method on `v`.
    exists(MethodCall ma | va = ma.getQualifier() | ma.getMethod() instanceof ContainerQueryMethod)
  ) and
  // There is at least one call to a query method.
  exists(MethodCall ma | v.getAnAccess() = ma.getQualifier() |
    ma.getMethod() instanceof ContainerQueryMethod
  ) and
  // Also, any value that `v` is initialized to is a fresh container,
  forall(Expr e | e = v.getAnAssignedValue() | e instanceof FreshContainer) and
  // and `v` is not implicitly initialized.
  not v.(LocalVariableDecl).getDeclExpr().hasImplicitInit()
select v, "The contents of this container are never initialized."
