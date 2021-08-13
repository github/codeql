/**
 * @name Signed overflow check
 * @description Testing for overflow by adding a value to a variable
 *              to see if it "wraps around" works only for
 *              unsigned integer values.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id cpp/signed-overflow-check
 * @tags correctness
 *       security
 *       external/cwe/cwe-128
 *       external/cwe/cwe-190
 */

import cpp
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering
private import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
private import semmle.code.cpp.commons.Exclusions

predicate select0(RelationalOperation ro, AddExpr add, Expr expr1, Expr expr2) {
  ro.getAnOperand() = add and
  add.getAnOperand() = expr1 and
  ro.getAnOperand() = expr2 and
  globalValueNumber(expr1) = globalValueNumber(expr2) and
  add.getUnspecifiedType().(IntegralType).isSigned() and
  not isFromMacroDefinition(ro)
}

class Config extends Configuration {
  Config() { this = "SignedOverflowCheckConfig" }

  override predicate isUnconvertedSink(Expr e) { select0(_, e, _, _) }
}

from RelationalOperation ro, AddExpr add
where
  select0(ro, add, _, _) and
  exprMightOverflowPositively(add) and
  exists(Compilation c | c.getAFileCompiled() = ro.getFile() |
    not c.getAnArgument() = "-fwrapv" and
    not c.getAnArgument() = "-fno-strict-overflow"
  )
select ro, "Testing for signed overflow may produce undefined results."
