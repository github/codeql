/**
 * Provides Java-specific definitions for use in the `SsaReadPosition`.
 */

private import semmle.code.java.dataflow.SSA as Ssa
private import semmle.code.java.controlflow.BasicBlocks as BB

class SsaVariable = Ssa::SsaVariable;

class SsaPhiNode = Ssa::SsaPhiNode;

class BasicBlock = BB::BasicBlock;

/** Gets a basic block in which SSA variable `v` is read. */
BasicBlock getAReadBasicBlock(SsaVariable v) { result = v.getAUse().getBasicBlock() }
