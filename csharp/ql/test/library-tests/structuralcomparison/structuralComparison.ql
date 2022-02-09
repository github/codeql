import csharp
import semmle.code.csharp.commons.StructuralComparison
import semmle.code.csharp.commons.GvnStructuralComparison

private predicate sourceCandidate(ControlFlowElement e1, ControlFlowElement e2) {
  e1.fromSource() and e2.fromSource() and e1 != e2
}

private class StructuralComparisonTest extends StructuralComparisonConfiguration {
  StructuralComparisonTest() { this = "StructuralComparisonTest" }

  override predicate candidate(ControlFlowElement e1, ControlFlowElement e2) {
    sourceCandidate(e1, e2)
  }
}

private class GvnStructuralComparisonTest extends GvnStructuralComparisonConfiguration {
  GvnStructuralComparisonTest() { this = "GvnStructuralComparisonTest" }

  override predicate candidate(ControlFlowElement e1, ControlFlowElement e2) {
    sourceCandidate(e1, e2)
  }
}

query predicate same(Expr e1, Expr e2) { exists(StructuralComparisonTest sct | sct.same(e1, e2)) }

query predicate gvnSame(Expr e1, Expr e2) {
  exists(GvnStructuralComparisonTest sct | sct.same(e1, e2))
}

// These predicates will temporarily be used to indicate semantic equivalence.
query predicate sameDiff(Expr e1, Expr e2) { same(e1, e2) and not gvnSame(e1, e2) }

query predicate gvnSameDiff(Expr e1, Expr e2) { gvnSame(e1, e2) and not same(e1, e2) }

query predicate gvnPrinting(Expr e, Gvn gvn) { gvn = toGvn(e) and e.fromSource() }
