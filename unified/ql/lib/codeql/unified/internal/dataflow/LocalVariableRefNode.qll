private import unified
private import AllDataFlow

/**
 * A reference to a local variable (read, write, or post-update).
 *
 * This is backed by same entity as the corresponding data-flow node, but is referenced before
 * the full `Node` type has been materialised (during SSA construction).
 */
class LocalVariableRefNode extends BuilderNode, TLocalVariableRefNode {
  private AstNode repr;
  private LocalVariable var;
  private VariableRefKind kind;

  LocalVariableRefNode() { this = TLocalVariableRefNode(repr, var, kind) }

  predicate hasCfgNode(BasicBlock bb, int i) {
    this = TLocalVariableRefNode(repr, var, kind) and
    performsVariableAccess(repr, var, kind, bb.getNode(i))
  }

  LocalVariable getVariable() { result = var }

  VariableRefKind getRefKind() { result = kind }
}
