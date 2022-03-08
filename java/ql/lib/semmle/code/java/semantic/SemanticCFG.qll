/**
 * Semantic interface to the control flow graph.
 */

private import java
private import SemanticExpr
private import SemanticExprSpecific

private newtype TSemBasicBlock = MkSemBasicBlock(BasicBlock block)

class SemBasicBlock extends TSemBasicBlock {
  BasicBlock block;

  SemBasicBlock() { this = MkSemBasicBlock(block) }

  final string toString() { result = block.toString() }

  final Location getLocation() { result = block.getLocation() }

  final predicate bbDominates(SemBasicBlock otherBlock) {
    block.bbDominates(getJavaBasicBlock(otherBlock))
  }

  final SemExpr getAnExpr() { SemanticExprConfig::getExprBasicBlock(result) = this }
}

SemBasicBlock getSemanticBasicBlock(BasicBlock block) { result = MkSemBasicBlock(block) }

BasicBlock getJavaBasicBlock(SemBasicBlock block) { block = getSemanticBasicBlock(result) }

predicate semHasDominanceInformation(SemBasicBlock bb) {
  hasDominanceInformation(getJavaBasicBlock(bb))
}
