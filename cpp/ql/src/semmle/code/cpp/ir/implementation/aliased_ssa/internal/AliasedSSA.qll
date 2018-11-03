import cpp
import AliasAnalysis
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import semmle.code.cpp.ir.internal.OperandTag
private import semmle.code.cpp.ir.internal.Overlap

import semmle.code.cpp.ir.internal.Overlap
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints

private class IntValue = Ints::IntValue;

private newtype TVirtualVariable =
  TVirtualIRVariable(IRVariable var) {
    not variableAddressEscapes(var)
  } or
  TUnknownVirtualVariable(FunctionIR f)

private VirtualIRVariable getVirtualVariable(IRVariable var) {
  result.getIRVariable() = var
}

class VirtualVariable extends TVirtualVariable {
  string toString() {
    none()
  }
  
  string getUniqueId() {
    none()
  }
  
  Type getType() {
    none()
  }
}

class VirtualIRVariable extends VirtualVariable, TVirtualIRVariable {
  IRVariable var;

  VirtualIRVariable() {
    this = TVirtualIRVariable(var)
  }

  override final string toString() {
    result = var.toString()
  }

  final IRVariable getIRVariable() {
    result = var
  }

  // REVIEW: This should just be on MemoryAccess
  override final Type getType() {
    result = var.getType()
  }

  override final string getUniqueId() {
    result = var.getUniqueId()
  }
}

class UnknownVirtualVariable extends VirtualVariable, TUnknownVirtualVariable {
  FunctionIR f;
  
  UnknownVirtualVariable() {
    this = TUnknownVirtualVariable(f)
  }
  
  override final string toString() {
    result = "UnknownVvar(" + f + ")"
  }
  
  override final string getUniqueId() {
    result = "UnknownVvar(" + f + ")"
  }
  
  override final Type getType() {
    result instanceof UnknownType
  }
  
  final FunctionIR getFunctionIR() {
    result = f
  }
}

private newtype TMemoryAccess =
  TVariableMemoryAccess(VirtualIRVariable vvar, IntValue offset, IntValue size) {
    exists(Instruction instr |
      exists(MemoryAccessKind mak | instr.getResultMemoryAccess() = mak and not mak instanceof PhiMemoryAccess) and
      resultPointsTo(instr.getAnOperand().(AddressOperand).getDefinitionInstruction(), vvar.getIRVariable(), offset) and
      if exists(instr.getResultSize())
      then instr.getResultSize() = size
      else size = Ints::unknown()
    )
  }
  or
  TUnknownMemoryAccess(UnknownVirtualVariable uvv)

private VariableMemoryAccess getVariableMemoryAccess(IRVariable var, IntValue offset, IntValue size) {
  result.getVirtualVariable() = getVirtualVariable(var) and
  result.getOffset() = offset and
  result.getSize() = size
}

class MemoryAccess extends TMemoryAccess {
  string toString() {
    none()
  }
  
  VirtualVariable getVirtualVariable() {
    none()
  }

  predicate isPartialMemoryAccess() {
    none()
  }
}

class VariableMemoryAccess extends TVariableMemoryAccess, MemoryAccess {
  VirtualIRVariable vvar;
  IntValue offset;
  IntValue size;

  VariableMemoryAccess() {
    this = TVariableMemoryAccess(vvar, offset, size)
  }

  override final string toString() {
    result = vvar.toString()
  }

  final override VirtualVariable getVirtualVariable() {
    result = vvar
  }
  
  IntValue getOffset() {
    result = offset
  }
  
  IntValue getSize() {
    result = size
  }
  
  final override predicate isPartialMemoryAccess() {
    getOffset() != 0
    or
    getSize() != vvar.getType().getSize()
  }
}

class UnknownMemoryAccess extends TUnknownMemoryAccess, MemoryAccess {
  UnknownVirtualVariable vvar;
  
  UnknownMemoryAccess() {
    this = TUnknownMemoryAccess(vvar)
  }
  
  final override string toString() {
    result = vvar.toString()
  }
  
  final override VirtualVariable getVirtualVariable() {
    result = vvar
  }
  
  final override predicate isPartialMemoryAccess() {
    any()
  }
  Type getType() {
    result instanceof UnknownType
  }
}

Overlap getOverlap(MemoryAccess def, MemoryAccess use) {
  def instanceof VariableMemoryAccess and
  def = use and
  result instanceof MustExactlyOverlap
  or
  exists(VariableMemoryAccess defVMA, VariableMemoryAccess useVMA, int defOffset, int defEnd,
         int useOffset, int useEnd |
    defVMA = def and
    useVMA = use and
    defVMA.getVirtualVariable() = useVMA.getVirtualVariable() and
    defVMA != useVMA and
    defOffset = Ints::getValue(defVMA.getOffset()) and
    defEnd = Ints::getValue(Ints::add(defVMA.getOffset(), defVMA.getSize())) and
    useOffset = Ints::getValue(useVMA.getOffset()) and
    useEnd = Ints::getValue(Ints::add(useVMA.getOffset(), useVMA.getSize()))
    |
    defOffset <= useOffset and
    defEnd >= useEnd and
    result instanceof MustTotallyOverlap
    or
    defOffset > useOffset and
    defOffset < useEnd and
    result instanceof MayPartiallyOverlap
    or
    defOffset = useOffset and
    defEnd < useEnd and
    result instanceof MayPartiallyOverlap
  )
  or
  exists(UnknownVirtualVariable uvv |
    uvv = def.getVirtualVariable() and
    uvv = use.getVirtualVariable() and
    result instanceof MayPartiallyOverlap
  )
}

MemoryAccess getResultMemoryAccess(Instruction instr) {
  exists(instr.getResultMemoryAccess()) and
  if exists(IRVariable var, IntValue i |
    resultPointsTo(instr.getAnOperand().(AddressOperand).getDefinitionInstruction(), var, i)
  )
  then exists(IRVariable var, IntValue i |
    resultPointsTo(instr.getAnOperand().(AddressOperand).getDefinitionInstruction(), var, i) and
    result = getVariableMemoryAccess(var, i, instr.getResultSize())
  )
  else
    result = TUnknownMemoryAccess(TUnknownVirtualVariable(instr.getFunctionIR()))
}

MemoryAccess getOperandMemoryAccess(Operand operand) {
  exists(operand.getMemoryAccess()) and
  if exists(IRVariable var, IntValue i |
    resultPointsTo(operand.getAddressOperand().getDefinitionInstruction(), var, i)
  )
  then exists(IRVariable var, IntValue i |
    resultPointsTo(operand.getAddressOperand().getDefinitionInstruction(), var, i) and
    result = getVariableMemoryAccess(var, i, operand.getDefinitionInstruction().getResultSize())
  )
  else
    result = TUnknownMemoryAccess(TUnknownVirtualVariable(operand.getInstruction().getFunctionIR()))
}
