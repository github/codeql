/**
 * @name Container contents are never accessed
 * @description A collection or map whose contents are never queried or accessed is useless.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/unused-container
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.Reflection
import semmle.code.java.frameworks.Lombok
import Containers

from Variable v
where
  v.fromSource() and
  v.getType() instanceof ContainerType and
  // Exclude parameters and non-private fields.
  (v instanceof LocalVariableDecl or v.(Field).isPrivate()) and
  // Exclude fields that may be read from reflectively.
  not reflectivelyRead(v) and
  // Exclude fields annotated with `@SuppressWarnings("unused")`.
  not v.getAnAnnotation().(SuppressWarningsAnnotation).getASuppressedWarning() = "unused" and
  // Exclude fields with relevant Lombok annotations.
  not v instanceof LombokGetterAnnotatedField and
  // Every access to `v` is either...
  forex(VarAccess va | va = v.getAnAccess() |
    // ...an assignment storing a new container into `v`,
    exists(AssignExpr assgn |
      va = assgn.getDest() and assgn.getSource() instanceof ClassInstanceExpr
    )
    or
    // ...or a call to a mutator method on `v` such that the result of the call is not checked.
    exists(ContainerMutation cm | va = cm.getQualifier() and not cm.resultIsChecked())
  ) and
  // Also, any value that `v` is initialized to is a new container,
  forall(Expr e | e = v.getAnAssignedValue() | e instanceof ClassInstanceExpr) and
  // and `v` is not implicitly initialized by a for-each loop.
  not exists(EnhancedForStmt efs | efs.getVariable().getVariable() = v)
select v, "The contents of this container are never accessed."
