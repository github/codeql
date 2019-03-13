import cpp
import AliasAnalysis
import semmle.code.cpp.ir.internal.Overlap
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints
private import semmle.code.cpp.ir.internal.IntegerInterval as Interval
private import semmle.code.cpp.ir.internal.OperandTag

private class IntValue = Ints::IntValue;

private newtype TVirtualVariable =
  TVirtualIRVariable(IRVariable var) {
    not variableAddressEscapes(var)
  } or
  TUnknownVirtualVariable(IRFunction f)

private VirtualIRVariable getVirtualVariable(IRVariable var) {
  result.getIRVariable() = var
}

private UnknownVirtualVariable getUnknownVirtualVariable(IRFunction f) {
  result.getEnclosingIRFunction() = f
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

/**
 * A virtual variable representing a single non-escaped `IRVariable`.
 */
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

  override final Type getType() {
    result = var.getType()
  }

  override final string getUniqueId() {
    result = var.getUniqueId()
  }
}

/**
 * A virtual variable representing all escaped memory accessible by the function,
 * including escaped local variables.
 */
class UnknownVirtualVariable extends VirtualVariable, TUnknownVirtualVariable {
  IRFunction f;
  
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
  
  final IRFunction getEnclosingIRFunction() {
    result = f
  }
}

private predicate hasResultMemoryAccess(Instruction instr, IRVariable var, IntValue startBitOffset,
    IntValue endBitOffset) {
  resultPointsTo(instr.getResultAddressOperand().getDefinitionInstruction(), var, startBitOffset) and
  if exists(instr.getResultSize()) then
    endBitOffset = Ints::add(startBitOffset, Ints::mul(instr.getResultSize(), 8))
  else
    endBitOffset = Ints::unknown()
}

private predicate hasOperandMemoryAccess(MemoryOperand operand, IRVariable var, IntValue startBitOffset,
    IntValue endBitOffset) {
  resultPointsTo(operand.getAddressOperand().getDefinitionInstruction(), var, startBitOffset) and
  if exists(operand.getSize()) then
    endBitOffset = Ints::add(startBitOffset, Ints::mul(operand.getSize(), 8))
  else
    endBitOffset = Ints::unknown()
}

private newtype TMemoryAccess =
  TVariableMemoryAccess(IRVariable var, IntValue startBitOffset, IntValue endBitOffset) {
    hasResultMemoryAccess(_, var, startBitOffset, endBitOffset) or
    hasOperandMemoryAccess(_, var, startBitOffset, endBitOffset)
  }
  or
  TUnknownMemoryAccess(UnknownVirtualVariable uvv) or
  TTotalUnknownMemoryAccess(UnknownVirtualVariable uvv)

private VariableMemoryAccess getVariableMemoryAccess(IRVariable var, IntValue startBitOffset, IntValue endBitOffset) {
  result = TVariableMemoryAccess(var, startBitOffset, endBitOffset)
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

/**
 * An access to memory within a single known `IRVariable`. The variable may be either an unescaped variable
 * (with its own `VirtualIRVariable`) or an escaped variable (assiged to `UnknownVirtualVariable`).
 */
class VariableMemoryAccess extends TVariableMemoryAccess, MemoryAccess {
  IRVariable var;
  IntValue startBitOffset;
  IntValue endBitOffset;

  VariableMemoryAccess() {
    this = TVariableMemoryAccess(var, startBitOffset, endBitOffset)
  }

  override final string toString() {
    exists(string partialString |
      result = var.toString() + Interval::getIntervalString(startBitOffset, endBitOffset) + partialString and
      if isPartialMemoryAccess() then
        partialString = " (partial)"
      else
        partialString = ""
    )
  }

  final override VirtualVariable getVirtualVariable() {
    result = getVirtualVariable(var) or
    not exists(getVirtualVariable(var)) and result = getUnknownVirtualVariable(var.getEnclosingIRFunction())
  }
  
  IntValue getStartBitOffset() {
    result = startBitOffset
  }
  
  IntValue getEndBitOffset() {
    result = endBitOffset
  }
  
  final IRVariable getVariable() {
    result = var
  }

  final override predicate isPartialMemoryAccess() {
    not exists(getVirtualVariable(var)) or
    getStartBitOffset() != 0
    or
    not Ints::isEQ(getEndBitOffset(), Ints::add(getStartBitOffset(), Ints::mul(var.getType().getSize(), 8)))
  }
}

/**
 * An access to memory that is not known to be confined to a specific `IRVariable`.
 */
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
}

/**
 * An access to all aliased memory.
 */
class TotalUnknownMemoryAccess extends TTotalUnknownMemoryAccess, MemoryAccess {
  UnknownVirtualVariable vvar;
  
  TotalUnknownMemoryAccess() {
    this = TTotalUnknownMemoryAccess(vvar)
  }
  
  final override string toString() {
    result = vvar.toString()
  }
  
  final override VirtualVariable getVirtualVariable() {
    result = vvar
  }
}

Overlap getOverlap(MemoryAccess def, MemoryAccess use) {
  def.getVirtualVariable() = use.getVirtualVariable() and
  (
    // A TotalUnknownMemoryAccess must totally overlap any access to the same virtual variable.
    def instanceof TotalUnknownMemoryAccess and result instanceof MustTotallyOverlap or
    // An UnknownMemoryAccess may partially overlap any access to the same virtual variable.
    def instanceof UnknownMemoryAccess and result instanceof MayPartiallyOverlap or
    exists(VariableMemoryAccess defVariableAccess |
      defVariableAccess = def and
      (
        (
          // A VariableMemoryAccess may partially overlap an unknown access to the same virtual variable.
          ((use instanceof UnknownMemoryAccess) or (use instanceof TotalUnknownMemoryAccess)) and
          result instanceof MayPartiallyOverlap
        ) or
        // A VariableMemoryAccess overlaps another access to the same variable based on the relationship
        // of the two offset intervals.
        exists(VariableMemoryAccess useVariableAccess, IntValue defStartOffset, IntValue defEndOffset,
            IntValue useStartOffset, IntValue useEndOffset |
          useVariableAccess = use and
          defStartOffset = defVariableAccess.getStartBitOffset() and
          defEndOffset = defVariableAccess.getEndBitOffset() and
          useStartOffset = useVariableAccess.getStartBitOffset() and
          useEndOffset = useVariableAccess.getEndBitOffset() and
          result = Interval::getOverlap(defStartOffset, defEndOffset, useStartOffset, useEndOffset)
        )
      )
    )
  )
}

MemoryAccess getResultMemoryAccess(Instruction instr) {
  exists(MemoryAccessKind kind |
    kind = instr.getResultMemoryAccess() and
    (
      (
        kind.usesAddressOperand() and
        if hasResultMemoryAccess(instr, _, _, _) then (
          exists(IRVariable var, IntValue startBitOffset, IntValue endBitOffset |
            hasResultMemoryAccess(instr, var, startBitOffset, endBitOffset) and
            result = getVariableMemoryAccess(var, startBitOffset, endBitOffset)
          )
        )
        else (
          result = TUnknownMemoryAccess(TUnknownVirtualVariable(instr.getEnclosingIRFunction()))
        )
      ) or
      (
        kind instanceof EscapedMemoryAccess and
        result = TTotalUnknownMemoryAccess(TUnknownVirtualVariable(instr.getEnclosingIRFunction()))
      ) or
      (
        kind instanceof EscapedMayMemoryAccess and
        result = TUnknownMemoryAccess(TUnknownVirtualVariable(instr.getEnclosingIRFunction()))
      )
    )
  )
}

MemoryAccess getOperandMemoryAccess(MemoryOperand operand) {
  exists(MemoryAccessKind kind |
    kind = operand.getMemoryAccess() and
    (
      (
        kind.usesAddressOperand() and
        if hasOperandMemoryAccess(operand, _, _, _) then (
          exists(IRVariable var, IntValue startBitOffset, IntValue endBitOffset |
            hasOperandMemoryAccess(operand, var, startBitOffset, endBitOffset) and
            result = getVariableMemoryAccess(var, startBitOffset, endBitOffset)
          )
        )
        else (
          result = TUnknownMemoryAccess(TUnknownVirtualVariable(operand.getEnclosingIRFunction()))
        )
      ) or
      (
        kind instanceof EscapedMemoryAccess and
        result = TTotalUnknownMemoryAccess(TUnknownVirtualVariable(operand.getEnclosingIRFunction()))
      ) or
      (
        kind instanceof EscapedMayMemoryAccess and
        result = TUnknownMemoryAccess(TUnknownVirtualVariable(operand.getEnclosingIRFunction()))
      )
    )
  )
}
