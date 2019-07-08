import semmle.code.cpp.controlflow.ControlFlowGraph

/**
 * A C/C++ declaration initializer.
 */
class Initializer extends ControlFlowNode, @initialiser {
  override Location getLocation() { initialisers(underlyingElement(this),_,_,result) }

  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "Initializer" }
  
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
  Declaration getDeclaration() { initialisers(underlyingElement(this),unresolveElement(result),_,_) }

  /** Gets the initializing expression. */
  Expr getExpr() { initialisers(underlyingElement(this),_,unresolveElement(result),_) }

  /** Gets the function containing this control-flow node. */
  override Function getControlFlowScope() {
    result = this.getExpr().getEnclosingFunction()
  }

  override Stmt getEnclosingStmt() {
    result = this.getExpr().getEnclosingStmt()
  }
}
