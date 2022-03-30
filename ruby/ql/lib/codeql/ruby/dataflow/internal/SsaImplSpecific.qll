/** Provides the Ruby specific parameters for `SsaImplCommon.qll`. */

private import SsaImpl as SsaImpl
private import codeql.ruby.AST
private import codeql.ruby.ast.Parameter
private import codeql.ruby.ast.Variable
private import codeql.ruby.controlflow.BasicBlocks as BasicBlocks
private import codeql.ruby.controlflow.ControlFlowGraph

class BasicBlock = BasicBlocks::BasicBlock;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

class ExitBasicBlock = BasicBlocks::ExitBasicBlock;

class SourceVariable = LocalVariable;

/**
 * Holds if the statement at index `i` of basic block `bb` contains a write to variable `v`.
 * `certain` is true if the write definitely occurs.
 */
predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  (
    exists(Scope scope | scope = v.(SelfVariable).getDeclaringScope() |
      // We consider the `self` variable to have a single write at the entry to a method block...
      scope = bb.(BasicBlocks::EntryBasicBlock).getScope() and
      i = 0
      or
      // ...or a class or module block.
      bb.getNode(i).getNode() = scope.(ModuleBase).getAControlFlowEntryNode()
    )
    or
    SsaImpl::uninitializedWrite(bb, i, v)
    or
    SsaImpl::capturedEntryWrite(bb, i, v)
    or
    SsaImpl::variableWriteActual(bb, i, v, _)
  ) and
  certain = true
  or
  SsaImpl::capturedCallWrite(_, bb, i, v) and
  certain = false
}

predicate variableRead = SsaImpl::variableRead/4;
