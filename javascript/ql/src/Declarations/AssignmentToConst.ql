/**
 * @name Assignment to constant
 * @description Assigning to a variable that is declared 'const' has either no effect or leads to a
 *              runtime error, depending on the platform.
 * @kind problem
 * @problem.severity error
 * @id js/assignment-to-constant
 * @tags reliability
 *       correctness
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

from DeclStmt cds, VariableDeclarator decl, VarDef def, Variable v
where
  (cds instanceof ConstDeclStmt or cds instanceof UsingDeclStmt) and
  decl = cds.getADecl() and
  def.getAVariable() = v and
  decl.getBindingPattern().getAVariable() = v and
  def != decl and
  def.(ExprOrStmt).getTopLevel() = decl.getTopLevel()
select def.(FirstLineOf), "Assignment to variable " + v.getName() + ", which is $@ constant.", cds,
  "declared"
