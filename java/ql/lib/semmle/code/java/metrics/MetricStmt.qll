/**
 * Provides classes and predicates for computing metrics on Java statements.
 */

import semmle.code.java.Statement

/** This class provides access to metrics information for statements. */
class MetricStmt extends Stmt {
  /** Gets a nesting depth of this statement. */
  int getANestingDepth() {
    not exists(Stmt s | s.getParent() = this) and result = 0
    or
    result = this.getAChild().(MetricStmt).getANestingDepth() + 1
  }

  /** Gets the maximum nesting depth of this statement. */
  int getNestingDepth() { result = max(this.getANestingDepth()) }

  /** Gets the nested depth of this statement. */
  int getNestedDepth() {
    not this.getParent() instanceof Stmt and result = 0
    or
    exists(MetricStmt s | s = this.getParent() and result = s.getNestedDepth() + 1)
  }
}
