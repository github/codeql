import semmle.code.cpp.controlflow.ControlFlowGraph

/**
 * A C/C++ declaration initializer.
 */
class Initializer extends @initialiser, ControlFlowNode {
  override Location getLocation() { initialisers(this,_,_,result) }

  /** Holds if this initializer is explicit in the source. */
  override predicate fromSource() {
    not (this.getLocation() instanceof UnknownLocation)
  }

  override string toString() {
    if exists(getDeclaration()) then (
      result = "initializer for " + max(getDeclaration().getName())
    ) else (
      result = "initializer"
    )
  }

  /** Gets the variable or enum constant being initialized. */
  Declaration getDeclaration() { initialisers(this,result,_,_) }

  /** Gets the initializing expression. */
  Expr getExpr() { initialisers(this,_,result,_) }

  /** Gets the function containing this control-flow node. */
  override Function getControlFlowScope() {
    result = this.getExpr().getEnclosingFunction()
  }

  override Stmt getEnclosingStmt() {
    result = this.getExpr().getEnclosingStmt()
  }
}
