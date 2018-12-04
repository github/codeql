import AliasAnalysis
import cpp
private import semmle.code.cpp.ir.implementation.raw.IR
private import semmle.code.cpp.ir.internal.OperandTag
private import semmle.code.cpp.ir.internal.Overlap

private newtype TVirtualVariable =
  MkVirtualVariable(IRVariable var) {
    not variableAddressEscapes(var)
  }

private VirtualVariable getVirtualVariable(IRVariable var) {
  result.getIRVariable() = var
}

class VirtualVariable extends TVirtualVariable {
  IRVariable var;

  VirtualVariable() {
    this = MkVirtualVariable(var)
  }

  final string toString() {
    result = var.toString()
  }

  final IRVariable getIRVariable() {
    result = var
  }

  // REVIEW: This should just be on MemoryAccess
  final Type getType() {
    result = var.getType()
  }

  final string getUniqueId() {
    result = var.getUniqueId()
  }
}

private newtype TMemoryAccess =
  MkMemoryAccess(VirtualVariable vvar)

private MemoryAccess getMemoryAccess(IRVariable var) {
  result.getVirtualVariable() = getVirtualVariable(var)
}

class MemoryAccess extends TMemoryAccess {
  VirtualVariable vvar;

  MemoryAccess() {
    this = MkMemoryAccess(vvar)
  }

  string toString() {
    result = vvar.toString()
  }

  VirtualVariable getVirtualVariable() {
    result = vvar
  }

  predicate isPartialMemoryAccess() {
    none()
  }
}

Overlap getOverlap(MemoryAccess def, MemoryAccess use) {
  def.getVirtualVariable() = use.getVirtualVariable() and
  result instanceof MustExactlyOverlap
  or
  none() // Avoid compiler error in SSAConstruction
}

MemoryAccess getResultMemoryAccess(Instruction instr) {
  exists(IRVariable var |
    instr.getResultMemoryAccess() instanceof IndirectMemoryAccess and
    resultPointsTo(instr.getAnOperand().(AddressOperand).getDefinitionInstruction(),
      var, 0) and
    result = getMemoryAccess(var)
  )
}

MemoryAccess getOperandMemoryAccess(Operand operand) {
  exists(IRVariable var |
    resultPointsTo(operand.getAddressOperand().getDefinitionInstruction(), var, 0) and
    result = getMemoryAccess(var)
  )
}
