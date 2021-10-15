/**
 * @name Arguments redefined
 * @description The special 'arguments' variable can be redefined, but this should be avoided
 *              since it makes code hard to read and maintain and may prevent compiler
 *              optimizations.
 * @kind problem
 * @problem.severity recommendation
 * @id js/arguments-redefinition
 * @tags efficiency
 *       maintainability
 * @precision very-high
 */

import javascript
import Definitions

from VarRef d
where
  d.getVariable().(LocalVariable).getName() = "arguments" and
  (d instanceof LValue or d instanceof VarDecl) and
  not d.isAmbient() and
  not d.inExternsFile()
select d, "Redefinition of arguments."
