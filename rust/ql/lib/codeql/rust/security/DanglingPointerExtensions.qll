import rust
private import codeql.rust.dataflow.DataFlow

/**
 * Holds if `createsPointer` creates a pointer or reference pointing at `targetValue`.
 */
predicate createsPointer(DataFlow::Node createsPointer, DataFlow::Node targetValue) {
  exists(RefExpr re |
    re = createsPointer.asExpr().getExpr() and
    re.getExpr() = targetValue.asExpr().getExpr()
  )
}

/**
 * Holds if `derefPointer` dereferences a pointer.
 */
predicate dereferencesPointer(DataFlow::Node derefPointer) {
  exists(PrefixExpr pe |
    pe.getOperatorName() = "*" and
    pe.getExpr() = derefPointer.asExpr().getExpr()
  )
}

/**
 * A taint configuration for a pointer or reference that is created and later
 * dereferenced.
 */
module PointerDereferenceConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { createsPointer(node, _) }

  predicate isSink(DataFlow::Node node) { dereferencesPointer(node) }
}

/**
 * Holds if `value` accesses a variable with scope `scope`.
 */
predicate valueScope(Expr value, BlockExpr scope) {
  // variable access
  scope = value.(VariableAccess).getVariable().getEnclosingBlock()
  or
  // field access
  valueScope(value.(FieldExpr).getExpr(), scope)
}

/**
 * Holds if block `a` contains block `b`, in the sense that a variable in
 * `a` may be on the stack during execution of `b`. This is interprocedural,
 * but is an overapproximation because we don't account for the actual call
 * context that got us to `b` (for example if `f` and `g` both call `b`, then
 * then depending on the caller a variable in `f` may or may-not be on the
 * stack during `b`).
 */
predicate maybeOnStack(BlockExpr a, BlockExpr b) {
  // `b` is a child of `a`
  a = b.getEnclosingBlock*()
  or
  // propagage through function calls
  exists(CallExprBase ce |
    maybeOnStack(a, ce.getEnclosingBlock()) and
    ce.getStaticTarget() = b.getEnclosingCallable()
  )
}
