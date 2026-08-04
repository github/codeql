/**
 * Provides classes and predicates for working with basic blocks in Java.
 */
overlay[local?]
module;

import java
import Dominance

/** A basic block that ends in an exit node. */
class ExitBlock extends BasicBlock {
  ExitBlock() { this.getLastNode() instanceof ControlFlow::ExitNode }
}
