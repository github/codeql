/**
 * @name Errors Of Undefined Program Behavior
 * @description --In some situations, the code constructs used may be executed in the wrong order in which the developer designed them.
 *              --For example, if you call multiple functions as part of a single expression, and the functions have the ability to modify a shared resource, then the sequence in which the resource is changed can be unpredictable.
 *              --These code snippets look suspicious and require the developer's attention.
 * @kind problem
 * @id cpp/errors-of-undefined-program-behavior
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-758
 */

import cpp
import semmle.code.cpp.valuenumbering.HashCons
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * Threatening expressions of undefined behavior.
 */
class ExpressionsOfTheSameLevel extends Expr {
  Expr exp2;

  ExpressionsOfTheSameLevel() {
    this != exp2 and
    this.getParent() = exp2.getParent()
  }

  /** Holds if the underlying expression is a function call. */
  predicate expressionCall() {
    this instanceof FunctionCall and
    exp2.getAChild*() instanceof FunctionCall and
    not this.getParent() instanceof Operator and
    not this.(FunctionCall).hasQualifier()
  }

  /** Holds if the underlying expression is a call to a function to free resources. */
  predicate existsCloseOrFreeCall() {
    (
      globalValueNumber(this.(FunctionCall).getAnArgument()) =
        globalValueNumber(exp2.getAChild*().(FunctionCall).getAnArgument()) or
      hashCons(this.(FunctionCall).getAnArgument()) =
        hashCons(exp2.getAChild*().(FunctionCall).getAnArgument())
    ) and
    (
      this.(FunctionCall).getTarget().hasGlobalOrStdName("close") or
      this.(FunctionCall).getTarget().hasGlobalOrStdName("free") or
      this.(FunctionCall).getTarget().hasGlobalOrStdName("fclose")
    )
  }

  /** Holds if the arguments in the function can be changed. */
  predicate generalArgumentDerivedType() {
    exists(Parameter prt1, Parameter prt2, AssignExpr aet1, AssignExpr aet2, int i, int j |
      not this.(FunctionCall).getArgument(i).isConstant() and
      hashCons(this.(FunctionCall).getArgument(i)) =
        hashCons(exp2.getAChild*().(FunctionCall).getArgument(j)) and
      prt1 = this.(FunctionCall).getTarget().getParameter(i) and
      prt2 = exp2.getAChild*().(FunctionCall).getTarget().getParameter(j) and
      prt1.getType() instanceof DerivedType and
      (
        aet1 = this.(FunctionCall).getTarget().getEntryPoint().getASuccessor*() and
        (
          aet1.getLValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() =
            prt1.getAnAccess().getTarget() or
          aet1.getLValue().(VariableAccess).getTarget() = prt1.getAnAccess().getTarget()
        )
        or
        exists(FunctionCall fc1 |
          fc1.getTarget().hasGlobalName("memcpy") and
          fc1.getArgument(0).(VariableAccess).getTarget() = prt1.getAnAccess().getTarget() and
          fc1 = this.(FunctionCall).getTarget().getEntryPoint().getASuccessor*()
        )
      ) and
      (
        aet2 = exp2.getAChild*().(FunctionCall).getTarget().getEntryPoint().getASuccessor*() and
        (
          aet2.getLValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() =
            prt2.getAnAccess().getTarget() or
          aet2.getLValue().(VariableAccess).getTarget() = prt2.getAnAccess().getTarget()
        )
        or
        exists(FunctionCall fc1 |
          fc1.getTarget().hasGlobalName("memcpy") and
          fc1.getArgument(0).(VariableAccess).getTarget() = prt2.getAnAccess().getTarget() and
          fc1 = exp2.(FunctionCall).getTarget().getEntryPoint().getASuccessor*()
        )
      )
    )
  }

  /** Holds if functions have a common global argument. */
  predicate generalGlobalArgument() {
    exists(Declaration dl, AssignExpr aet1, AssignExpr aet2 |
      dl instanceof GlobalVariable and
      (
        (
          aet1.getLValue().(Access).getTarget() = dl or
          aet1.getLValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() = dl
        ) and
        aet1 = this.(FunctionCall).getTarget().getEntryPoint().getASuccessor*() and
        not aet1.getRValue().isConstant()
        or
        exists(FunctionCall fc1 |
          fc1.getTarget().hasGlobalName("memcpy") and
          fc1.getArgument(0).(VariableAccess).getTarget() = dl and
          fc1 = this.(FunctionCall).getTarget().getEntryPoint().getASuccessor*()
        )
      ) and
      (
        (
          aet2.getLValue().(Access).getTarget() = dl or
          aet2.getLValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() = dl
        ) and
        aet2 = exp2.(FunctionCall).getTarget().getEntryPoint().getASuccessor*()
        or
        exists(FunctionCall fc1 |
          fc1.getTarget().hasGlobalName("memcpy") and
          fc1.getArgument(0).(VariableAccess).getTarget() = dl and
          fc1 = exp2.(FunctionCall).getTarget().getEntryPoint().getASuccessor*()
        )
      )
    )
  }

  /** Holds if sequence point is not present in expression. */
  predicate orderOfActionExpressions() {
    not this.getParent() instanceof BinaryLogicalOperation and
    not this.getParent() instanceof ConditionalExpr and
    not this.getParent() instanceof Loop and
    not this.getParent() instanceof CommaExpr
  }

  /** Holds if expression is crement. */
  predicate dangerousCrementChanges() {
    hashCons(this.(CrementOperation).getOperand()) = hashCons(exp2.(CrementOperation).getOperand())
    or
    hashCons(this.(CrementOperation).getOperand()) = hashCons(exp2)
    or
    hashCons(this.(CrementOperation).getOperand()) = hashCons(exp2.(ArrayExpr).getArrayOffset())
    or
    hashCons(this.(Assignment).getLValue()) = hashCons(exp2.(Assignment).getLValue())
    or
    not this.getAChild*() instanceof Call and
    (
      hashCons(this.getAChild*().(CrementOperation).getOperand()) = hashCons(exp2) or
      hashCons(this.getAChild*().(CrementOperation).getOperand()) =
        hashCons(exp2.(Assignment).getLValue())
    )
  }
}

from ExpressionsOfTheSameLevel eots
where
  eots.orderOfActionExpressions() and
  (
    eots.expressionCall() and
    (
      eots.generalArgumentDerivedType() or
      eots.generalGlobalArgument() or
      eots.existsCloseOrFreeCall()
    )
    or
    eots.dangerousCrementChanges()
  )
select eots,
  "This expression may have undefined behavior, because the order of evaluation is not specified."
