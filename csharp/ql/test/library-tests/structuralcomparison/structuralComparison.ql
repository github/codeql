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
  exists(StructuralComparisonTest sct | sct.same(e1, e2))
}

query predicate gvn(ControlFlowElement e, Gvn gvn) { gvn = toGvn(e) and e.fromSource() }
