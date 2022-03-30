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

/**
 * An expression that is either a `BinaryArithmeticOperation` or the result of one or more `BinaryBitwiseOperation`s on a `BinaryArithmeticOperation`. For example `1 | (2 + 3)`.
 */
class ContainsArithmetic extends Expr {
  ContainsArithmetic() {
    this instanceof BinaryArithmeticOperation
    or
    // recursive search into `Operation`s
    this.(BinaryBitwiseOperation).getAnOperand() instanceof ContainsArithmetic
  }
}

/** Holds for a function `f` that has an argument at index `apos` used to set file permissions. */
predicate numberArgumentModFunctions(Function f, int apos) {
  f.hasGlobalOrStdName("umask") and apos = 0
  or
  f.hasGlobalOrStdName("fchmod") and apos = 1
  or
  f.hasGlobalOrStdName("chmod") and apos = 1
}

from FunctionCall fc, string msg, FunctionCall fcsnd
where
  fc.getTarget().hasGlobalOrStdName("umask") and
  fc.getArgument(0).getValue() = "0" and
  not exists(FunctionCall fctmp |
    fctmp.getTarget().hasGlobalOrStdName("umask") and
    not fctmp.getArgument(0).getValue() = "0"
  ) and
  exists(FunctionCall fctmp |
    (
      fctmp.getTarget().hasGlobalOrStdName("fopen") or
      fctmp.getTarget().hasGlobalOrStdName("open")
    ) and
    (
      fctmp.getArgument(1).getValue().matches("%a%") or
      fctmp.getArgument(1).getValue().matches("%w%") or
      // unfortunately cannot use numeric value here because // O_CREAT is defined differently on different OSes:
      // https://github.com/red/red/blob/92feb0c0d5f91e087ab35fface6906afbf99b603/runtime/definitions.reds#L477-L491
      // this may introduce false negatives
      fctmp.getArgument(1).(BitwiseOrExpr).getAChild*().getValueText().matches("O_CREAT") or
      fctmp.getArgument(1).getValueText().matches("%O_CREAT%")
    ) and
    fctmp.getNumberOfArguments() = 2 and
    not fctmp.getArgument(0).getValue() = "/dev/null" and
    fcsnd = fctmp
  ) and
  not exists(FunctionCall fctmp |
    fctmp.getTarget().hasGlobalOrStdName("chmod") or
    fctmp.getTarget().hasGlobalOrStdName("fchmod")
  ) and
  msg = "Using umask(0) may not be safe with call $@."
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
    msg = "Not use equal argument in umask and $@ functions." and
    fcsnd = fctmp
  )
  or
  exists(ContainsArithmetic exptmp, int i |
    numberArgumentModFunctions(fc.getTarget(), i) and
    globalValueNumber(exptmp) = globalValueNumber(fc.getArgument(i)) and
    msg = "Using arithmetic to compute the mask in $@ may not be safe." and
    fcsnd = fc
  )
select fc, msg, fcsnd, fcsnd.getTarget().getName()
