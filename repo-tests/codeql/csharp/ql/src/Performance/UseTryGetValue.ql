/**
 * @name Inefficient use of ContainsKey
 * @description Testing whether a dictionary contains a value before getting it is inefficient and redundant.
 *              Use 'TryGetValue' to combine these two steps.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/inefficient-containskey
 * @tags maintainability efficiency
 */

import csharp
import semmle.code.csharp.commons.StructuralComparison
import semmle.code.csharp.controlflow.Guards as G

class SameElement extends StructuralComparisonConfiguration {
  SameElement() { this = "Same element" }

  override predicate candidate(ControlFlowElement e1, ControlFlowElement e2) {
    exists(MethodCall mc, IndexerRead access |
      mc.getTarget().hasName("ContainsKey") and
      access.getQualifier().(G::GuardedExpr).isGuardedBy(mc, mc.getQualifier(), _) and
      e1 = mc.getArgument(0) and
      e2 = access.getIndex(0)
    )
  }
}

from SameElement element, MethodCall call, IndexerAccess index
where element.same(call.getArgument(0), index.getIndex(0))
select call, "Inefficient use of 'ContainsKey' and $@.", index, "indexer"
