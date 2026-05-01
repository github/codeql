/**
 * Provides utilities for working with basic blocks in tests.
 */
overlay[local?]
module;

import java
import codeql.util.Boolean

private predicate entryOrExit(ControlFlowNode n) {
  n instanceof ControlFlow::EntryNode or
  n instanceof ControlFlow::AnnotatedExitNode or
  n instanceof ControlFlow::ExitNode
}

/** Gets the first AST node in the basic block `bb`, if any. */
ControlFlowNode getFirstAstNode(BasicBlock bb) { result = getFirstAstNode(bb, false) }

/**
 * Gets the first AST node in the basic block `bb`, if any. Otherwise, gets
 * the first synthetic node.
 */
ControlFlowNode getFirstAstNodeOrSynth(BasicBlock bb) { result = getFirstAstNode(bb, true) }

private ControlFlowNode getFirstAstNode(BasicBlock bb, Boolean allowSynthetic) {
  result =
    min(ControlFlowNode n, int i, int astOrder |
      bb.getNode(i) = n and
      if n.injects(_)
      then astOrder = 0
      else
        if entryOrExit(n)
        then astOrder = 1
        else (
          allowSynthetic = true and astOrder = 2
        )
    |
      n order by astOrder, i
    )
}
