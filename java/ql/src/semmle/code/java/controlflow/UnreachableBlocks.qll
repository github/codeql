/**
 * Provides classes and predicates for identifying unreachable blocks under a "closed-world" assumption.
 */

import java
import semmle.code.java.controlflow.Guards

/**
 * A field which contains a constant of an immutable type.
 *
 * This only considers fields which are assigned once.
 */
class ConstantField extends Field {
  ConstantField() {
    getType() instanceof ImmutableType and
    // Assigned once
    count(getAnAssignedValue()) = 1 and
    // And that assignment is either in the appropriate initializer, or, for instance fields on
    // classes with one constructor, in the constructor.
    forall(FieldWrite fa | fa = getAnAccess() |
      if isStatic()
      then fa.getEnclosingCallable() instanceof StaticInitializer
      else (
        // Defined in the instance initializer.
        fa.getEnclosingCallable() instanceof InstanceInitializer
        or
        // It can be defined in the constructor if there is only one constructor.
        fa.getEnclosingCallable() instanceof Constructor and
        count(getDeclaringType().getAConstructor()) = 1
      )
    )
  }

  /**
   * Gets the constant value assigned to the field.
   *
   * Note: although this value is constant, we may not be able to statically determine the value.
   */
  ConstantExpr getConstantValue() { result = getAnAssignedValue() }
}

/**
 * A method that returns a single constant value, and is not overridden.
 */
class ConstantMethod extends Method {
  ConstantMethod() {
    // Just one return statement
    count(ReturnStmt rs | rs.getEnclosingCallable() = this) = 1 and
    // Which returns a constant expr
    exists(ReturnStmt rs | rs.getEnclosingCallable() = this |
      rs.getResult() instanceof ConstantExpr
    ) and
    // And this method is not overridden
    not exists(Method m | m.overrides(this))
  }

  /**
   * Gets the expression representing the constant value returned.
   */
  ConstantExpr getConstantValue() {
    exists(ReturnStmt returnStmt | returnStmt.getEnclosingCallable() = this |
      result = returnStmt.getResult()
    )
  }
}

/**
 * A field that appears constant, but should not be considered constant when determining
 * `ConstantExpr`, and, consequently, in the unreachable blocks analysis.
 */
abstract class ExcludedConstantField extends ConstantField { }

/**
 * An expression that evaluates to a constant at runtime.
 *
 * This includes all JLS compile-time constants, plus expressions that can be deduced to be
 * constant by making a closed world assumption.
 */
class ConstantExpr extends Expr {
  ConstantExpr() {
    // Ignore reads of excluded fields.
    not this.(FieldRead).getField() instanceof ExcludedConstantField and
    (
      // A JLS compile time constant expr
      this instanceof CompileTimeConstantExpr
      or
      // A call to a constant method
      this.(Call).getCallee() instanceof ConstantMethod
      or
      // A read of a constant field
      exists(this.(FieldRead).getField().(ConstantField).getConstantValue())
      or
      // A binary expression where both sides are constant
      this.(BinaryExpr).getLeftOperand() instanceof ConstantExpr and
      this.(BinaryExpr).getRightOperand() instanceof ConstantExpr
    )
  }

  /**
   * Gets the inferred boolean value for this constant boolean expression.
   */
  boolean getBooleanValue() {
    result = this.(CompileTimeConstantExpr).getBooleanValue()
    or
    result = this.(Call).getCallee().(ConstantMethod).getConstantValue().getBooleanValue()
    or
    result = this.(FieldRead).getField().(ConstantField).getConstantValue().getBooleanValue()
    or
    // Handle binary expressions that have integer operands and a boolean result.
    exists(BinaryExpr b, int left, int right |
      b = this and
      left = b.getLeftOperand().(ConstantExpr).getIntValue() and
      right = b.getRightOperand().(ConstantExpr).getIntValue()
    |
      (
        b instanceof LTExpr and
        if left < right then result = true else result = false
      )
      or
      (
        b instanceof LEExpr and
        if left <= right then result = true else result = false
      )
      or
      (
        b instanceof GTExpr and
        if left > right then result = true else result = false
      )
      or
      (
        b instanceof GEExpr and
        if left >= right then result = true else result = false
      )
      or
      (
        b instanceof EQExpr and
        if left = right then result = true else result = false
      )
      or
      (
        b instanceof NEExpr and
        if left != right then result = true else result = false
      )
    )
  }

  /**
   * Gets the inferred int value for this constant int expression.
   */
  int getIntValue() {
    result = this.(CompileTimeConstantExpr).getIntValue() or
    result = this.(Call).getCallee().(ConstantMethod).getConstantValue().getIntValue() or
    result = this.(FieldRead).getField().(ConstantField).getConstantValue().getIntValue()
  }
}

/**
 * A switch statement that always selects the same case.
 */
class ConstSwitchStmt extends SwitchStmt {
  ConstSwitchStmt() { this.getExpr() instanceof ConstantExpr }

  /** Gets the `ConstCase` that matches, if any. */
  ConstCase getMatchingConstCase() {
    result = getAConstCase() and
    // Only handle the int case for now
    result.getValue().(ConstantExpr).getIntValue() = getExpr().(ConstantExpr).getIntValue()
  }

  /** Gets the matching case, if it can be deduced. */
  SwitchCase getMatchingCase() {
    // Must be a value we can deduce
    exists(getExpr().(ConstantExpr).getIntValue()) and
    if exists(getMatchingConstCase())
    then result = getMatchingConstCase()
    else result = getDefaultCase()
  }

  /**
   * Gets a case that never matches.
   *
   * This only has values if we found the matching case.
   */
  SwitchCase getAFailingCase() {
    exists(SwitchCase matchingCase |
      // We must have found the matching case, otherwise we can't deduce which cases are not matched
      matchingCase = getMatchingCase() and
      result = getACase() and
      result != matchingCase
    )
  }
}

/**
 * An unreachable basic block is one that is dominated by a condition that never holds.
 */
class UnreachableBasicBlock extends BasicBlock {
  UnreachableBasicBlock() {
    // Condition blocks with a constant condition that causes a true/false successor to be
    // unreachable. Note: conditions including a single boolean literal e.g. if (false) are not
    // modeled as a ConditionBlock - this case is covered by the blocks-without-a-predecessor
    // check below.
    exists(ConditionBlock conditionBlock, boolean constant |
      constant = conditionBlock.getCondition().(ConstantExpr).getBooleanValue()
    |
      conditionBlock.controls(this, constant.booleanNot())
    )
    or
    // This block is not reachable in the CFG, and is not a callable, a body of a callable, an
    // expression in an annotation, an expression in an assert statement, or a catch clause.
    forall(BasicBlock bb | bb = getABBPredecessor() | bb instanceof UnreachableBasicBlock) and
    not exists(Callable c | c.getBody() = this) and
    not this instanceof Callable and
    not exists(Annotation a | a.getAChildExpr*() = this) and
    not exists(AssertStmt a | a = this.(Expr).getEnclosingStmt()) and
    not this instanceof CatchClause
    or
    // Switch statements with a constant comparison expression may have unreachable cases.
    exists(ConstSwitchStmt constSwitchStmt, BasicBlock failingCaseBlock |
      failingCaseBlock = constSwitchStmt.getAFailingCase().getBasicBlock()
    |
      // Not accessible from the successful case
      not constSwitchStmt.getMatchingCase().getBasicBlock().getABBSuccessor*() = failingCaseBlock and
      // Blocks dominated by the failing case block are unreachable
      constSwitchStmt.getAFailingCase().getBasicBlock().bbDominates(this)
    )
  }
}

/**
 * An unreachable expression is an expression contained in an `UnreachableBasicBlock`.
 */
class UnreachableExpr extends Expr {
  UnreachableExpr() { getBasicBlock() instanceof UnreachableBasicBlock }
}

/**
 * An unreachable statement is a statement contained in an `UnreachableBasicBlock`.
 */
class UnreachableStmt extends Stmt {
  UnreachableStmt() { getBasicBlock() instanceof UnreachableBasicBlock }
}
