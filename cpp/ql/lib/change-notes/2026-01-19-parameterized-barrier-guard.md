---
category: feature
---
* Added modules `DataFlow::ParameterizedBarrierGuard` and `DataFlow::ParameterizedInstructionBarrierGuard`. These modules provide the same features as `DataFlow::BarrierGuard` and `DataFlow::InstructionBarrierGuard`, but allow for an additional parameter to support properly using them in dataflow configurations that uses flow states.