private import swift
private import Completion
private import ControlFlowGraphImplSpecific::CfgImpl
private import ControlFlowElements

abstract class AstControlFlowTree extends ControlFlowTree {
  AstNode ast;

  AstControlFlowTree() { ast = this.asAstNode() }

  AstNode getAst() { result = ast }
}

/**
 * Holds if `first` is the first element executed within control flow
 * element `cft`.
 */
predicate astFirst(AstNode cft, ControlFlowElement first) {
  first(any(ControlFlowTree tree | cft = tree.asAstNode()), first)
}

/**
 * Holds if `last` with completion `c` is a potential last element executed
 * within control flow element `cft`.
 */
predicate astLast(AstNode cft, ControlFlowElement last, Completion c) {
  last(any(ControlFlowTree tree | cft = tree.asAstNode()), last, c)
}

abstract class AstPreOrderTree extends AstControlFlowTree, PreOrderTree { }

abstract class AstPostOrderTree extends AstControlFlowTree, PostOrderTree { }

abstract class AstStandardTree extends AstControlFlowTree, StandardTree { }

abstract class AstStandardPreOrderTree extends AstStandardTree, StandardPreOrderTree { }

abstract class AstStandardPostOrderTree extends AstStandardTree, StandardPostOrderTree { }

abstract class AstLeafTree extends AstPreOrderTree, AstPostOrderTree, LeafTree { }
