/**
 * @name Find the wrong use of the umask function.
 * @description Incorrectly evaluated argument to the umask function may have security implications.
 * @kind problem
 * @id cpp/wrong-use-of-the-umask
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       maintainability
 *       security
 *       external/cwe/cwe-266
 *       external/cwe/cwe-264
 *       external/cwe/cwe-200
 *       external/cwe/cwe-560
 *       external/cwe/cwe-687
 */

import cpp
import semmle.code.cpp.exprs.BitwiseOperation
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/** Holds for a function `f` that has an argument at index `apos` used to set file permissions. */
predicate numberArgumentModFunctions(Function f, int apos) {
  f.hasGlobalOrStdName("umask") and apos = 0
  or
  f.hasGlobalOrStdName("fchmod") and apos = 1
  or
  f.hasGlobalOrStdName("chmod") and apos = 1
}

from FunctionCall fc, string msg
where
  fc.getTarget().hasGlobalOrStdName("umask") and
  fc.getArgument(0).getValue() = "0" and
  not exists(FunctionCall fctmp |
    fctmp.getTarget().hasGlobalOrStdName("umask") and
    globalValueNumber(fctmp.getArgument(0)) != globalValueNumber(fc.getArgument(0))
  ) and
  exists(FunctionCall fctmp |
    (
      fctmp.getTarget().hasGlobalOrStdName("fopen") or
      fctmp.getTarget().hasGlobalOrStdName("open")
    ) and
    fctmp.getNumberOfArguments() = 2 and
    fctmp.getArgument(0).getValue() != "/dev/null"
  ) and
  not exists(FunctionCall fctmp |
    fctmp.getTarget().hasGlobalOrStdName("chmod") or
    fctmp.getTarget().hasGlobalOrStdName("fchmod")
  ) and
  msg = "Using umask (0) may not be safe."
  or
  fc.getTarget().hasGlobalOrStdName("umask") and
  exists(FunctionCall fctmp |
    (
      fctmp.getTarget().hasGlobalOrStdName("chmod") or
      fctmp.getTarget().hasGlobalOrStdName("fchmod")
    ) and
    (
      globalValueNumber(fc.getArgument(0)) = globalValueNumber(fctmp.getArgument(1)) and
      fc.getArgument(0).getValue() != "0"
    ) and
    msg = "not use equal argument in umask and " + fctmp.getTarget().getName() + " functions"
  )
  or
  exists(Expr exptmp, int i |
    numberArgumentModFunctions(fc.getTarget(), i) and
    not exptmp.getAChild*() instanceof FunctionCall and
    not exists(SizeofOperator so | exptmp.getAChild*() = so) and
    not exists(ArrayExpr aetmp | aetmp.getArrayOffset() = exptmp.getAChild*()) and
    exptmp.getAChild*() instanceof BinaryArithmeticOperation and
    not exptmp.getAChild*() instanceof BinaryBitwiseOperation and
    globalValueNumber(exptmp) = globalValueNumber(fc.getArgument(i)) and
    not exptmp.isConstant() and
    msg = "Using arithmetic to compute the mask may not be safe."
  )
select fc, msg
