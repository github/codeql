import csharp
import ControlFlow

from BasicBlocks::ConditionBlock cb, BasicBlock controlled, boolean testIsTrue
where
  cb.controls(controlled, any(SuccessorTypes::ConditionalSuccessor s | testIsTrue = s.getValue()))
select cb.getLastNode(), controlled.getFirstNode(), testIsTrue
