/**
 * @name Count IR inconsistencies
 * @description Counts the various IR inconsistencies that may occur.
 *              This query is for internal use only and may change without notice.
 * @kind table
 * @id cpp/count-ir-inconsistencies
 */

import cpp
import semmle.code.cpp.ir.implementation.aliased_ssa.IR
import semmle.code.cpp.ir.implementation.aliased_ssa.IRConsistency as IRConsistency

class PresentIRFunction extends IRConsistency::PresentIRFunction {
  override string toString() {
    result = min(string name | name = this.getIRFunction().getFunction().getQualifiedName() | name)
  }
}

select count(Instruction i | IRConsistency::missingOperand(i, _, _, _) | i) as missingOperand,
  count(Instruction i | IRConsistency::unexpectedOperand(i, _, _, _) | i) as unexpectedOperand,
  count(Instruction i | IRConsistency::duplicateOperand(i, _, _, _) | i) as duplicateOperand,
  count(PhiInstruction i | IRConsistency::missingPhiOperand(i, _, _, _) | i) as missingPhiOperand,
  count(Operand o | IRConsistency::missingOperandType(o, _, _, _) | o) as missingOperandType,
  count(ChiInstruction i | IRConsistency::duplicateChiOperand(i, _, _, _) | i) as duplicateChiOperand,
  count(Instruction i | IRConsistency::sideEffectWithoutPrimary(i, _, _, _) | i) as sideEffectWithoutPrimary,
  count(Instruction i | IRConsistency::instructionWithoutSuccessor(i, _, _, _) | i) as instructionWithoutSuccessor,
  count(Instruction i | IRConsistency::ambiguousSuccessors(i, _, _, _) | i) as ambiguousSuccessors,
  count(Instruction i | IRConsistency::unexplainedLoop(i, _, _, _) | i) as unexplainedLoop,
  count(PhiInstruction i | IRConsistency::unnecessaryPhiInstruction(i, _, _, _) | i) as unnecessaryPhiInstruction,
  count(Instruction i | IRConsistency::memoryOperandDefinitionIsUnmodeled(i, _, _, _) | i) as memoryOperandDefinitionIsUnmodeled,
  count(Operand o | IRConsistency::operandAcrossFunctions(o, _, _, _, _, _) | o) as operandAcrossFunctions,
  count(IRFunction f | IRConsistency::containsLoopOfForwardEdges(f, _) | f) as containsLoopOfForwardEdges,
  count(IRBlock i | IRConsistency::lostReachability(i, _, _, _) | i) as lostReachability,
  count(string m | IRConsistency::backEdgeCountMismatch(_, m) | m) as backEdgeCountMismatch,
  count(Operand o | IRConsistency::useNotDominatedByDefinition(o, _, _, _) | o) as useNotDominatedByDefinition,
  count(SwitchInstruction i | IRConsistency::switchInstructionWithoutDefaultEdge(i, _, _, _) | i) as switchInstructionWithoutDefaultEdge,
  count(Instruction i | IRConsistency::notMarkedAsConflated(i, _, _, _) | i) as notMarkedAsConflated,
  count(Instruction i | IRConsistency::wronglyMarkedAsConflated(i, _, _, _) | i) as wronglyMarkedAsConflated,
  count(MemoryOperand o | IRConsistency::invalidOverlap(o, _, _, _) | o) as invalidOverlap,
  count(Instruction i | IRConsistency::nonUniqueEnclosingIRFunction(i, _, _, _) | i) as nonUniqueEnclosingIRFunction,
  count(FieldAddressInstruction i | IRConsistency::fieldAddressOnNonPointer(i, _, _, _) | i) as fieldAddressOnNonPointer,
  count(Instruction i | IRConsistency::thisArgumentIsNonPointer(i, _, _, _) | i) as thisArgumentIsNonPointer,
  count(Instruction i | IRConsistency::nonUniqueIRVariable(i, _, _, _) | i) as nonUniqueIRVariable,
  count(Instruction i | IRConsistency::nonBooleanOperand(i, _, _, _) | i) as nonBooleanOperand
