/**
 * @name Late Check Of Function Argument
 * @description --Checking the function argument after calling the function itself.
 *              --This situation looks suspicious and requires the attention of the developer.
 *              --It may be necessary to add validation before calling the function.
 * @kind problem
 * @id cpp/late-check-of-function-argument
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/** Holds for a function `f` that has an argument at index `apos` used for positioning in a buffer. */
predicate numberArgument(Function f, int apos) {
  f.hasGlobalOrStdName("write") and apos = 2
  or
  f.hasGlobalOrStdName("read") and apos = 2
  or
  f.hasGlobalOrStdName("lseek") and apos = 1
  or
  f.hasGlobalOrStdName("memmove") and apos = 2
  or
  f.hasGlobalOrStdName("memset") and apos = 2
  or
  f.hasGlobalOrStdName("memcpy") and apos = 2
  or
  f.hasGlobalOrStdName("memcmp") and apos = 2
  or
  f.hasGlobalOrStdName("strncat") and apos = 2
  or
  f.hasGlobalOrStdName("strncpy") and apos = 2
  or
  f.hasGlobalOrStdName("strncmp") and apos = 2
  or
  f.hasGlobalOrStdName("snprintf") and apos = 1
  or
  f.hasGlobalOrStdName("strndup") and apos = 2
}

class IfCompareWithZero extends IfStmt {
  IfCompareWithZero() { this.getCondition().(RelationalOperation).getAChild().getValue() = "0" }

  Expr noZerroOperand() {
    if this.getCondition().(RelationalOperation).getGreaterOperand().getValue() = "0"
    then result = this.getCondition().(RelationalOperation).getLesserOperand()
    else result = this.getCondition().(RelationalOperation).getGreaterOperand()
  }
}

from FunctionCall fc, IfCompareWithZero ifc, int na
where
  numberArgument(fc.getTarget(), na) and
  globalValueNumber(fc.getArgument(na)) = globalValueNumber(ifc.noZerroOperand()) and
  dominates(fc, ifc) and
  not exists(IfStmt ifc1 |
    dominates(ifc1, fc) and
    globalValueNumber(fc.getArgument(na)) = globalValueNumber(ifc1.getCondition().getAChild*())
  )
select fc,
  "The value of argument '$@' appears to be checked after the call, rather than before it.",
  fc.getArgument(na), fc.getArgument(na).toString()
