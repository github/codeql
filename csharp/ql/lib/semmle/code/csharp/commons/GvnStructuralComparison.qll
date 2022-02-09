/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */

import csharp

abstract class GvnStructuralComparisonConfiguration extends string {
  bindingset[this]
  GvnStructuralComparisonConfiguration() { any() }

  abstract predicate candidate(ControlFlowElement x, ControlFlowElement y);

  private predicate sameInternal(ControlFlowElement x, ControlFlowElement y) {
    none() // Needs to be implemented.
  }

  predicate same(ControlFlowElement x, ControlFlowElement y) {
    candidate(x, y) and
    sameInternal(x, y)
  }
}
