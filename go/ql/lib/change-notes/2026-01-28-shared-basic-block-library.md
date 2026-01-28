---
category: breaking
---
* The `BasicBlock` class is now defined using the shared basic blocks library. `BasicBlock.getRoot` has been replaced by `BasicBlock.getScope`. `BasicBlock.getAPrededecessor` and `BasicBlock.getASuccessor` now take a `SuccessorType` argument. `ReachableJoinBlock.inDominanceFrontierOf` has been removed, so use `BasicBlock.inDominanceFrontier` instead, swapping the receiver and the argument.
