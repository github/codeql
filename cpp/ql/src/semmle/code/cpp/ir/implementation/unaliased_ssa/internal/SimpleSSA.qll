import AliasAnalysis
import cpp
private import semmle.code.cpp.ir.implementation.raw.IR
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints
private import semmle.code.cpp.ir.internal.OperandTag
private import semmle.code.cpp.ir.internal.Overlap

private class IntValue = Ints::IntValue;

private predicate hasResultMemoryAccess(Instruction instr, IRVariable var, Type type, IntValue bitOffset) {
  resultPointsTo(instr.getResultAddressOperand().getAnyDef(), var, bitOffset) and
  type = instr.getResultType()
}

private predicate hasOperandMemoryAccess(MemoryOperand operand, IRVariable var, Type type, IntValue bitOffset) {
  resultPointsTo(operand.getAddressOperand().getAnyDef(), var, bitOffset) and
  type = operand.getType()
}

/**
 * Holds if the specified variable should be modeled in SSA form. For unaliased SSA, we only model a variable if its
 * address never escapes and all reads and writes of that variable access the entire variable using the original type
 * of the variable.
 */
private predicate isVariableModeled(IRVariable var) {
  not variableAddressEscapes(var) and
  // There's no need to check for the right size. An `IRVariable` never has an `UnknownType`, so the test for
  // `type = var.getType()` is sufficient.
  forall(Instruction instr, Type type, IntValue bitOffset |
    hasResultMemoryAccess(instr, var, type, bitOffset) |
    bitOffset = 0 and
    type = var.getType()
  ) and
  forall(MemoryOperand operand, Type type, IntValue bitOffset |
    hasOperandMemoryAccess(operand, var, type, bitOffset) |
    bitOffset = 0 and
    type = var.getType()
  )
}

private newtype TMemoryLocation =
  MkMemoryLocation(IRVariable var) {
    isVariableModeled(var)
  }

private MemoryLocation getMemoryLocation(IRVariable var) {
  result.getIRVariable() = var
}

class MemoryLocation extends TMemoryLocation {
  IRVariable var;

  MemoryLocation() {
    this = MkMemoryLocation(var)
  }

  final string toString() {
    result = var.toString()
  }

  final IRVariable getIRVariable() {
    result = var
  }

  final VirtualVariable getVirtualVariable() {
    result = this
  }

  final Type getType() {
    result = var.getType()
  }

  final string getUniqueId() {
    result = var.getUniqueId()
  }
}

class VirtualVariable extends MemoryLocation {
}

Overlap getOverlap(MemoryLocation def, MemoryLocation use) {
  def = use and result instanceof MustExactlyOverlap
  or
  none() // Avoid compiler error in SSAConstruction
}

MemoryLocation getResultMemoryLocation(Instruction instr) {
  exists(IRVariable var |
    hasResultMemoryAccess(instr, var, _, _) and
    result = getMemoryLocation(var)
  )
}

MemoryLocation getOperandMemoryLocation(MemoryOperand operand) {
  exists(IRVariable var |
    hasOperandMemoryAccess(operand, var, _, _) and
    result = getMemoryLocation(var)
  )
}
