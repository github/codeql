/**
 * Provides a simple data flow analysis to find expressions that are definitely
 * null or that may be null.
 */

import cpp
import Nullness
import Dereferenced

/**
 * INTERNAL: Do not use.
 * A string that identifies a data flow analysis along with a set of member
 * predicates that implement this analysis.
 */
abstract class DataflowAnnotation extends string {
  DataflowAnnotation() { this = "pointer-null" or this = "pointer-valid" }

  abstract predicate isDefault();

  abstract predicate generatedOn(Expr e);

  abstract predicate generatedBy(LocalScopeVariable v, ControlFlowNode src, ControlFlowNode dest);

  abstract predicate killedBy(LocalScopeVariable v, ControlFlowNode src, ControlFlowNode dest);

  predicate marks(Expr e) {
    this.generatedOn(e) and reachable(e)
    or
    this.marks(e.(AssignExpr).getRValue())
    or
    exists(LocalScopeVariable v | this.marks(v, e) and e = v.getAnAccess())
  }

  predicate marks(LocalScopeVariable v, ControlFlowNode n) {
    v.getAnAccess().getEnclosingFunction().getBlock() = n and
    this.isDefault()
    or
    this.marks(n.(Initializer).getExpr()) and
    v.getInitializer() = n
    or
    exists(ControlFlowNode pred |
      this.generatedBy(v, pred, n) and
      not this.killedBy(v, pred, n) and
      reachable(pred)
    )
    or
    exists(ControlFlowNode pred |
      this.assignedBy(v, pred, n) and
      not this.killedBy(v, pred, n) and
      reachable(pred)
    )
    or
    exists(ControlFlowNode pred |
      this.preservedBy(v, pred, n) and
      not this.killedBy(v, pred, n) and
      reachable(pred)
    )
  }

  predicate preservedBy(LocalScopeVariable v, ControlFlowNode src, ControlFlowNode dest) {
    this.marks(v, src) and
    src.getASuccessor() = dest and
    not v.getInitializer() = dest and
    not v.getAnAssignment() = src
  }

  predicate assignedBy(LocalScopeVariable v, ControlFlowNode src, ControlFlowNode dest) {
    this.marks(src.(AssignExpr).getRValue()) and
    src = v.getAnAssignment() and
    src.getASuccessor() = dest
  }
}

/**
 * INTERNAL: Do not use.
 * Two analyses relating to nullness: `"pointer-null"` and `"pointer-valid"`.
 * These analyses mark expressions that are possibly null or possibly non-null,
 * respectively.
 */
class NullnessAnnotation extends DataflowAnnotation {
  NullnessAnnotation() { this = "pointer-null" or this = "pointer-valid" }

  override predicate isDefault() { this = "pointer-valid" }

  override predicate generatedOn(Expr e) {
    exists(Variable v |
      v.getAnAccess() = e and
      (v instanceof GlobalVariable or v instanceof Field) and
      this.isDefault()
    )
    or
    e instanceof Call and this = "pointer-valid"
    or
    nullValue(e) and this = "pointer-null"
  }

  override predicate killedBy(LocalScopeVariable v, ControlFlowNode src, ControlFlowNode dest) {
    src.(AnalysedExpr).getNullSuccessor(v) = dest and this = "pointer-valid"
    or
    src.(AnalysedExpr).getNonNullSuccessor(v) = dest and this = "pointer-null"
    or
    dest = src.getASuccessor() and callByReference(src, v) and not this.isDefault()
    or
    dest = src.getASuccessor() and deref(v, src) and this = "pointer-null"
  }

  override predicate generatedBy(LocalScopeVariable v, ControlFlowNode src, ControlFlowNode dest) {
    dest = src.getASuccessor() and
    callByReference(src, v) and
    this.isDefault()
  }
}

/**
 * Holds if evaluation of `op` dereferences `v`.
 */
predicate deref(Variable v, Expr op) { dereferencedByOperation(op, v.getAnAccess()) }

/**
 * Holds if `call` passes `v` by reference, either with an explicit address-of
 * operator or implicitly as a C++ reference. Both const and non-const
 * references are included.
 */
predicate callByReference(Call call, Variable v) {
  exists(Expr arg |
    call.getAnArgument() = arg and
    (
      arg.(AddressOfExpr).getAChild() = v.getAnAccess()
      or
      v.getAnAccess() = arg and arg.getConversion*() instanceof ReferenceToExpr
    )
  )
}

/**
 * Holds if a simple data-flow analysis determines that `e` is definitely null.
 */
predicate definitelyNull(Expr e) {
  "pointer-null".(NullnessAnnotation).marks(e) and
  not "pointer-valid".(NullnessAnnotation).marks(e)
}

/**
 * Holds if a simple data-flow analysis determines that `e` may be null.
 */
predicate maybeNull(Expr e) { "pointer-null".(NullnessAnnotation).marks(e) }
