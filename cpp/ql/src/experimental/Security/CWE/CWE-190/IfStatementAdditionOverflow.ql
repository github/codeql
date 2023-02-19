/**
 * @name Integer addition may overflow inside condition
 * @description Detects "c-b" when the condition "a+b>c" has been imposed,
 *              which is not the same as the condition "a>b-c" if "a+b"
 *              overflows. Rewriting improves readability and optimizability
 *              (CSE elimination). Also detects "b+a>c" (swapped terms in
 *              addition), "c<a+b" (swapped operands), and  ">=", "<",
 *              "<=" instead of ">" (all operators). This integer overflow
 *              is the root cause of the buffer overflow in the SHA-3
 *              reference implementation (CVE-2022-37454).
 * @kind problem
 * @problem.severity warning
 * @id cpp/if-statement-addition-overflow
 * @tags: experimental
 *        correctness
 *        security
 *        external/cwe/cwe-190
 */

import cpp
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.commons.Exclusions

from GuardCondition guard, BasicBlock block, RelationalOperation relop, AddExpr addexpr, SubExpr subexpr
where guard.controls(block, _) and
  guard.getAChild*() = relop and
  pragma[only_bind_into](block) = subexpr.getBasicBlock() and
  relop.getAnOperand() = addexpr and
  addexpr.getUnspecifiedType() instanceof IntegralType and
  not isFromMacroDefinition(relop) and
  exprMightOverflowPositively(addexpr) and
  globalValueNumber(addexpr.getAnOperand()) = globalValueNumber(subexpr.getRightOperand()) and
  globalValueNumber(relop.getAnOperand()) = globalValueNumber(subexpr.getLeftOperand())
select guard, "Integer addition may overflow inside condition."
