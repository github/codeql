import rust
private import codeql.rust.dataflow.DataFlow

/**
 * Holds if `createsPointer` creates a pointer pointing at `targetValue`.
 */
predicate createsPointer(DataFlow::Node createsPointer, DataFlow::Node targetValue) {
  exists(RefExpr re |
    re = createsPointer.asExpr().getExpr() and
    re.getExpr() = targetValue.asExpr().getExpr()
  )
}

/**
 * Holds if `derefPointer` dereferences a pointer (in unsafe code).
 */
predicate dereferencesPointer(DataFlow::Node derefPointer) {
  exists(PrefixExpr pe |
    pe.getOperatorName() = "*" and
    pe.getExpr() = derefPointer.asExpr().getExpr()
  )
}

/**
 * A taint configuration for a pointer that is created and later dereferenced.
 */
module PointerDereferenceConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { createsPointer(node, _) }

  predicate isSink(DataFlow::Node node) { dereferencesPointer(node) }
}
