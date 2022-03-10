import csharp
import semmle.code.csharp.commons.StructuralComparison

private class StructuralComparisonTest extends StructuralComparisonConfiguration {
  StructuralComparisonTest() { this = "StructuralComparisonTest" }

  /**
   * All pairs of controls flow elements found in the source and within the same
   * enclosing callable excluding all instances of `ThisAccess` to reduce the size
   * of the output.
   */
  override predicate candidate(ControlFlowElement e1, ControlFlowElement e2) {
    e1.fromSource() and
    e2.fromSource() and
    e1 != e2 and
    e1.getEnclosingCallable() = e2.getEnclosingCallable() and
    not e1 instanceof ThisAccess
  }
}

query predicate same(ControlFlowElement e1, ControlFlowElement e2) {
  exists(StructuralComparisonTest sct, Location l1, Location l2 |
    sct.same(e1, e2) and
    l1 = e1.getLocation() and
    l2 = e2.getLocation() and
    (
      l1.getStartLine() < l2.getStartLine()
      or
      l1.getStartLine() = l2.getStartLine() and l1.getStartColumn() < l2.getStartColumn()
    )
  )
}

query predicate gvn(ControlFlowElement e, Gvn gvn) { gvn = toGvn(e) and e.fromSource() }
