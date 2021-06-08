/** Provides the C# specific parameters for `SsaImplCommon.qll`. */

private import csharp
private import AssignableDefinitions
private import SsaImpl as SsaImpl

class BasicBlock = ControlFlow::BasicBlock;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

class ExitBasicBlock = ControlFlow::BasicBlocks::ExitBlock;

class SourceVariable = SsaImpl::TSourceVariable;

predicate variableWrite = SsaImpl::variableWrite/4;

predicate variableRead = SsaImpl::variableRead/4;
