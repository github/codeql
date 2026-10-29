/**
 * @name Divide by zero using return value
 * @description Possible cases of division by zero when using the return value from functions.
 * @kind problem
 * @id cpp/divide-by-zero-using-return-value
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-369
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.controlflow.Guards

/** Holds if function `fn` can return a value equal to value `val` */
predicate mayBeReturnValue(Function fn, float val) {
  exists(Expr tmpExp, ReturnStmt rs |
    tmpExp.getValue().toFloat() = val and
    rs.getEnclosingFunction() = fn and
    (
      globalValueNumber(rs.getExpr()) = globalValueNumber(tmpExp)
      or
      exists(AssignExpr ae |
        ae.getLValue().(VariableAccess).getTarget() =
          globalValueNumber(rs.getExpr()).getAnExpr().(VariableAccess).getTarget() and
        globalValueNumber(ae.getRValue()) = globalValueNumber(tmpExp)
      )
      or
      exists(Initializer it |
        globalValueNumber(it.getExpr()) = globalValueNumber(tmpExp) and
        it.getDeclaration().(Variable).getAnAccess().getTarget() =
          globalValueNumber(rs.getExpr()).getAnExpr().(VariableAccess).getTarget()
      )
    )
  )
}

/** Holds if function `fn` can return a value equal zero */
predicate mayBeReturnZero(Function fn) {
  mayBeReturnValue(fn, 0)
  or
  fn.hasName([
      "iswalpha", "iswlower", "iswprint", "iswspace", "iswblank", "iswupper", "iswcntrl",
      "iswctype", "iswalnum", "iswgraph", "iswxdigit", "iswdigit", "iswpunct", "isblank", "isupper",
      "isgraph", "isalnum", "ispunct", "islower", "isspace", "isprint", "isxdigit", "iscntrl",
      "isdigit", "isalpha", "timespec_get", "feof", "atomic_is_lock_free",
      "atomic_compare_exchange", "thrd_equal", "isfinite", "islessequal", "isnan", "isgreater",
      "signbit", "isinf", "islessgreater", "isnormal", "isless", "isgreaterequal", "isunordered",
      "ferror"
    ])
  or
  fn.hasName([
      "thrd_sleep", "feenv", "feholdexcept", "feclearexcept", "feexceptflag", "feupdateenv",
      "remove", "fflush", "setvbuf", "fgetpos", "fsetpos", "fclose", "rename", "fseek", "raise"
    ])
  or
  fn.hasName(["tss_get", "gets"])
  or
  fn.hasName(["getc", "atoi"])
}

/** Gets the Guard which compares the expression `bound` */
pragma[inline]
GuardCondition checkByValue(Expr bound, Expr val) {
  exists(GuardCondition gc |
    (
      gc.ensuresEq(bound, val, _, _, _) or
      gc.ensuresEq(val, bound, _, _, _) or
      gc.ensuresLt(bound, val, _, _, _) or
      gc.ensuresLt(val, bound, _, _, _) or
      gc = globalValueNumber(bound).getAnExpr()
    ) and
    result = gc
  )
}

/** Holds if there are no comparisons between the value returned by possible function calls `compArg` and the value `valArg`, or when these comparisons do not exclude equality to the value `valArg`. */
pragma[inline]
predicate compareFunctionWithValue(Expr guardExp, Function compArg, Expr valArg) {
  not exists(Expr exp |
    exp.getAChild*() = globalValueNumber(compArg.getACallToThisFunction()).getAnExpr() and
    checkByValue(exp, valArg).controls(guardExp.getBasicBlock(), _)
  )
  or
  exists(GuardCondition gc |
    (
      gc.ensuresEq(globalValueNumber(compArg.getACallToThisFunction()).getAnExpr(), valArg, 0,
        guardExp.getBasicBlock(), true)
      or
      gc.ensuresEq(valArg, globalValueNumber(compArg.getACallToThisFunction()).getAnExpr(), 0,
        guardExp.getBasicBlock(), true)
      or
      gc.ensuresLt(globalValueNumber(compArg.getACallToThisFunction()).getAnExpr(), valArg, 0,
        guardExp.getBasicBlock(), false)
      or
      gc.ensuresLt(valArg, globalValueNumber(compArg.getACallToThisFunction()).getAnExpr(), 0,
        guardExp.getBasicBlock(), false)
    )
    or
    exists(Expr exp |
      exp.getValue().toFloat() > valArg.getValue().toFloat() and
      gc.ensuresLt(globalValueNumber(compArg.getACallToThisFunction()).getAnExpr(), exp, 0,
        guardExp.getBasicBlock(), true)
      or
      exp.getValue().toFloat() < valArg.getValue().toFloat() and
      gc.ensuresLt(exp, globalValueNumber(compArg.getACallToThisFunction()).getAnExpr(), 0,
        guardExp.getBasicBlock(), true)
    )
  )
  or
  valArg.getValue().toFloat() = 0 and
  exists(NotExpr ne, IfStmt ifne |
    ne.getOperand() = globalValueNumber(compArg.getACallToThisFunction()).getAnExpr() and
    ifne.getCondition() = ne and
    ifne.getThen().getAChild*() = guardExp
  )
}

/** Wraping predicate for call `compareFunctionWithValue`. */
pragma[inline]
predicate checkConditions1(Expr div, Function fn, float changeInt) {
  exists(Expr val |
    val.getEnclosingFunction() = fn and
    val.getValue().toFloat() = changeInt and
    compareFunctionWithValue(div, fn, val)
  )
}

/** Holds if there are no comparisons between the value `compArg` and the value `valArg`, or when these comparisons do not exclude equality to the value `valArg`. */
pragma[inline]
predicate compareExprWithValue(Expr guardExp, Expr compArg, Expr valArg) {
  not exists(Expr exp |
    exp.getAChild*() = globalValueNumber(compArg).getAnExpr() and
    checkByValue(exp, valArg).controls(guardExp.getBasicBlock(), _)
  )
  or
  exists(GuardCondition gc |
    (
      gc.ensuresEq(globalValueNumber(compArg).getAnExpr(), valArg, 0, guardExp.getBasicBlock(), true)
      or
      gc.ensuresEq(valArg, globalValueNumber(compArg).getAnExpr(), 0, guardExp.getBasicBlock(), true)
      or
      gc.ensuresLt(globalValueNumber(compArg).getAnExpr(), valArg, 0, guardExp.getBasicBlock(),
        false)
      or
      gc.ensuresLt(valArg, globalValueNumber(compArg).getAnExpr(), 0, guardExp.getBasicBlock(),
        false)
    )
    or
    exists(Expr exp |
      exp.getValue().toFloat() > valArg.getValue().toFloat() and
      gc.ensuresLt(globalValueNumber(compArg).getAnExpr(), exp, 0, guardExp.getBasicBlock(), true)
      or
      exp.getValue().toFloat() < valArg.getValue().toFloat() and
      gc.ensuresLt(exp, globalValueNumber(compArg).getAnExpr(), 0, guardExp.getBasicBlock(), true)
    )
  )
  or
  valArg.getValue().toFloat() = 0 and
  exists(NotExpr ne, IfStmt ifne |
    ne.getOperand() = globalValueNumber(compArg).getAnExpr() and
    ifne.getCondition() = ne and
    ifne.getThen().getAChild*() = guardExp
  )
}

/** Wraping predicate for call `compareExprWithValue`. */
pragma[inline]
predicate checkConditions2(Expr div, Expr divVal, float changeInt2) {
  exists(Expr val |
    (
      val.getEnclosingFunction() =
        div.getEnclosingFunction().getACallToThisFunction().getEnclosingFunction() or
      val.getEnclosingFunction() = div.getEnclosingFunction()
    ) and
    val.getValue().toFloat() = changeInt2 and
    compareExprWithValue(div, divVal, val)
  )
}

/** Gets the value of the difference or summand from the expression `src`. */
float getValueOperand(Expr src, Expr e1, Expr e2) {
  src.(SubExpr).hasOperands(e1, e2) and
  result = e2.getValue().toFloat()
  or
  src.(AddExpr).hasOperands(e1, e2) and
  result = -e2.getValue().toFloat()
}

/** Function the return of the expression `e1` and the multiplication operands, or the left operand of division if `e1` contains a multiplication or division, respectively. */
Expr getMulDivOperand(Expr e1) {
  result = e1 or
  result = e1.(MulExpr).getAnOperand() or
  result = e1.(DivExpr).getLeftOperand()
}

/** The class that defines possible variants of the division expression or the search for the remainder. */
class MyDiv extends Expr {
  MyDiv() {
    this instanceof DivExpr or
    this instanceof RemExpr or
    this instanceof AssignDivExpr or
    this instanceof AssignRemExpr
  }

  Expr getRV() {
    result = this.(AssignArithmeticOperation).getRValue() or
    result = this.(BinaryArithmeticOperation).getRightOperand()
  }
}

from Expr exp, string msg, Function fn, GVN findVal, float changeInt, MyDiv div
where
  findVal = globalValueNumber(fn.getACallToThisFunction()) and
  (
    // Look for divide-by-zero operations possible due to the return value of the function `fn`.
    checkConditions1(div, fn, changeInt) and
    (
      // Function return value can be zero.
      mayBeReturnZero(fn) and
      getMulDivOperand(globalValueNumber(div.getRV()).getAnExpr()) = findVal.getAnExpr() and
      changeInt = 0
      or
      // Denominator can be sum or difference.
      changeInt = getValueOperand(div.getRV(), findVal.getAnExpr(), _) and
      mayBeReturnValue(fn, changeInt)
    ) and
    exp = div and
    msg =
      "Can lead to division by 0, since the function " + fn.getName() + " can return a value " +
        changeInt.toString() + "."
    or
    // Search for situations where division by zero is possible inside the `divFn` function if the passed argument can be equal to a certain value.
    exists(int posArg, Expr divVal, FunctionCall divFc, float changeInt2 |
      // Division is associated with the function argument.
      exists(Function divFn |
        divFn.getParameter(posArg).getAnAccess() = divVal and
        divVal.getEnclosingStmt() = div.getEnclosingStmt() and
        divFc = divFn.getACallToThisFunction()
      ) and
      (
        divVal = div.getRV() and
        divFc.getArgument(posArg) != findVal.getAnExpr() and
        (
          // Function return value can be zero.
          mayBeReturnZero(fn) and
          getMulDivOperand(globalValueNumber(divFc.getArgument(posArg)).getAnExpr()) =
            findVal.getAnExpr() and
          changeInt = 0 and
          changeInt2 = 0
          or
          // Denominator can be sum or difference.
          changeInt = getValueOperand(divFc.getArgument(posArg), findVal.getAnExpr(), _) and
          mayBeReturnValue(fn, changeInt) and
          changeInt2 = 0
        )
        or
        // Look for a situation where the difference or subtraction is considered as an argument, and it can be used in the same way.
        changeInt = getValueOperand(div.getRV(), divVal, _) and
        changeInt2 = changeInt and
        mayBeReturnValue(fn, changeInt) and
        divFc.getArgument(posArg) = findVal.getAnExpr()
      ) and
      checkConditions2(div, divVal, changeInt2) and
      checkConditions1(divFc, fn, changeInt) and
      exp = divFc and
      msg =
        "Can lead to division by 0, since the function " + fn.getName() + " can return a value " +
          changeInt.toString() + "."
    )
  )
select exp, msg
