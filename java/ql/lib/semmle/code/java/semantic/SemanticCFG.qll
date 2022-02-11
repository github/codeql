/**
 * Semantic interface to the control flow graph.
 */

private import java

private newtype TSemBasicBlock = MkSemBasicBlock(BasicBlock block)

class SemBasicBlock extends TSemBasicBlock {
  BasicBlock block;

  SemBasicBlock() { this = MkSemBasicBlock(block) }

  final string toString() { result = block.toString() }

  final predicate bbDominates(SemBasicBlock otherBlock) {
    block.bbDominates(getJavaBasicBlock(otherBlock))
  }
}

SemBasicBlock getSemanticBasicBlock(BasicBlock block) { result = MkSemBasicBlock(block) }

BasicBlock getJavaBasicBlock(SemBasicBlock block) { block = getSemanticBasicBlock(result) }

predicate semHasDominanceInformation(SemBasicBlock bb) {
  hasDominanceInformation(getJavaBasicBlock(bb))
}
