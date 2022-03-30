/**
 * @name Duplicate variable declaration
 * @description A variable declaration statement that declares the same variable twice is
 *              confusing and hard to maintain.
 * @kind problem
 * @problem.severity recommendation
 * @id js/duplicate-variable-declaration
 * @tags maintainability
 * @precision very-high
 */

import javascript

from DeclStmt vds, VariableDeclarator vd1, int i, VariableDeclarator vd2, int j, Variable v
where
  vd1 = vds.getDecl(i) and
  vd2 = vds.getDecl(j) and
  vd1.getBindingPattern().getAVariable() = v and
  vd2.getBindingPattern().getAVariable() = v and
  i < j
select vd2, "Variable " + v.getName() + " has already been declared $@.", vd1, "here"
