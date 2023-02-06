/**
 * @name Unguarded next in generator
 * @description Calling next() in a generator may cause unintended early termination of an iteration.
 * @kind problem
 * @tags maintainability
 *       portability
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/unguarded-next-in-generator
 */

import python
private import semmle.python.ApiGraphs

API::Node iter() { result = API::builtin("iter") }

API::Node next() { result = API::builtin("next") }

API::Node stopIteration() { result = API::builtin("StopIteration") }

predicate call_to_iter(CallNode call, EssaVariable sequence) {
  call = iter().getACall().asCfgNode() and
  call.getArg(0) = sequence.getAUse()
}

predicate call_to_next(CallNode call, ControlFlowNode iter) {
  call = next().getACall().asCfgNode() and
  call.getArg(0) = iter
}

predicate call_to_next_has_default(CallNode call) {
  exists(call.getArg(1)) or exists(call.getArgByName("default"))
}

predicate guarded_not_empty_sequence(EssaVariable sequence) {
  sequence.getDefinition() instanceof EssaEdgeRefinement
}

/**
 * Holds if `iterator` is not exhausted.
 *
 * The pattern `next(iter(x))` is often used where `x` is known not be empty. Check for that.
 */
predicate iter_not_exhausted(EssaVariable iterator) {
  exists(EssaVariable sequence |
    call_to_iter(iterator.getDefinition().(AssignmentDefinition).getValue(), sequence) and
    guarded_not_empty_sequence(sequence)
  )
}

predicate stop_iteration_handled(CallNode call) {
  exists(Try t |
    t.containsInScope(call.getNode()) and
    t.getAHandler().getType() = stopIteration().getAValueReachableFromSource().asExpr()
  )
}

from CallNode call
where
  call_to_next(call, _) and
  not call_to_next_has_default(call) and
  not exists(EssaVariable iterator |
    call_to_next(call, iterator.getAUse()) and
    iter_not_exhausted(iterator)
  ) and
  call.getNode().getScope().(Function).isGenerator() and
  not exists(Comp comp | comp.contains(call.getNode())) and
  not stop_iteration_handled(call) and
  // PEP 479 removes this concern from 3.7 onwards
  // see: https://peps.python.org/pep-0479/
  //
  // However, we do not know the minor version of the analyzed code (only of the extractor),
  // so we only alert on Python 2.
  major_version() = 2
select call, "Call to 'next()' in a generator."
