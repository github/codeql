---
category: feature
---
* Added a class `DataFlow::IndirectParameterNode` to represent the indirection of a parameter as a dataflow node.
* Added a predicate `Node::asIndirectInstruction` which returns the `Instruction` that defines the indirect dataflow node, if any.