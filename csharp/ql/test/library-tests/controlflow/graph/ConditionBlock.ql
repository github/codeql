import csharp

from ControlFlow::BasicBlocks::ConditionBlock cb, ControlFlow::BasicBlock controlled, boolean testIsTrue
where cb.controls(controlled, testIsTrue)
select cb.getLastNode(), controlled.getFirstNode(), testIsTrue
