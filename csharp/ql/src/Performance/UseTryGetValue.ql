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

pragma[noinline]
private predicate candidate(MethodCall mc, IndexerRead access) {
  mc.getTarget().hasName("ContainsKey") and
  access.getQualifier().(G::GuardedExpr).isGuardedBy(mc, mc.getQualifier(), _)
}

from MethodCall call, IndexerRead index
where
  candidate(call, index) and
  sameGvn(call.getArgument(0), index.getIndex(0))
select call, "Inefficient use of 'ContainsKey' and $@.", index, "indexer"
