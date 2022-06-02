import csharp
import semmle.code.csharp.commons.StructuralComparison

/**
 * All pairs of controls flow elements found in the source and within the same
 * enclosing callable excluding all instances of `ThisAccess` to reduce the size
 * of the output.
 */
private predicate candidate(ControlFlowElement x, ControlFlowElement y) {
  x.fromSource() and
  y.fromSource() and
  x != y and
  x.getEnclosingCallable() = y.getEnclosingCallable() and
  not x instanceof ThisAccess
}

query predicate same(ControlFlowElement x, ControlFlowElement y) {
  exists(Location l1, Location l2 |
    candidate(x, y) and
    sameGvn(x, y) and
    l1 = x.getLocation() and
    l2 = y.getLocation() and
    (
      l1.getStartLine() < l2.getStartLine()
      or
      l1.getStartLine() = l2.getStartLine() and l1.getStartColumn() < l2.getStartColumn()
    )
  )
}

query predicate gvn(ControlFlowElement x, Gvn gvn) { gvn = toGvn(x) and x.fromSource() }
