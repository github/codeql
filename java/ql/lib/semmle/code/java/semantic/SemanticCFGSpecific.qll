private import java as J
private import SemanticCFG

module SemanticCFGConfig {
  class BasicBlock instanceof J::BasicBlock {
    final string toString() { result = this.(J::BasicBlock).toString() }

    final J::Location getLocation() { result = this.(J::BasicBlock).getLocation() }
  }

  predicate bbDominates(BasicBlock dominator, BasicBlock dominated) {
    dominator.(J::BasicBlock).bbDominates(dominated.(J::BasicBlock))
  }

  predicate hasDominanceInformation(BasicBlock block) { J::hasDominanceInformation(block) }
}

SemBasicBlock getSemanticBasicBlock(J::BasicBlock block) { result = block }

J::BasicBlock getJavaBasicBlock(SemBasicBlock block) { block = getSemanticBasicBlock(result) }
