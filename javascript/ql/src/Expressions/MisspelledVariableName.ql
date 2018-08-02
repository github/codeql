/**
 * @name Misspelled variable name
 * @description Misspelling a variable name implicitly introduces a global
 *              variable, which may not lead to a runtime error, but is
 *              likely to give wrong results.
 * @kind problem
 * @problem.severity warning
 * @id js/misspelled-variable-name
 * @tags maintainability
 *       readability
 *       correctness
 * @precision very-high
 */

import Misspelling

from GlobalVarAccess gva, VarDecl lvd
where misspelledVariableName(gva, lvd)
select gva, "'" + gva + "' may be a typo for variable $@.", lvd, lvd.getName()
