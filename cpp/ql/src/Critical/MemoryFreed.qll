import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.pointsto.PointsTo

private predicate freed(Expr e) {
  e = any(DeallocationExpr de).getFreedExpr()
  or
  exists(ExprCall c |
    // cautiously assume that any `ExprCall` could be a deallocation expression.
    c.getAnArgument() = e
  )
}
/** An expression that might be deallocated. */
class FreedExpr extends PointsToExpr {
  FreedExpr() { freed(this) }

  override predicate interesting() { freed(this) }
}

module AllocationDeallocationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(AllocationExpr ae | node.asExpr() = ae)
  }

  predicate isSink(DataFlow::Node node) {
    freed(node.asExpr())
  }
}

module Flow = DataFlow::Global<AllocationDeallocationConfig>;


/**
 * An allocation expression that might be deallocated. For example:
 * ```
 * int* p = new int;
 * ...
 * delete p;
 * ```
 */
predicate allocMayBeFreed(AllocationExpr alloc) { 
  exists(DataFlow::Node node |
    node.asExpr() = alloc and
    Flow::flow(node, _)
  )
}
