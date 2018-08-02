/**
 * @name Array offset used before range check
 * @description Accessing an array offset before checking the range means that
 *              the program may attempt to read beyond the end of a buffer
 * @kind problem
 * @id cpp/offset-use-before-range-check
 * @problem.severity warning
 * @tags reliability
 *       security
 *       external/cwe/cwe-120
 *       external/cwe/cwe-125
 */

import cpp

from Variable v, LogicalAndExpr andexpr, ArrayExpr access, LTExpr rangecheck
where access.getArrayOffset() = v.getAnAccess()
  and andexpr.getLeftOperand().getAChild() = access
  and andexpr.getRightOperand() = rangecheck
  and rangecheck.getLeftOperand() = v.getAnAccess()
  and not access.isInMacroExpansion()
select access, "This use of offset '" + v.getName() + "' should follow the $@.", rangecheck, "range check"
