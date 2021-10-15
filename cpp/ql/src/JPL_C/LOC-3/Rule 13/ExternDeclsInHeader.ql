/**
 * @name "extern" declaration in source file
 * @description All "extern" declarations should be placed in a header file that is included in every file referring to the corresponding data object.
 * @kind problem
 * @id cpp/jpl-c/extern-decls-in-header
 * @problem.severity warning
 * @tags maintainability
 *       external/jpl
 */

import cpp

from VariableDeclarationEntry v
where
  v.getVariable() instanceof GlobalVariable and
  v.hasSpecifier("extern") and
  not v.getFile() instanceof HeaderFile
select v, v.getName() + " should be declared only in a header file that is included as needed."
