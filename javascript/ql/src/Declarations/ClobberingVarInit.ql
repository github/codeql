/**
 * @name Conflicting variable initialization
 * @description If a variable is declared and initialized twice inside the same variable declaration
 *              statement, the second initialization immediately overwrites the first one.
 * @kind problem
 * @problem.severity error
 * @id js/variable-initialization-conflict
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-563
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

from DeclStmt vds, VariableDeclarator vd1, VariableDeclarator vd2, int i, int j, Variable v
where
  vd1 = vds.getDecl(i) and
  vd2 = vds.getDecl(j) and
  v = vd1.getBindingPattern().getAVariable() and
  v = vd2.getBindingPattern().getAVariable() and
  i < j and
  // exclude a somewhat common pattern where the first declaration is used as a temporary
  exists(Expr e1, Expr e2 | e1 = vd1.getInit() and e2 = vd2.getInit() |
    not v.getAnAccess().getParentExpr*() = e2
  )
select vd2.(FirstLineOf), "This initialization of " + v.getName() + " overwrites $@.", vd1,
  "an earlier initialization"
