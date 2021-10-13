/**
 * @name Pointer overflow check
 * @description Adding a value to a pointer to check if it overflows relies
 *              on undefined behavior and may lead to memory corruption.
 * @kind problem
 * @problem.severity error
 * @security-severity 2.1
 * @precision high
 * @id cpp/pointer-overflow-check
 * @tags reliability
 *       security
 *       external/cwe/cwe-758
 */

import cpp
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering
private import semmle.code.cpp.commons.Exclusions

from RelationalOperation ro, PointerAddExpr add, Expr expr1, Expr expr2
where
  ro.getAnOperand() = add and
  add.getAnOperand() = expr1 and
  ro.getAnOperand() = expr2 and
  globalValueNumber(expr1) = globalValueNumber(expr2) and
  // Exclude macros but not their arguments
  not isFromMacroDefinition(ro) and
  // There must be a compilation of this file without a flag that makes pointer
  // overflow well defined.
  exists(Compilation c | c.getAFileCompiled() = ro.getFile() |
    not c.getAnArgument() = "-fwrapv-pointer" and
    not c.getAnArgument() = "-fno-strict-overflow"
  )
select ro, "Range check relying on pointer overflow."
