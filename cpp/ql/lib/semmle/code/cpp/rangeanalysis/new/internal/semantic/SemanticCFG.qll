/**
 * Semantic interface to the control flow graph.
 */

private import Semantic
private import SemanticExprSpecific::SemanticExprConfig as Specific

/**
 * A basic block in the control-flow graph.
 */
class SemBasicBlock extends Specific::BasicBlock {
  /** Holds if this block (transitively) dominates `otherblock`. */
  final predicate bbDominates(SemBasicBlock otherBlock) { Specific::bbDominates(this, otherBlock) }

  /** Gets an expression that is evaluated in this basic block. */
  final SemExpr getAnExpr() { result.getBasicBlock() = this }

  final int getUniqueId() { result = Specific::getBasicBlockUniqueId(this) }
}
