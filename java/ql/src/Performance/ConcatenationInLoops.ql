/**
 * @name String concatenation in loop
 * @description Performing string concatenation in a loop that iterates many times may affect
 *              performance.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/string-concatenation-in-loop
 * @tags efficiency
 *       maintainability
 */

import semmle.code.java.Type
import semmle.code.java.Expr
import semmle.code.java.Statement
import semmle.code.java.JDK

/** A use of `+` that has type `String`. */
class StringCat extends AddExpr {
  StringCat() { this.getType() instanceof TypeString }
}

/**
 * An assignment of the form
 *
 * ```
 *   v = ... + ... v ...
 * ```
 * or
 *
 * ```
 *   v += ...
 * ```
 * where `v` is a simple variable (and not, for example,
 * an array element).
 */
predicate useAndDef(Assignment a, Variable v) {
  a.getDest() = v.getAnAccess() and
  v.getType() instanceof TypeString and
  (
    a instanceof AssignAddExpr
    or
    exists(VarAccess use | use.getVariable() = v | use.getParent*() = a.getSource()) and
    a.getSource() instanceof AddExpr
  )
}

predicate declaredInLoop(LocalVariableDecl v, LoopStmt loop) {
  exists(LocalVariableDeclExpr e |
    e.getVariable() = v and
    e.getEnclosingStmt().getEnclosingStmt*() = loop.getBody()
  )
  or
  exists(EnhancedForStmt for | for = loop | for.getVariable().getVariable() = v)
}

from Assignment a, Variable v
where
  useAndDef(a, v) and
  exists(LoopStmt loop | a.getEnclosingStmt().getEnclosingStmt*() = loop |
    not declaredInLoop(v, loop)
  )
select a, "The string " + v.getName() + " is built-up in a loop: use string buffer."
