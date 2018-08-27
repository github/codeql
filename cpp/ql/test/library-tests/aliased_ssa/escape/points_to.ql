import default
import semmle.code.cpp.ssa.internal.ssa.AliasAnalysis
import semmle.code.cpp.ir.IR

from Instruction instr, string pointsTo
where
  exists(IRVariable var, int bitOffset |
    resultPointsTo(instr, var, bitOffset) and
    pointsTo = var.toString() + getBitOffsetString(bitOffset)
  )
select instr.getLocation().toString(), instr.getOperationString(), pointsTo
