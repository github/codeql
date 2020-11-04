/**
 * Provides C#-specific definitions for use in the `SsaReadPosition`.
 */

private import csharp

class SsaVariable = Ssa::Definition;

class SsaPhiNode = Ssa::PhiNode;

class BasicBlock = Ssa::BasicBlock;

/** Gets a basic block in which SSA variable `v` is read. */
BasicBlock getAReadBasicBlock(SsaVariable v) {
  result = v.getARead().getAControlFlowNode().getBasicBlock()
}
