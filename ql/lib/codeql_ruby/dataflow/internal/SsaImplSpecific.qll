/** Provides the Ruby specific parameters for `SsaImplCommon.qll`. */

private import SsaImpl as SsaImpl
private import codeql_ruby.AST
private import codeql_ruby.ast.Parameter
private import codeql_ruby.ast.Variable
private import codeql_ruby.controlflow.BasicBlocks as BasicBlocks
private import codeql_ruby.controlflow.ControlFlowGraph

class BasicBlock = BasicBlocks::BasicBlock;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

class ExitBasicBlock = BasicBlocks::ExitBasicBlock;

class SourceVariable = LocalVariable;

predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  (
    SsaImpl::uninitializedWrite(bb, i, v)
    or
    SsaImpl::capturedEntryWrite(bb, i, v)
    or
    SsaImpl::variableWriteActual(bb, i, v, _)
  ) and
  certain = true
  or
  SsaImpl::capturedCallWrite(bb, i, v) and
  certain = false
}

predicate variableRead = SsaImpl::variableRead/4;
