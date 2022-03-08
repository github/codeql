/**
 * Semantic interface to the control flow graph.
 */

private import java
private import SemanticExpr
private import SemanticCFGSpecific::SemanticCFGConfig as Specific

class SemBasicBlock extends Specific::BasicBlock {
  final predicate bbDominates(SemBasicBlock otherBlock) { Specific::bbDominates(this, otherBlock) }

  final predicate hasDominanceInformation() { Specific::hasDominanceInformation(this) }

  final SemExpr getAnExpr() { result.getBasicBlock() = this }
}
