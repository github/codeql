/**
 * @name Dangerous use mbtowc.
 * @description Using function mbtowc with an invalid length argument can result in an out-of-bounds access error or unexpected result.
 * @kind problem
 * @id cpp/dangerous-use-mbtowc
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-125
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/** Holds if there are indications that the variable is treated as a string. */
predicate exprMayBeString(Expr exp) {
  (
    exists(StringLiteral sl | globalValueNumber(exp) = globalValueNumber(sl))
    or
    exists(FunctionCall fctmp |
      (
        fctmp.getAnArgument().(VariableAccess).getTarget() = exp.(VariableAccess).getTarget() or
        globalValueNumber(fctmp.getAnArgument()) = globalValueNumber(exp)
      ) and
      fctmp.getTarget().hasGlobalOrStdName(["strlen", "strcat", "strncat", "strcpy", "sptintf"])
    )
    or
    exists(AssignExpr astmp |
      astmp.getRValue().getValue() = "0" and
      astmp.getLValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() =
        exp.(VariableAccess).getTarget()
    )
    or
    exists(ComparisonOperation cotmp, Expr exptmp1, Expr exptmp2 |
      exptmp1.getValue() = "0" and
      (
        exptmp2.(PointerDereferenceExpr).getOperand().(VariableAccess).getTarget() =
          exp.(VariableAccess).getTarget() or
        exptmp2.(ArrayExpr).getArrayBase().(VariableAccess).getTarget() =
          exp.getAChild().(VariableAccess).getTarget()
      ) and
      cotmp.hasOperands(exptmp1, exptmp2)
    )
  )
}

/** Holds if expression is constant or operator call `sizeof`. */
predicate argConstOrSizeof(Expr exp) {
  exp.getValue().toInt() > 1 or
  exp.(SizeofTypeOperator).getTypeOperand().getSize() > 1
}

/** Holds if expression is macro. */
predicate argMacro(Expr exp) {
  exists(MacroInvocation matmp |
    exp = matmp.getExpr() and
    (
      matmp.getMacroName() = "MB_LEN_MAX" or
      matmp.getMacroName() = "MB_CUR_MAX"
    )
  )
}

from FunctionCall fc, string msg
where
  exists(Loop lptmp | lptmp = fc.getEnclosingStmt().getParentStmt*()) and
  fc.getTarget().hasGlobalOrStdName(["mbtowc", "mbrtowc"]) and
  not fc.getArgument(0).isConstant() and
  not fc.getArgument(1).isConstant() and
  (
    exprMayBeString(fc.getArgument(1)) and
    argConstOrSizeof(fc.getArgument(2)) and
    fc.getArgument(2).getValue().toInt() < 5 and
    not argMacro(fc.getArgument(2)) and
    msg = "Size can be less than maximum character length, use macro MB_CUR_MAX."
    or
    not exprMayBeString(fc.getArgument(1)) and
    (
      argConstOrSizeof(fc.getArgument(2))
      or
      argMacro(fc.getArgument(2))
      or
      exists(DecrementOperation dotmp |
        globalValueNumber(dotmp.getAnOperand()) = globalValueNumber(fc.getArgument(2)) and
        not exists(AssignSubExpr aetmp |
          (
            aetmp.getLValue().(VariableAccess).getTarget() =
              fc.getArgument(2).(VariableAccess).getTarget() or
            globalValueNumber(aetmp.getLValue()) = globalValueNumber(fc.getArgument(2))
          ) and
          globalValueNumber(aetmp.getRValue()) = globalValueNumber(fc)
        )
      )
    ) and
    msg =
      "Access beyond the allocated memory is possible, the length can change without changing the pointer."
    or
    exists(AssignPointerAddExpr aetmp |
      (
        aetmp.getLValue().(VariableAccess).getTarget() =
          fc.getArgument(0).(VariableAccess).getTarget() or
        globalValueNumber(aetmp.getLValue()) = globalValueNumber(fc.getArgument(0))
      ) and
      globalValueNumber(aetmp.getRValue()) = globalValueNumber(fc)
    ) and
    msg = "Maybe you're using the function's return value incorrectly."
  )
select fc, msg
