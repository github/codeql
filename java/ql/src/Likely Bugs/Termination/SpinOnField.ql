/**
 * @name Spin on field
 * @description Repeatedly reading a non-volatile field within the condition of an empty loop may
 *              result in an infinite loop.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/spin-on-field
 * @tags efficiency
 *       correctness
 *       concurrency
 */

import java

/** A numerical comparison or an equality test. */
class ComparisonOrEqTestExpr extends Expr {
  ComparisonOrEqTestExpr() {
    this instanceof ComparisonExpr or
    this instanceof EqualityTest
  }
}

/** An empty statement or block. */
class Empty extends Stmt {
  Empty() {
    this instanceof EmptyStmt or
    this.(BlockStmt).getNumStmt() = 0
  }
}

/** An empty loop statement. */
class EmptyLoop extends Stmt {
  EmptyLoop() {
    exists(ForStmt stmt | stmt = this |
      count(stmt.getAnInit()) = 0 and
      count(stmt.getAnUpdate()) = 0 and
      stmt.getStmt() instanceof Empty
    )
    or
    this.(WhileStmt).getStmt() instanceof Empty
    or
    this.(DoStmt).getStmt() instanceof Empty
  }

  Expr getCondition() {
    result = this.(ForStmt).getCondition() or
    result = this.(WhileStmt).getCondition() or
    result = this.(DoStmt).getCondition()
  }
}

/** An access to a field in this object. */
class FieldAccessInThis extends VarAccess {
  FieldAccessInThis() {
    this.getVariable() instanceof Field and
    (not this.hasQualifier() or this.getQualifier() instanceof ThisAccess)
  }
}

from EmptyLoop loop, FieldAccessInThis access, Field field, ComparisonOrEqTestExpr expr
where
  loop.getCondition() = expr and
  access.getParent() = expr and
  field = access.getVariable() and
  field.isStatic() and
  not field.isFinal() and
  not field.isVolatile() and
  field.getType() instanceof RefType
select access,
  "Spinning on " + field.getName() + " in " + loop.getEnclosingCallable().getName() + "."
