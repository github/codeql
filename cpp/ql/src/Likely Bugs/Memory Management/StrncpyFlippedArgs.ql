/**
 * @name Possibly wrong buffer size in string copy
 * @description Calling 'strncpy' with the size of the source buffer
 *              as the third argument may result in a buffer overflow.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision medium
 * @id cpp/bad-strncpy-size
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-676
 *       external/cwe/cwe-119
 *       external/cwe/cwe-251
 */

import cpp
import Buffer
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering
private import semmle.code.cpp.models.implementations.Strcpy

predicate isSizePlus(Expr e, BufferSizeExpr baseSize, int plus) {
  // baseSize
  e = baseSize and plus = 0
  or
  exists(AddExpr ae, Expr operand1, Expr operand2, int plusSub |
    // baseSize + n or n + baseSize
    ae = e and
    operand1 = ae.getAnOperand() and
    operand2 = ae.getAnOperand() and
    operand1 != operand2 and
    isSizePlus(operand1, baseSize, plusSub) and
    plus = plusSub + operand2.getValue().toInt()
  )
  or
  exists(SubExpr se, int plusSub |
    // baseSize - n
    se = e and
    isSizePlus(se.getLeftOperand(), baseSize, plusSub) and
    plus = plusSub - se.getRightOperand().getValue().toInt()
  )
}

string nthString(int num) {
  num = 0 and
  result = "first"
  or
  num = 1 and
  result = "second"
  or
  num = 2 and
  result = "third"
}

/**
 * Gets the size of the expression, if it is initialized
 * with a fixed size array.
 */
int arrayExprFixedSize(Expr e) {
  result = e.getUnspecifiedType().(ArrayType).getSize()
  or
  result = e.(NewArrayExpr).getAllocatedType().(ArrayType).getSize()
  or
  exists(SsaDefinition def, LocalVariable v |
    not e.getUnspecifiedType() instanceof ArrayType and
    e = def.getAUse(v) and
    result = arrayExprFixedSize(def.getDefiningValue(v))
  )
}

from
  StrcpyFunction f, FunctionCall fc, int argDest, int argSrc, int argLimit, int charSize,
  Access copyDest, Access copySource, string name, string nth
where
  f = fc.getTarget() and
  argDest = f.getParamDest() and
  argSrc = f.getParamSrc() and
  argLimit = f.getParamSize() and
  copyDest = fc.getArgument(argDest) and
  copySource = fc.getArgument(argSrc) and
  // Some of the functions operate on a larger char type, like `wchar_t`, so we
  // need to take this into account in the fixed size case.
  charSize = f.getParameter(argDest).getUnspecifiedType().(PointerType).getBaseType().getSize() and
  (
    if exists(fc.getArgument(argLimit).getValue().toInt())
    then
      // Fixed sized case
      exists(int size |
        size = arrayExprFixedSize(copyDest) and
        size < charSize * fc.getArgument(argLimit).getValue().toInt() and
        size != 0 // if the array has zero size, something special is going on
      )
    else
      exists(Access takenSizeOf, BufferSizeExpr sizeExpr, int plus |
        // Variable sized case
        sizeExpr = fc.getArgument(argLimit).getAChild*() and
        isSizePlus(fc.getArgument(argLimit), sizeExpr, plus) and
        plus >= 0 and
        takenSizeOf = sizeExpr.getArg() and
        globalValueNumber(copySource) = globalValueNumber(takenSizeOf) and // e.g. strncpy(x, y, strlen(y))
        globalValueNumber(copyDest) != globalValueNumber(takenSizeOf) // e.g. strncpy(y, y, strlen(y))
      )
  ) and
  name = fc.getTarget().getName() and
  nth = nthString(argLimit)
select fc,
  "Potentially unsafe call to " + name + "; " + nth + " argument should be size of destination."
