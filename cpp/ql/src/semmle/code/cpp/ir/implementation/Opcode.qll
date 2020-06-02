private import internal.OpcodeImports as Imports
private import internal.OperandTag
import Imports::MemoryAccessKind

private newtype TOpcode =
  TNoOp() or
  TUninitialized() or
  TError() or
  TInitializeParameter() or
  TInitializeIndirection() or
  TInitializeThis() or
  TEnterFunction() or
  TExitFunction() or
  TReturnValue() or
  TReturnVoid() or
  TReturnIndirection() or
  TCopyValue() or
  TLoad() or
  TStore() or
  TAdd() or
  TSub() or
  TMul() or
  TDiv() or
  TRem() or
  TNegate() or
  TShiftLeft() or
  TShiftRight() or
  TBitAnd() or
  TBitOr() or
  TBitXor() or
  TBitComplement() or
  TLogicalNot() or
  TCompareEQ() or
  TCompareNE() or
  TCompareLT() or
  TCompareGT() or
  TCompareLE() or
  TCompareGE() or
  TPointerAdd() or
  TPointerSub() or
  TPointerDiff() or
  TConvert() or
  TConvertToNonVirtualBase() or
  TConvertToVirtualBase() or
  TConvertToDerived() or
  TCheckedConvertOrNull() or
  TCheckedConvertOrThrow() or
  TDynamicCastToVoid() or
  TVariableAddress() or
  TFieldAddress() or
  TFunctionAddress() or
  TElementsAddress() or
  TConstant() or
  TStringConstant() or
  TConditionalBranch() or
  TSwitch() or
  TCall() or
  TCatchByType() or
  TCatchAny() or
  TThrowValue() or
  TReThrow() or
  TUnwind() or
  TAliasedDefinition() or
  TInitializeNonLocal() or
  TAliasedUse() or
  TPhi() or
  TBuiltIn() or
  TVarArgsStart() or
  TVarArgsEnd() or
  TVarArg() or
  TNextVarArg() or
  TCallSideEffect() or
  TCallReadSideEffect() or
  TIndirectReadSideEffect() or
  TIndirectMustWriteSideEffect() or
  TIndirectMayWriteSideEffect() or
  TBufferReadSideEffect() or
  TBufferMustWriteSideEffect() or
  TBufferMayWriteSideEffect() or
  TSizedBufferReadSideEffect() or
  TSizedBufferMustWriteSideEffect() or
  TSizedBufferMayWriteSideEffect() or
  TInitializeDynamicAllocation() or
  TChi() or
  TInlineAsm() or
  TUnreached() or
  TNewObj()

class Opcode extends TOpcode {
  string toString() { result = "UnknownOpcode" }

  /**
   * Gets the kind of memory access performed by this instruction's result.
   * Holds only for opcodes with a memory result.
   */
  MemoryAccessKind getWriteMemoryAccess() { none() }

  /**
   * Gets the kind of memory access performed by this instruction's `MemoryOperand`. Holds only for
   * opcodes that read from memory.
   */
  MemoryAccessKind getReadMemoryAccess() { none() }

  /**
   * Holds if the instruction has an `AddressOperand`.
   */
  predicate hasAddressOperand() { none() }

  /**
   * Holds if the instruction has a `BufferSizeOperand`.
   */
  predicate hasBufferSizeOperand() { none() }

  /**
   * Holds if the instruction's write memory access is a `may` write, as opposed to a `must` write.
   */
  predicate hasMayWriteMemoryAccess() { none() }

  /**
   * Holds if the instruction's read memory access is a `may` read, as opposed to a `must` read.
   */
  predicate hasMayReadMemoryAccess() { none() }

  /**
   * Holds if the instruction must have an operand with the specified `OperandTag`.
   */
  final predicate hasOperand(OperandTag tag) {
    hasOperandInternal(tag)
    or
    hasAddressOperand() and tag instanceof AddressOperandTag
    or
    hasBufferSizeOperand() and tag instanceof BufferSizeOperandTag
  }

  /**
   * Holds if the instruction must have an operand with the specified `OperandTag`, ignoring
   * `AddressOperandTag` and `BufferSizeOperandTag`.
   */
  predicate hasOperandInternal(OperandTag tag) { none() }
}

abstract class UnaryOpcode extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) { tag instanceof UnaryOperandTag }
}

abstract class BinaryOpcode extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) {
    tag instanceof LeftOperandTag or
    tag instanceof RightOperandTag
  }
}

abstract class PointerArithmeticOpcode extends BinaryOpcode { }

abstract class PointerOffsetOpcode extends PointerArithmeticOpcode { }

abstract class ArithmeticOpcode extends Opcode { }

abstract class BinaryArithmeticOpcode extends BinaryOpcode, ArithmeticOpcode { }

abstract class UnaryArithmeticOpcode extends UnaryOpcode, ArithmeticOpcode { }

abstract class BitwiseOpcode extends Opcode { }

abstract class BinaryBitwiseOpcode extends BinaryOpcode, BitwiseOpcode { }

abstract class UnaryBitwiseOpcode extends UnaryOpcode, BitwiseOpcode { }

abstract class CompareOpcode extends BinaryOpcode { }

abstract class RelationalOpcode extends CompareOpcode { }

abstract class CopyOpcode extends Opcode { }

abstract class ConvertToBaseOpcode extends UnaryOpcode { }

abstract class MemoryAccessOpcode extends Opcode { }

abstract class ReturnOpcode extends Opcode { }

abstract class ThrowOpcode extends Opcode { }

abstract class CatchOpcode extends Opcode { }

abstract class OpcodeWithCondition extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) { tag instanceof ConditionOperandTag }
}

abstract class BuiltInOperationOpcode extends Opcode { }

abstract class SideEffectOpcode extends Opcode { }

/**
 * An opcode that accesses a single memory location via an `AddressOperand`.
 */
abstract class IndirectMemoryAccessOpcode extends Opcode {
  final override predicate hasAddressOperand() { any() }
}

/**
 * An opcode that writes to a single memory location via an `AddressOperand`.
 */
abstract class IndirectWriteOpcode extends IndirectMemoryAccessOpcode {
  final override MemoryAccessKind getWriteMemoryAccess() { result instanceof IndirectMemoryAccess }
}

/**
 * An opcode that reads from a single memory location via an `AddressOperand`.
 */
abstract class IndirectReadOpcode extends IndirectMemoryAccessOpcode {
  final override MemoryAccessKind getReadMemoryAccess() { result instanceof IndirectMemoryAccess }
}

/**
 * An opcode that accesses a memory buffer.
 */
abstract class BufferAccessOpcode extends Opcode {
  final override predicate hasAddressOperand() { any() }
}

/**
 * An opcode that accesses a memory buffer of unknown size.
 */
abstract class UnsizedBufferAccessOpcode extends BufferAccessOpcode { }

/**
 * An opcode that writes to a memory buffer of unknown size.
 */
abstract class UnsizedBufferWriteOpcode extends UnsizedBufferAccessOpcode {
  final override MemoryAccessKind getWriteMemoryAccess() { result instanceof BufferMemoryAccess }
}

/**
 * An opcode that reads from a memory buffer of unknown size.
 */
abstract class UnsizedBufferReadOpcode extends UnsizedBufferAccessOpcode {
  final override MemoryAccessKind getReadMemoryAccess() { result instanceof BufferMemoryAccess }
}

/**
 * An opcode that access an entire memory allocation.
 */
abstract class EntireAllocationAccessOpcode extends Opcode {
  final override predicate hasAddressOperand() { any() }
}

/**
 * An opcode that write to an entire memory allocation.
 */
abstract class EntireAllocationWriteOpcode extends EntireAllocationAccessOpcode {
  final override MemoryAccessKind getWriteMemoryAccess() {
    result instanceof EntireAllocationMemoryAccess
  }
}

/**
 * An opcode that reads from an entire memory allocation.
 */
abstract class EntireAllocationReadOpcode extends EntireAllocationAccessOpcode {
  final override MemoryAccessKind getReadMemoryAccess() {
    result instanceof EntireAllocationMemoryAccess
  }
}

/**
 * An opcode that accesses a memory buffer whose size is determined by a `BufferSizeOperand`.
 */
abstract class SizedBufferAccessOpcode extends BufferAccessOpcode {
  final override predicate hasBufferSizeOperand() { any() }
}

/**
 * An opcode that writes to a memory buffer whose size is determined by a `BufferSizeOperand`.
 */
abstract class SizedBufferWriteOpcode extends SizedBufferAccessOpcode {
  final override MemoryAccessKind getWriteMemoryAccess() {
    result instanceof BufferMemoryAccess //TODO: SizedBufferMemoryAccess
  }
}

/**
 * An opcode that reads from a memory buffer whose size is determined by a `BufferSizeOperand`.
 */
abstract class SizedBufferReadOpcode extends SizedBufferAccessOpcode {
  final override MemoryAccessKind getReadMemoryAccess() {
    result instanceof BufferMemoryAccess //TODO: SizedBufferMemoryAccess
  }
}

/**
 * An opcode that might write to any escaped memory location.
 */
abstract class EscapedWriteOpcode extends Opcode {
  final override MemoryAccessKind getWriteMemoryAccess() { result instanceof EscapedMemoryAccess }
}

/**
 * An opcode that might read from any escaped memory location.
 */
abstract class EscapedReadOpcode extends Opcode {
  final override MemoryAccessKind getReadMemoryAccess() { result instanceof EscapedMemoryAccess }
}

/**
 * An opcode whose write memory access is a `may` write, as opposed to a `must` write.
 */
abstract class MayWriteOpcode extends Opcode {
  final override predicate hasMayWriteMemoryAccess() { any() }
}

/**
 * An opcode whose read memory access is a `may` read, as opposed to a `must` read.
 */
abstract class MayReadOpcode extends Opcode {
  final override predicate hasMayReadMemoryAccess() { any() }
}

/**
 * An opcode that reads a value from memory.
 */
abstract class OpcodeWithLoad extends IndirectReadOpcode {
  final override predicate hasOperandInternal(OperandTag tag) { tag instanceof LoadOperandTag }
}

/**
 * An opcode that reads from a set of memory locations as a side effect.
 */
abstract class ReadSideEffectOpcode extends SideEffectOpcode {
  final override predicate hasOperandInternal(OperandTag tag) {
    tag instanceof SideEffectOperandTag
  }
}

/**
 * An opcode that writes to a set of memory locations as a side effect.
 */
abstract class WriteSideEffectOpcode extends SideEffectOpcode { }

module Opcode {
  class NoOp extends Opcode, TNoOp {
    final override string toString() { result = "NoOp" }
  }

  class Uninitialized extends IndirectWriteOpcode, TUninitialized {
    final override string toString() { result = "Uninitialized" }
  }

  class Error extends Opcode, TError {
    final override string toString() { result = "Error" }
  }

  class InitializeParameter extends IndirectWriteOpcode, TInitializeParameter {
    final override string toString() { result = "InitializeParameter" }
  }

  class InitializeIndirection extends EntireAllocationWriteOpcode, TInitializeIndirection {
    final override string toString() { result = "InitializeIndirection" }
  }

  class InitializeThis extends Opcode, TInitializeThis {
    final override string toString() { result = "InitializeThis" }
  }

  class EnterFunction extends Opcode, TEnterFunction {
    final override string toString() { result = "EnterFunction" }
  }

  class ExitFunction extends Opcode, TExitFunction {
    final override string toString() { result = "ExitFunction" }
  }

  class ReturnValue extends ReturnOpcode, OpcodeWithLoad, TReturnValue {
    final override string toString() { result = "ReturnValue" }
  }

  class ReturnVoid extends ReturnOpcode, TReturnVoid {
    final override string toString() { result = "ReturnVoid" }
  }

  class ReturnIndirection extends EntireAllocationReadOpcode, TReturnIndirection {
    final override string toString() { result = "ReturnIndirection" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  class CopyValue extends UnaryOpcode, CopyOpcode, TCopyValue {
    final override string toString() { result = "CopyValue" }
  }

  class Load extends CopyOpcode, OpcodeWithLoad, TLoad {
    final override string toString() { result = "Load" }
  }

  class Store extends CopyOpcode, IndirectWriteOpcode, TStore {
    final override string toString() { result = "Store" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof StoreValueOperandTag
    }
  }

  class Add extends BinaryArithmeticOpcode, TAdd {
    final override string toString() { result = "Add" }
  }

  class Sub extends BinaryArithmeticOpcode, TSub {
    final override string toString() { result = "Sub" }
  }

  class Mul extends BinaryArithmeticOpcode, TMul {
    final override string toString() { result = "Mul" }
  }

  class Div extends BinaryArithmeticOpcode, TDiv {
    final override string toString() { result = "Div" }
  }

  class Rem extends BinaryArithmeticOpcode, TRem {
    final override string toString() { result = "Rem" }
  }

  class Negate extends UnaryArithmeticOpcode, TNegate {
    final override string toString() { result = "Negate" }
  }

  class ShiftLeft extends BinaryBitwiseOpcode, TShiftLeft {
    final override string toString() { result = "ShiftLeft" }
  }

  class ShiftRight extends BinaryBitwiseOpcode, TShiftRight {
    final override string toString() { result = "ShiftRight" }
  }

  class BitAnd extends BinaryBitwiseOpcode, TBitAnd {
    final override string toString() { result = "BitAnd" }
  }

  class BitOr extends BinaryBitwiseOpcode, TBitOr {
    final override string toString() { result = "BitOr" }
  }

  class BitXor extends BinaryBitwiseOpcode, TBitXor {
    final override string toString() { result = "BitXor" }
  }

  class BitComplement extends UnaryBitwiseOpcode, TBitComplement {
    final override string toString() { result = "BitComplement" }
  }

  class LogicalNot extends UnaryOpcode, TLogicalNot {
    final override string toString() { result = "LogicalNot" }
  }

  class CompareEQ extends CompareOpcode, TCompareEQ {
    final override string toString() { result = "CompareEQ" }
  }

  class CompareNE extends CompareOpcode, TCompareNE {
    final override string toString() { result = "CompareNE" }
  }

  class CompareLT extends RelationalOpcode, TCompareLT {
    final override string toString() { result = "CompareLT" }
  }

  class CompareGT extends RelationalOpcode, TCompareGT {
    final override string toString() { result = "CompareGT" }
  }

  class CompareLE extends RelationalOpcode, TCompareLE {
    final override string toString() { result = "CompareLE" }
  }

  class CompareGE extends RelationalOpcode, TCompareGE {
    final override string toString() { result = "CompareGE" }
  }

  class PointerAdd extends PointerOffsetOpcode, TPointerAdd {
    final override string toString() { result = "PointerAdd" }
  }

  class PointerSub extends PointerOffsetOpcode, TPointerSub {
    final override string toString() { result = "PointerSub" }
  }

  class PointerDiff extends PointerArithmeticOpcode, TPointerDiff {
    final override string toString() { result = "PointerDiff" }
  }

  class Convert extends UnaryOpcode, TConvert {
    final override string toString() { result = "Convert" }
  }

  class ConvertToNonVirtualBase extends ConvertToBaseOpcode, TConvertToNonVirtualBase {
    final override string toString() { result = "ConvertToNonVirtualBase" }
  }

  class ConvertToVirtualBase extends ConvertToBaseOpcode, TConvertToVirtualBase {
    final override string toString() { result = "ConvertToVirtualBase" }
  }

  class ConvertToDerived extends UnaryOpcode, TConvertToDerived {
    final override string toString() { result = "ConvertToDerived" }
  }

  class CheckedConvertOrNull extends UnaryOpcode, TCheckedConvertOrNull {
    final override string toString() { result = "CheckedConvertOrNull" }
  }

  class CheckedConvertOrThrow extends UnaryOpcode, TCheckedConvertOrThrow {
    final override string toString() { result = "CheckedConvertOrThrow" }
  }

  class DynamicCastToVoid extends UnaryOpcode, TDynamicCastToVoid {
    final override string toString() { result = "DynamicCastToVoid" }
  }

  class VariableAddress extends Opcode, TVariableAddress {
    final override string toString() { result = "VariableAddress" }
  }

  class FieldAddress extends UnaryOpcode, TFieldAddress {
    final override string toString() { result = "FieldAddress" }
  }

  class ElementsAddress extends UnaryOpcode, TElementsAddress {
    final override string toString() { result = "ElementsAddress" }
  }

  class FunctionAddress extends Opcode, TFunctionAddress {
    final override string toString() { result = "FunctionAddress" }
  }

  class Constant extends Opcode, TConstant {
    final override string toString() { result = "Constant" }
  }

  class StringConstant extends Opcode, TStringConstant {
    final override string toString() { result = "StringConstant" }
  }

  class ConditionalBranch extends OpcodeWithCondition, TConditionalBranch {
    final override string toString() { result = "ConditionalBranch" }
  }

  class Switch extends OpcodeWithCondition, TSwitch {
    final override string toString() { result = "Switch" }
  }

  class Call extends Opcode, TCall {
    final override string toString() { result = "Call" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof CallTargetOperandTag
    }
  }

  class CatchByType extends CatchOpcode, TCatchByType {
    final override string toString() { result = "CatchByType" }
  }

  class CatchAny extends CatchOpcode, TCatchAny {
    final override string toString() { result = "CatchAny" }
  }

  class ThrowValue extends ThrowOpcode, OpcodeWithLoad, TThrowValue {
    final override string toString() { result = "ThrowValue" }
  }

  class ReThrow extends ThrowOpcode, TReThrow {
    final override string toString() { result = "ReThrow" }
  }

  class Unwind extends Opcode, TUnwind {
    final override string toString() { result = "Unwind" }
  }

  class AliasedDefinition extends Opcode, TAliasedDefinition {
    final override string toString() { result = "AliasedDefinition" }

    final override MemoryAccessKind getWriteMemoryAccess() { result instanceof EscapedMemoryAccess }
  }

  class InitializeNonLocal extends Opcode, TInitializeNonLocal {
    final override string toString() { result = "InitializeNonLocal" }

    final override MemoryAccessKind getWriteMemoryAccess() {
      result instanceof NonLocalMemoryAccess
    }
  }

  class AliasedUse extends Opcode, TAliasedUse {
    final override string toString() { result = "AliasedUse" }

    final override MemoryAccessKind getReadMemoryAccess() { result instanceof NonLocalMemoryAccess }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  class Phi extends Opcode, TPhi {
    final override string toString() { result = "Phi" }

    final override MemoryAccessKind getWriteMemoryAccess() { result instanceof PhiMemoryAccess }
  }

  class BuiltIn extends BuiltInOperationOpcode, TBuiltIn {
    final override string toString() { result = "BuiltIn" }
  }

  class VarArgsStart extends UnaryOpcode, TVarArgsStart {
    final override string toString() { result = "VarArgsStart" }
  }

  class VarArgsEnd extends UnaryOpcode, TVarArgsEnd {
    final override string toString() { result = "VarArgsEnd" }
  }

  class VarArg extends UnaryOpcode, TVarArg {
    final override string toString() { result = "VarArg" }
  }

  class NextVarArg extends UnaryOpcode, TNextVarArg {
    final override string toString() { result = "NextVarArg" }
  }

  class CallSideEffect extends WriteSideEffectOpcode, EscapedWriteOpcode, MayWriteOpcode,
    ReadSideEffectOpcode, EscapedReadOpcode, MayReadOpcode, TCallSideEffect {
    final override string toString() { result = "CallSideEffect" }
  }

  class CallReadSideEffect extends ReadSideEffectOpcode, EscapedReadOpcode, MayReadOpcode,
    TCallReadSideEffect {
    final override string toString() { result = "CallReadSideEffect" }
  }

  class IndirectReadSideEffect extends ReadSideEffectOpcode, IndirectReadOpcode,
    TIndirectReadSideEffect {
    final override string toString() { result = "IndirectReadSideEffect" }
  }

  class IndirectMustWriteSideEffect extends WriteSideEffectOpcode, IndirectWriteOpcode,
    TIndirectMustWriteSideEffect {
    final override string toString() { result = "IndirectMustWriteSideEffect" }
  }

  class IndirectMayWriteSideEffect extends WriteSideEffectOpcode, IndirectWriteOpcode,
    MayWriteOpcode, TIndirectMayWriteSideEffect {
    final override string toString() { result = "IndirectMayWriteSideEffect" }
  }

  class BufferReadSideEffect extends ReadSideEffectOpcode, UnsizedBufferReadOpcode,
    TBufferReadSideEffect {
    final override string toString() { result = "BufferReadSideEffect" }
  }

  class BufferMustWriteSideEffect extends WriteSideEffectOpcode, UnsizedBufferWriteOpcode,
    TBufferMustWriteSideEffect {
    final override string toString() { result = "BufferMustWriteSideEffect" }
  }

  class BufferMayWriteSideEffect extends WriteSideEffectOpcode, UnsizedBufferWriteOpcode,
    MayWriteOpcode, TBufferMayWriteSideEffect {
    final override string toString() { result = "BufferMayWriteSideEffect" }
  }

  class SizedBufferReadSideEffect extends ReadSideEffectOpcode, SizedBufferReadOpcode,
    TSizedBufferReadSideEffect {
    final override string toString() { result = "SizedBufferReadSideEffect" }
  }

  class SizedBufferMustWriteSideEffect extends WriteSideEffectOpcode, SizedBufferWriteOpcode,
    TSizedBufferMustWriteSideEffect {
    final override string toString() { result = "SizedBufferMustWriteSideEffect" }
  }

  class SizedBufferMayWriteSideEffect extends WriteSideEffectOpcode, SizedBufferWriteOpcode,
    MayWriteOpcode, TSizedBufferMayWriteSideEffect {
    final override string toString() { result = "SizedBufferMayWriteSideEffect" }
  }

  class InitializeDynamicAllocation extends SideEffectOpcode, EntireAllocationWriteOpcode,
    TInitializeDynamicAllocation {
    final override string toString() { result = "InitializeDynamicAllocation" }
  }

  class Chi extends Opcode, TChi {
    final override string toString() { result = "Chi" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof ChiTotalOperandTag
      or
      tag instanceof ChiPartialOperandTag
    }

    final override MemoryAccessKind getWriteMemoryAccess() {
      result instanceof ChiTotalMemoryAccess
    }
  }

  class InlineAsm extends Opcode, EscapedWriteOpcode, MayWriteOpcode, EscapedReadOpcode,
    MayReadOpcode, TInlineAsm {
    final override string toString() { result = "InlineAsm" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  class Unreached extends Opcode, TUnreached {
    final override string toString() { result = "Unreached" }
  }

  class NewObj extends Opcode, TNewObj {
    final override string toString() { result = "NewObj" }
  }
}
