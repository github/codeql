/**
 * @name Dangerous use convert function.
 * @description Using convert function with an invalid length argument can result in an out-of-bounds access error or unexpected result.
 * @kind problem
 * @id cpp/dangerous-use-convert-function
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       experimental
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
      fctmp.getTarget().hasName(["strlen", "strcat", "strncat", "strcpy", "sprintf", "printf"])
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

/** Holds if erroneous situations of using functions `mbtowc` and `mbrtowc` are detected. */
predicate findUseCharacterConversion(Expr exp, string msg) {
  exists(FunctionCall fc |
    fc = exp and
    (
      fc.getEnclosingStmt().getParentStmt*() instanceof Loop and
      fc.getTarget().hasName(["mbtowc", "mbrtowc", "_mbtowc_l"]) and
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
    )
  )
}

/** Holds if detecting erroneous situations of working with multibyte characters. */
predicate findUseMultibyteCharacter(Expr exp, string msg) {
  exists(ArrayType arrayType, ArrayExpr arrayExpr |
    arrayExpr = exp and
    arrayExpr.getArrayBase().getType() = arrayType and
    (
      exists(AssignExpr assZero, SizeofExprOperator sizeofArray, Expr oneValue |
        oneValue.getValue() = "1" and
        sizeofArray.getExprOperand().getType() = arrayType and
        assZero.getLValue() = arrayExpr and
        arrayExpr.getArrayOffset().(SubExpr).hasOperands(sizeofArray, oneValue) and
        assZero.getRValue().getValue() = "0"
      ) and
      arrayType.getArraySize() != arrayType.getByteSize() and
      msg =
        "The size of the array element is greater than one byte, so the offset will point outside the array."
      or
      exists(FunctionCall mbFunction |
        (
          mbFunction.getTarget().getName().matches("_mbs%") or
          mbFunction.getTarget().getName().matches("mbs%") or
          mbFunction.getTarget().getName().matches("_mbc%") or
          mbFunction.getTarget().getName().matches("mbc%")
        ) and
        mbFunction.getAnArgument().(VariableAccess).getTarget().getADeclarationEntry().getType() =
          arrayType
      ) and
      exists(Loop loop, SizeofExprOperator sizeofArray, AssignExpr assignExpr |
        arrayExpr.getEnclosingStmt().getParentStmt*() = loop and
        sizeofArray.getExprOperand().getType() = arrayType and
        assignExpr.getLValue() = arrayExpr and
        loop.getCondition().(LTExpr).getLeftOperand().(VariableAccess).getTarget() =
          arrayExpr.getArrayOffset().getAChild*().(VariableAccess).getTarget() and
        loop.getCondition().(LTExpr).getRightOperand() = sizeofArray
      ) and
      msg =
        "This buffer may contain multibyte characters, so attempting to copy may result in part of the last character being lost."
    )
  )
  or
  exists(FunctionCall mbccpy, Loop loop, SizeofExprOperator sizeofOp |
    mbccpy.getTarget().hasName("_mbccpy") and
    mbccpy.getArgument(0) = exp and
    exp.getEnclosingStmt().getParentStmt*() = loop and
    sizeofOp.getExprOperand().getType() =
      exp.getAChild*().(VariableAccess).getTarget().getADeclarationEntry().getType() and
    loop.getCondition().(LTExpr).getLeftOperand().(VariableAccess).getTarget() =
      exp.getAChild*().(VariableAccess).getTarget() and
    loop.getCondition().(LTExpr).getRightOperand() = sizeofOp and
    msg =
      "This buffer may contain multibyte characters, so an attempt to copy may result in an overflow."
  )
}

/** Holds if erroneous situations of using functions `MultiByteToWideChar` and `WideCharToMultiByte` or `mbstowcs` and `_mbstowcs_l` and `mbsrtowcs` are detected. */
predicate findUseStringConversion(
  Expr exp, string msg, int posBufSrc, int posBufDst, int posSizeDst, string nameCalls
) {
  exists(FunctionCall fc |
    fc = exp and
    posBufSrc in [0 .. fc.getNumberOfArguments() - 1] and
    posSizeDst in [0 .. fc.getNumberOfArguments() - 1] and
    (
      fc.getTarget().hasName(nameCalls) and
      (
        globalValueNumber(fc.getArgument(posBufDst)) = globalValueNumber(fc.getArgument(posBufSrc)) and
        msg =
          "According to the definition of the functions, if the source buffer and the destination buffer are the same, undefined behavior is possible."
        or
        exists(ArrayType arrayDst |
          fc.getArgument(posBufDst).(VariableAccess).getTarget().getADeclarationEntry().getType() =
            arrayDst and
          fc.getArgument(posSizeDst).getValue().toInt() >= arrayDst.getArraySize() and
          not exists(AssignExpr assZero |
            assZero.getLValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() =
              fc.getArgument(posBufDst).(VariableAccess).getTarget() and
            assZero.getRValue().getValue() = "0"
          ) and
          not exists(Expr someExp, FunctionCall checkSize |
            checkSize.getASuccessor*() = fc and
            checkSize.getTarget().hasName(nameCalls) and
            checkSize.getArgument(posSizeDst).getValue() = "0" and
            globalValueNumber(checkSize) = globalValueNumber(someExp) and
            someExp.getEnclosingStmt().getParentStmt*() instanceof IfStmt
          ) and
          exprMayBeString(fc.getArgument(posBufDst)) and
          msg =
            "According to the definition of the functions, it is not guaranteed to write a null character at the end of the string, so access beyond the bounds of the destination buffer is possible."
        )
        or
        exists(FunctionCall allocMem |
          allocMem.getTarget().hasName(["calloc", "malloc"]) and
          globalValueNumber(fc.getArgument(posBufDst)) = globalValueNumber(allocMem) and
          (
            allocMem.getArgument(allocMem.getNumberOfArguments() - 1).getValue() = "1" or
            not exists(SizeofOperator sizeofOperator |
              globalValueNumber(allocMem
                    .getArgument(allocMem.getNumberOfArguments() - 1)
                    .getAChild*()) = globalValueNumber(sizeofOperator)
            )
          ) and
          msg =
            "The buffer destination has a type other than char, you need to take this into account when allocating memory."
        )
        or
        fc.getArgument(posBufDst).getValue() = "0" and
        fc.getArgument(posSizeDst).getValue() != "0" and
        msg =
          "If the destination buffer is NULL and its size is not 0, then undefined behavior is possible."
      )
    )
  )
}

from Expr exp, string msg
where
  findUseCharacterConversion(exp, msg) or
  findUseMultibyteCharacter(exp, msg) or
  findUseStringConversion(exp, msg, 1, 0, 2, ["mbstowcs", "_mbstowcs_l", "mbsrtowcs"]) or
  findUseStringConversion(exp, msg, 2, 4, 5, ["MultiByteToWideChar", "WideCharToMultiByte"])
select exp, msg
