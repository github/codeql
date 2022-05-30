/**
 * @name Dangerous use malloc with zero size.
 * @description The behavior of the malloc function is not defined when the size value is zero.
 * @kind problem
 * @id cpp/dangerous-use-malloc-with-zero-size
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-758
 */

import cpp
import semmle.code.cpp.commons.Exclusions
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/** Holds if there is a bitwise operation, initialization, assignment or test of the first function argument. */
predicate existsChecksorSet(FunctionCall fc) {
  (
    exists(AssignBitwiseOperation ab |
      ab.getLValue().(VariableAccess).getTarget() = fc.getArgument(0).(VariableAccess).getTarget() and
      ab.getASuccessor*() = fc
    )
    or
    exists(Initializer it |
      fc.getArgument(0).(VariableAccess).getTarget().getInitializer() = it and
      (
        it.getExpr().getAChild*() instanceof AddExpr or
        it.getExpr().isConstant()
      )
    )
    or
    exists(Assignment ae |
      ae.getLValue().(VariableAccess).getTarget() = fc.getArgument(0).(VariableAccess).getTarget() and
      (
        ae.getRValue().getAChild*() instanceof AddExpr or
        ae.getRValue().isConstant()
      ) and
      ae.getASuccessor*() = fc
    )
    or
    exists(IfStmt ifs, ComparisonOperation co, Expr ec |
      ifs.getCondition().getAChild*() = co and
      co.hasOperands(fc.getArgument(0).(VariableAccess).getTarget().getAnAccess(), ec) and
      exists(Expr etmp |
        etmp.getValue() = ["0", "1"] and
        (
          ec = etmp or
          globalValueNumber(ec) = globalValueNumber(etmp)
        )
      )
    )
  )
}

/** Holds if the function within which the call is found is not called elsewhere. */
predicate enclosingFunctionNotCall(FunctionCall fc) {
  exists(Function fn |
    fn = fc.getEnclosingFunction() and
    not exists(fn.getACallToThisFunction()) and
    fn.getAParameter().getAnAccess() = fc.getArgument(0) and
    not exists(TemplateClass tc | tc.getACanonicalMemberFunction() = fn)
  )
}

/** Holds if the return value of the function or the first argument is used in string functions or arrays. */
predicate dangerousUseBufferAndSize(FunctionCall fc) {
  exists(Expr e0 |
    fc.getASuccessor*() = e0 and
    (
      // When the return value is used as the basis of an array, the first argument is part of that array's offset expression.
      globalValueNumber(e0.(ArrayExpr).getArrayBase()) = globalValueNumber(fc) and
      e0.(ArrayExpr).getArrayOffset().getAChild().(VariableAccess).getTarget() =
        fc.getArgument(0).(VariableAccess).getTarget()
      or
      // When the return value is used as an argument to string functions.
      e0.(FunctionCall).getTarget().hasGlobalOrStdName(["strstr", "strlen", "strcpy", "strcat"]) and
      (
        globalValueNumber(e0.(FunctionCall).getAnArgument()) = globalValueNumber(fc)
        or
        exists(Assignment aetmp, Assignment ae1tmp |
          aetmp.getLValue().(VariableAccess).getTarget() =
            e0.(FunctionCall).getAnArgument().(VariableAccess).getTarget() and
          ae1tmp.getRValue() = fc and
          aetmp.getRValue().(VariableAccess).getTarget() =
            ae1tmp.getLValue().(VariableAccess).getTarget() and
          aetmp.getASuccessor*() = e0
        )
      )
    )
  )
}

/** Holds if this function is `fread` and its argument is `exp`. */
predicate thisFunctionFread(FunctionCall fc, Expr exp) {
  fc.getTarget().hasGlobalOrStdName("fread") and
  globalValueNumber(fc.getArgument(0)) = globalValueNumber(exp)
}

/** Holds if the value of the first function argument `fc` depends on the result of calling another function. */
predicate lengthMayBeEquealZero(FunctionCall fc) {
  exists(FunctionCall ftmp |
    ftmp.getASuccessor*() = fc and
    (
      globalValueNumber(fc.getArgument(0)) = globalValueNumber(ftmp) and
      // Function can return zero.
      exists(Expr erttmp, Expr etmp |
        erttmp.getEnclosingStmt() instanceof ReturnStmt and
        ftmp.getTarget().getEntryPoint().getASuccessor*() = erttmp and
        (
          thisFunctionFread(etmp.(FunctionCall), erttmp)
          or
          erttmp.getValue() = "0"
          or
          etmp.(AssignExpr).getLValue().(VariableAccess).getTarget() =
            erttmp.(VariableAccess).getTarget() and
          etmp.(AssignExpr).getRValue().getValue() = "0" and
          not exists(VariableAccess vatmp |
            vatmp.getTarget() = erttmp.(VariableAccess).getTarget() and
            vatmp.getEnclosingStmt() != etmp.getEnclosingStmt() and
            vatmp.getEnclosingStmt() != erttmp.getEnclosingStmt() and
            etmp.getASuccessor+() = vatmp
          )
        )
      )
      or
      // Function related to reading from a file.
      exists(int i, Expr etmp |
        fc.getArgument(0).(VariableAccess).getTarget() =
          ftmp.getArgument(i).(AddressOfExpr).getAnOperand().(VariableAccess).getTarget() and
        ftmp.getTarget().getParameter(i).getAnAccess() = etmp and
        // The length parameter is associated with the fread call.
        exists(AssignExpr aetmp, FunctionCall f1tmp |
          aetmp.getLValue().getAChild*() = etmp and
          aetmp.getRValue() = f1tmp and
          exists(Expr erttmp, FunctionCall f2tmp |
            erttmp.getEnclosingStmt() instanceof ReturnStmt and
            f1tmp.getTarget().getEntryPoint().getASuccessor*() = f2tmp and
            thisFunctionFread(f2tmp, erttmp)
          )
        )
      )
    )
  )
}

from FunctionCall fc, string msg
where
  fc.getTarget().hasGlobalOrStdName(["malloc", "kmalloc"]) and
  fc.getArgument(0) instanceof VariableAccess and
  not existsChecksorSet(fc) and
  (
    enclosingFunctionNotCall(fc) and
    msg =
      "The length parameter for the function of the memory allocation function is passed from outside and is not checked for equality zero."
    or
    lengthMayBeEquealZero(fc) and
    msg =
      "The length of the memory allocation function parameter is related to the call to the read from file function or can be equal to zero."
  ) and
  dangerousUseBufferAndSize(fc)
select fc, msg
