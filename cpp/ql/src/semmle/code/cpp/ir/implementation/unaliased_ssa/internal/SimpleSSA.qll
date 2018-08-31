import SimpleSSAInternal
import cpp
import Alias
private import InputIR
import semmle.code.cpp.ir.internal.Overlap

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
}

Overlap getOverlap(MemoryAccess def, MemoryAccess use) {
  def.getVirtualVariable() = use.getVirtualVariable() and
  result instanceof MustExactlyOverlap
}

MemoryAccess getResultMemoryAccess(Instruction instr) {
  exists(IRVariable var |
    instr.getResultMemoryAccess() instanceof IndirectMemoryAccess and
    resultPointsTo(instr.getOperand(loadStoreAddressOperand()), var, 0) and
    result = getMemoryAccess(var)
  )
}

MemoryAccess getOperandMemoryAccess(Instruction instr, OperandTag tag) {
  exists(IRVariable var |
    instr.getOperandMemoryAccess(tag) instanceof IndirectMemoryAccess and
    resultPointsTo(instr.getOperand(loadStoreAddressOperand()), var, 0) and
    result = getMemoryAccess(var)
  )
}
