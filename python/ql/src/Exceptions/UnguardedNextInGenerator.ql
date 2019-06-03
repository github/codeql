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

FunctionObject iter() {
    result = Object::builtin("iter")
}

BuiltinFunctionObject next() {
    result = Object::builtin("next")
}

predicate call_to_iter(CallNode call, EssaVariable sequence) {
    sequence.getAUse() = iter().getArgumentForCall(call, 0)
}

predicate call_to_next(CallNode call, ControlFlowNode iter) {
    iter = next().getArgumentForCall(call, 0)
}

predicate guarded_not_empty_sequence(EssaVariable sequence) {
    sequence.getDefinition() instanceof EssaEdgeRefinement
}

/** The pattern `next(iter(x))` is often used where `x` is known not be empty. Check for that. */
predicate iter_not_exhausted(EssaVariable iterator) {
    exists(EssaVariable sequence |
        call_to_iter(iterator.getDefinition().(AssignmentDefinition).getValue(), sequence) and
        guarded_not_empty_sequence(sequence)
    )
}

predicate stop_iteration_handled(CallNode call) {
    exists(Try t |
        t.containsInScope(call.getNode()) and
        t.getAHandler().getType().refersTo(theStopIterationType())
    )
}

from CallNode call
where call_to_next(call, _) and
not exists(EssaVariable iterator |
    call_to_next(call, iterator.getAUse()) and
    iter_not_exhausted(iterator)
) and
call.getNode().getScope().(Function).isGenerator() and
not exists(Comp comp | comp.contains(call.getNode())) and
not stop_iteration_handled(call)

select call, "Call to next() in a generator"

