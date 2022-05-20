import python

/**
 * An ImportTimeScope is any scope that is not nested within a function and will thus be executed if its
 * enclosing module is imported.
 * Note however, that if a scope is not an ImportTimeScope it may still be executed at import time.
 * This is an artificial approximation, which is necessary for static analysis.
 */
class ImportTimeScope extends Scope {
  ImportTimeScope() { not this.getEnclosingScope*() instanceof Function }

  /**
   * Whether this scope explicitly defines 'name'.
   * Does not cover implicit definitions be import *
   */
  pragma[nomagic]
  predicate definesName(string name) {
    exists(SsaVariable var | name = var.getId() and var.getAUse() = this.getANormalExit())
  }

  /** Holds if the control flow passes from `outer` to `inner` when this scope starts executing */
  predicate entryEdge(ControlFlowNode outer, ControlFlowNode inner) {
    inner = this.getEntryNode() and
    outer.getNode().(ClassExpr).getInnerScope() = this
  }

  /** Gets the global variable that is used during lookup, should `var` be undefined. */
  GlobalVariable getOuterVariable(LocalVariable var) {
    this instanceof Class and
    var.getScope() = this and
    result.getScope() = this.getEnclosingModule() and
    var.getId() = result.getId()
  }
}
