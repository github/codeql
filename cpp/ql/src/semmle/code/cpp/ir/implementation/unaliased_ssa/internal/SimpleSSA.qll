import AliasAnalysis
private import cpp
private import AliasConfiguration
private import semmle.code.cpp.ir.implementation.raw.IR
private import semmle.code.cpp.ir.internal.Overlap
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints

/**
 * Holds if the specified variable should be modeled in SSA form. For unaliased SSA, we only model a
 * variable if its address never escapes and all reads and writes of that variable access the entire
 * variable using the original type of the variable.
 */
private predicate isVariableModeled(Allocation var) {
  not allocationEscapes(var) and
  forall(AddressOperand addrOperand, Type type |
    (
      exists(Instruction instr |
        addrOperand = instr.getResultAddressOperand() and
        type = instr.getResultType()
      ) or
      exists(MemoryOperand operand |
        addrOperand = operand.getAddressOperand() and
        type = operand.getType()
      )
    ) and
    getAddressOperandAllocation(addrOperand) = var |
    exists(Instruction constantBase, int bitOffset |
      addressOperandBaseAndConstantOffset(addrOperand, constantBase, bitOffset) and
      bitOffset = 0 and
      constantBase = var.getABaseInstruction() and
      // There's no need to check for the right size. An `IRVariable` never has an `UnknownType`, so
      // the test for the right type is sufficient.
      type = var.getType()
    )
  )
}

private newtype TMemoryLocation =
  MkMemoryLocation(Allocation var) {
    isVariableModeled(var)
  }

private MemoryLocation getMemoryLocation(Allocation var) {
  result.getAllocation() = var
}

class MemoryLocation extends TMemoryLocation {
  Allocation var;

  MemoryLocation() {
    this = MkMemoryLocation(var)
  }

  final string toString() {
    result = var.getAllocationString()
  }

  final Allocation getAllocation() {
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
  result = getMemoryLocation(getAddressOperandAllocation(instr.getResultAddressOperand()))
}

MemoryLocation getOperandMemoryLocation(MemoryOperand operand) {
  result = getMemoryLocation(getAddressOperandAllocation(operand.getAddressOperand()))
}
