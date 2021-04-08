/**
 * Provides classes for loop iteration variables.
 */

import semmle.code.cpp.Variable

/**
 * A C/C++ variable which is used within the condition of a 'for' loop, and
 * mutated within the update expression of the same 'for' loop.
 */
class LoopCounter extends Variable {
  LoopCounter() { exists(ForStmt f | f.getAnIterationVariable() = this) }

  /**
   *  Gets an access of this variable within loop `f`.
   */
  VariableAccess getVariableAccessInLoop(ForStmt f) {
    this.getALoop() = f and
    result.getEnclosingStmt().getParent*() = f and
    this = result.getTarget()
  }

  /**
   * Gets a loop which uses this variable as its counter.
   */
  ForStmt getALoop() { result.getAnIterationVariable() = this }
}

/**
 * A C/C++ variable which is used within the initialization, condition, or
 * update expression of a 'for' loop.
 */
class LoopControlVariable extends Variable {
  LoopControlVariable() { this = loopControlVariable(_) }

  /**
   * Gets an access of this variable within loop `f`.
   */
  VariableAccess getVariableAccessInLoop(ForStmt f) {
    this.getALoop() = f and
    result.getEnclosingStmt().getParent*() = f and
    this = result.getTarget()
  }

  /**
   * Gets a loop which uses this variable as its control variable.
   */
  ForStmt getALoop() { this = loopControlVariable(result) }
}

/**
 * Gets a control variable of loop `f`.
 */
private Variable loopControlVariable(ForStmt f) {
  exists(Expr e | result.getAnAccess().getParent*() = e |
    e = f.getControllingExpr() or
    e = f.getInitialization().(ExprStmt).getExpr() or
    e = f.getUpdate()
  )
}
