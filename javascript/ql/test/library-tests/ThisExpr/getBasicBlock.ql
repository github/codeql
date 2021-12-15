import javascript

query predicate missingBasicBlock(DataFlow::ThisNode node) { not exists(node.getBasicBlock()) }

query BasicBlock basicBlock(DataFlow::ThisNode node) { result = node.getBasicBlock() }
