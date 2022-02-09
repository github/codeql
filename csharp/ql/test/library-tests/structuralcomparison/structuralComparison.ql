import csharp
import semmle.code.csharp.commons.StructuralComparison

private class StructuralComparisonTest extends StructuralComparisonConfiguration {
  StructuralComparisonTest() { this = "StructuralComparisonTest" }

  override predicate candidate(ControlFlowElement e1, ControlFlowElement e2) {
    e1.fromSource() and e2.fromSource() and e1 != e2
  }
}

query predicate same(Expr e1, Expr e2) { exists(StructuralComparisonTest sct | sct.same(e1, e2)) }
