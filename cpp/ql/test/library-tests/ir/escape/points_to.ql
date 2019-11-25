import default
import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.AliasAnalysis as RawAA
import semmle.code.cpp.ir.implementation.raw.IR as Raw
import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasAnalysis as UnAA
import semmle.code.cpp.ir.implementation.unaliased_ssa.IR as Un
import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.SSAConstruction
import semmle.code.cpp.ir.internal.IntegerConstant

from Raw::Instruction rawInstr, Un::Instruction unInstr, string rawPointsTo, string unPointsTo
where
  rawInstr = getOldInstruction(unInstr) and
  not rawInstr instanceof Raw::VariableAddressInstruction and
  (
    exists(Variable var, int rawBitOffset, int unBitOffset |
      RawAA::resultPointsTo(rawInstr, Raw::getIRUserVariable(_, var), rawBitOffset) and
      rawPointsTo = var.toString() + getBitOffsetString(rawBitOffset) and
      UnAA::resultPointsTo(unInstr, Un::getIRUserVariable(_, var), unBitOffset) and
      unPointsTo = var.toString() + getBitOffsetString(unBitOffset)
    )
    or
    exists(Variable var, int unBitOffset |
      not RawAA::resultPointsTo(rawInstr, Raw::getIRUserVariable(_, var), _) and
      rawPointsTo = "none" and
      UnAA::resultPointsTo(unInstr, Un::getIRUserVariable(_, var), unBitOffset) and
      unPointsTo = var.toString() + getBitOffsetString(unBitOffset)
    )
    or
    exists(Variable var, int rawBitOffset |
      RawAA::resultPointsTo(rawInstr, Raw::getIRUserVariable(_, var), rawBitOffset) and
      rawPointsTo = var.toString() + getBitOffsetString(rawBitOffset) and
      not UnAA::resultPointsTo(unInstr, Un::getIRUserVariable(_, var), _) and
      unPointsTo = "none"
    )
  )
select rawInstr.getLocation().toString(), rawInstr.getOperationString(), rawPointsTo, unPointsTo
