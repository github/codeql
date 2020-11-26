/** Provides the C# specific parameters for `SsaImplCommon.qll`. */

private import csharp
private import AssignableDefinitions
private import SsaImpl as SsaImpl

class BasicBlock = ControlFlow::BasicBlock;

BasicBlock getImmediateDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

class ExitBasicBlock = ControlFlow::BasicBlocks::ExitBlock;

class ReadKind = SsaImpl::ReadKind;

class SourceVariable = SsaImpl::TSourceVariable;

predicate variableWrite = SsaImpl::variableWrite/4;

predicate variableRead = SsaImpl::variableRead/4;
