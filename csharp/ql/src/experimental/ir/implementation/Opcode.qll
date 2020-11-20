/**
 * Provides `Opcode`s that specify the operation performed by an `Instruction`, as well as metadata
 * about those opcodes, such as operand kinds and memory accesses.
 */

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
  TCompleteObjectAddress() or
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

/**
 * An opcode that specifies the operation performed by an `Instruction`.
 */
class Opcode extends TOpcode {
  /** Gets a textual representation of this element. */
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

/**
 * The `Opcode` for a `UnaryInstruction`.
 *
 * See the `UnaryInstruction` documentation for more details.
 */
abstract class UnaryOpcode extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) { tag instanceof UnaryOperandTag }
}

/**
 * The `Opcode` for a `BinaryInstruction`.
 *
 * See the `BinaryInstruction` documentation for more details.
 */
abstract class BinaryOpcode extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) {
    tag instanceof LeftOperandTag or
    tag instanceof RightOperandTag
  }
}

/**
 * The `Opcode` for a `PointerArithmeticInstruction`.
 *
 * See the `PointerArithmeticInstruction` documentation for more details.
 */
abstract class PointerArithmeticOpcode extends BinaryOpcode { }

/**
 * The `Opcode` for a `PointerOffsetInstruction`.
 *
 * See the `PointerOffsetInstruction` documentation for more details.
 */
abstract class PointerOffsetOpcode extends PointerArithmeticOpcode { }

/**
 * The `Opcode` for an `ArithmeticInstruction`.
 *
 * See the `ArithmeticInstruction` documentation for more details.
 */
abstract class ArithmeticOpcode extends Opcode { }

/**
 * The `Opcode` for a `BinaryArithmeticInstruction`.
 *
 * See the `BinaryArithmeticInstruction` documentation for more details.
 */
abstract class BinaryArithmeticOpcode extends BinaryOpcode, ArithmeticOpcode { }

/**
 * The `Opcode` for a `UnaryArithmeticInstruction`.
 *
 * See the `UnaryArithmeticInstruction` documentation for more details.
 */
abstract class UnaryArithmeticOpcode extends UnaryOpcode, ArithmeticOpcode { }

/**
 * The `Opcode` for a `BitwiseInstruction`.
 *
 * See the `BitwiseInstruction` documentation for more details.
 */
abstract class BitwiseOpcode extends Opcode { }

/**
 * The `Opcode` for a `BinaryBitwiseInstruction`.
 *
 * See the `BinaryBitwiseInstruction` documentation for more details.
 */
abstract class BinaryBitwiseOpcode extends BinaryOpcode, BitwiseOpcode { }

/**
 * The `Opcode` for a `UnaryBitwiseInstruction`.
 *
 * See the `UnaryBitwiseInstruction` documentation for more details.
 */
abstract class UnaryBitwiseOpcode extends UnaryOpcode, BitwiseOpcode { }

/**
 * The `Opcode` for a `CompareInstruction`.
 *
 * See the `CompareInstruction` documentation for more details.
 */
abstract class CompareOpcode extends BinaryOpcode { }

/**
 * The `Opcode` for a `RelationalInstruction`.
 *
 * See the `RelationalInstruction` documentation for more details.
 */
abstract class RelationalOpcode extends CompareOpcode { }

/**
 * The `Opcode` for a `CopyInstruction`.
 *
 * See the `CopyInstruction` documentation for more details.
 */
abstract class CopyOpcode extends Opcode { }

/**
 * The `Opcode` for a `ConvertToBaseInstruction`.
 *
 * See the `ConvertToBaseInstruction` documentation for more details.
 */
abstract class ConvertToBaseOpcode extends UnaryOpcode { }

/**
 * The `Opcode` for a `ReturnInstruction`.
 *
 * See the `ReturnInstruction` documentation for more details.
 */
abstract class ReturnOpcode extends Opcode { }

/**
 * The `Opcode` for a `ThrowInstruction`.
 *
 * See the `ThrowInstruction` documentation for more details.
 */
abstract class ThrowOpcode extends Opcode { }

/**
 * The `Opcode` for a `CatchInstruction`.
 *
 * See the `CatchInstruction` documentation for more details.
 */
abstract class CatchOpcode extends Opcode { }

abstract private class OpcodeWithCondition extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) { tag instanceof ConditionOperandTag }
}

/**
 * The `Opcode` for a `BuiltInOperationInstruction`.
 *
 * See the `BuiltInOperationInstruction` documentation for more details.
 */
abstract class BuiltInOperationOpcode extends Opcode { }

/**
 * The `Opcode` for a `SideEffectInstruction`.
 *
 * See the `SideEffectInstruction` documentation for more details.
 */
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
 * The `Opcode` for a `ReadSideEffectInstruction`.
 *
 * See the `ReadSideEffectInstruction` documentation for more details.
 */
abstract class ReadSideEffectOpcode extends SideEffectOpcode {
  final override predicate hasOperandInternal(OperandTag tag) {
    tag instanceof SideEffectOperandTag
  }
}

/**
 * The `Opcode` for a `WriteSideEffectInstruction`.
 *
 * See the `WriteSideEffectInstruction` documentation for more details.
 */
abstract class WriteSideEffectOpcode extends SideEffectOpcode { }

/**
 * Provides `Opcode`s that specify the operation performed by an `Instruction`.
 */
module Opcode {
  /**
   * The `Opcode` for a `NoOpInstruction`.
   *
   * See the `NoOpInstruction` documentation for more details.
   */
  class NoOp extends Opcode, TNoOp {
    final override string toString() { result = "NoOp" }
  }

  /**
   * The `Opcode` for an `UninitializedInstruction`.
   *
   * See the `UninitializedInstruction` documentation for more details.
   */
  class Uninitialized extends IndirectWriteOpcode, TUninitialized {
    final override string toString() { result = "Uninitialized" }
  }

  /**
   * The `Opcode` for an `ErrorInstruction`.
   *
   * See the `ErrorInstruction` documentation for more details.
   */
  class Error extends Opcode, TError {
    final override string toString() { result = "Error" }
  }

  /**
   * The `Opcode` for an `InitializeParameterInstruction`.
   *
   * See the `InitializeParameterInstruction` documentation for more details.
   */
  class InitializeParameter extends IndirectWriteOpcode, TInitializeParameter {
    final override string toString() { result = "InitializeParameter" }
  }

  /**
   * The `Opcode` for an `InitializeIndirectionInstruction`.
   *
   * See the `InitializeIndirectionInstruction` documentation for more details.
   */
  class InitializeIndirection extends EntireAllocationWriteOpcode, TInitializeIndirection {
    final override string toString() { result = "InitializeIndirection" }
  }

  /**
   * The `Opcode` for an `InitializeThisInstruction`.
   *
   * See the `InitializeThisInstruction` documentation for more details.
   */
  class InitializeThis extends Opcode, TInitializeThis {
    final override string toString() { result = "InitializeThis" }
  }

  /**
   * The `Opcode` for an `EnterFunctionInstruction`.
   *
   * See the `EnterFunctionInstruction` documentation for more details.
   */
  class EnterFunction extends Opcode, TEnterFunction {
    final override string toString() { result = "EnterFunction" }
  }

  /**
   * The `Opcode` for an `ExitFunctionInstruction`.
   *
   * See the `ExitFunctionInstruction` documentation for more details.
   */
  class ExitFunction extends Opcode, TExitFunction {
    final override string toString() { result = "ExitFunction" }
  }

  /**
   * The `Opcode` for a `ReturnValueInstruction`.
   *
   * See the `ReturnValueInstruction` documentation for more details.
   */
  class ReturnValue extends ReturnOpcode, OpcodeWithLoad, TReturnValue {
    final override string toString() { result = "ReturnValue" }
  }

  /**
   * The `Opcode` for a `ReturnVoidInstruction`.
   *
   * See the `ReturnVoidInstruction` documentation for more details.
   */
  class ReturnVoid extends ReturnOpcode, TReturnVoid {
    final override string toString() { result = "ReturnVoid" }
  }

  /**
   * The `Opcode` for a `ReturnIndirectionInstruction`.
   *
   * See the `ReturnIndirectionInstruction` documentation for more details.
   */
  class ReturnIndirection extends EntireAllocationReadOpcode, TReturnIndirection {
    final override string toString() { result = "ReturnIndirection" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  /**
   * The `Opcode` for a `CopyValueInstruction`.
   *
   * See the `CopyValueInstruction` documentation for more details.
   */
  class CopyValue extends UnaryOpcode, CopyOpcode, TCopyValue {
    final override string toString() { result = "CopyValue" }
  }

  /**
   * The `Opcode` for a `LoadInstruction`.
   *
   * See the `LoadInstruction` documentation for more details.
   */
  class Load extends CopyOpcode, OpcodeWithLoad, TLoad {
    final override string toString() { result = "Load" }
  }

  /**
   * The `Opcode` for a `StoreInstruction`.
   *
   * See the `StoreInstruction` documentation for more details.
   */
  class Store extends CopyOpcode, IndirectWriteOpcode, TStore {
    final override string toString() { result = "Store" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof StoreValueOperandTag
    }
  }

  /**
   * The `Opcode` for an `AddInstruction`.
   *
   * See the `AddInstruction` documentation for more details.
   */
  class Add extends BinaryArithmeticOpcode, TAdd {
    final override string toString() { result = "Add" }
  }

  /**
   * The `Opcode` for a `SubInstruction`.
   *
   * See the `SubInstruction` documentation for more details.
   */
  class Sub extends BinaryArithmeticOpcode, TSub {
    final override string toString() { result = "Sub" }
  }

  /**
   * The `Opcode` for a `MulInstruction`.
   *
   * See the `MulInstruction` documentation for more details.
   */
  class Mul extends BinaryArithmeticOpcode, TMul {
    final override string toString() { result = "Mul" }
  }

  /**
   * The `Opcode` for a `DivInstruction`.
   *
   * See the `DivInstruction` documentation for more details.
   */
  class Div extends BinaryArithmeticOpcode, TDiv {
    final override string toString() { result = "Div" }
  }

  /**
   * The `Opcode` for a `RemInstruction`.
   *
   * See the `RemInstruction` documentation for more details.
   */
  class Rem extends BinaryArithmeticOpcode, TRem {
    final override string toString() { result = "Rem" }
  }

  /**
   * The `Opcode` for a `NegateInstruction`.
   *
   * See the `NegateInstruction` documentation for more details.
   */
  class Negate extends UnaryArithmeticOpcode, TNegate {
    final override string toString() { result = "Negate" }
  }

  /**
   * The `Opcode` for a `ShiftLeftInstruction`.
   *
   * See the `ShiftLeftInstruction` documentation for more details.
   */
  class ShiftLeft extends BinaryBitwiseOpcode, TShiftLeft {
    final override string toString() { result = "ShiftLeft" }
  }

  /**
   * The `Opcode` for a `ShiftRightInstruction`.
   *
   * See the `ShiftRightInstruction` documentation for more details.
   */
  class ShiftRight extends BinaryBitwiseOpcode, TShiftRight {
    final override string toString() { result = "ShiftRight" }
  }

  /**
   * The `Opcode` for a `BitAndInstruction`.
   *
   * See the `BitAndInstruction` documentation for more details.
   */
  class BitAnd extends BinaryBitwiseOpcode, TBitAnd {
    final override string toString() { result = "BitAnd" }
  }

  /**
   * The `Opcode` for a `BitOrInstruction`.
   *
   * See the `BitOrInstruction` documentation for more details.
   */
  class BitOr extends BinaryBitwiseOpcode, TBitOr {
    final override string toString() { result = "BitOr" }
  }

  /**
   * The `Opcode` for a `BitXorInstruction`.
   *
   * See the `BitXorInstruction` documentation for more details.
   */
  class BitXor extends BinaryBitwiseOpcode, TBitXor {
    final override string toString() { result = "BitXor" }
  }

  /**
   * The `Opcode` for a `BitComplementInstruction`.
   *
   * See the `BitComplementInstruction` documentation for more details.
   */
  class BitComplement extends UnaryBitwiseOpcode, TBitComplement {
    final override string toString() { result = "BitComplement" }
  }

  /**
   * The `Opcode` for a `LogicalNotInstruction`.
   *
   * See the `LogicalNotInstruction` documentation for more details.
   */
  class LogicalNot extends UnaryOpcode, TLogicalNot {
    final override string toString() { result = "LogicalNot" }
  }

  /**
   * The `Opcode` for a `CompareEQInstruction`.
   *
   * See the `CompareEQInstruction` documentation for more details.
   */
  class CompareEQ extends CompareOpcode, TCompareEQ {
    final override string toString() { result = "CompareEQ" }
  }

  /**
   * The `Opcode` for a `CompareNEInstruction`.
   *
   * See the `CompareNEInstruction` documentation for more details.
   */
  class CompareNE extends CompareOpcode, TCompareNE {
    final override string toString() { result = "CompareNE" }
  }

  /**
   * The `Opcode` for a `CompareLTInstruction`.
   *
   * See the `CompareLTInstruction` documentation for more details.
   */
  class CompareLT extends RelationalOpcode, TCompareLT {
    final override string toString() { result = "CompareLT" }
  }

  /**
   * The `Opcode` for a `CompareGTInstruction`.
   *
   * See the `CompareGTInstruction` documentation for more details.
   */
  class CompareGT extends RelationalOpcode, TCompareGT {
    final override string toString() { result = "CompareGT" }
  }

  /**
   * The `Opcode` for a `CompareLEInstruction`.
   *
   * See the `CompareLEInstruction` documentation for more details.
   */
  class CompareLE extends RelationalOpcode, TCompareLE {
    final override string toString() { result = "CompareLE" }
  }

  /**
   * The `Opcode` for a `CompareGEInstruction`.
   *
   * See the `CompareGEInstruction` documentation for more details.
   */
  class CompareGE extends RelationalOpcode, TCompareGE {
    final override string toString() { result = "CompareGE" }
  }

  /**
   * The `Opcode` for a `PointerAddInstruction`.
   *
   * See the `PointerAddInstruction` documentation for more details.
   */
  class PointerAdd extends PointerOffsetOpcode, TPointerAdd {
    final override string toString() { result = "PointerAdd" }
  }

  /**
   * The `Opcode` for a `PointerSubInstruction`.
   *
   * See the `PointerSubInstruction` documentation for more details.
   */
  class PointerSub extends PointerOffsetOpcode, TPointerSub {
    final override string toString() { result = "PointerSub" }
  }

  /**
   * The `Opcode` for a `PointerDiffInstruction`.
   *
   * See the `PointerDiffInstruction` documentation for more details.
   */
  class PointerDiff extends PointerArithmeticOpcode, TPointerDiff {
    final override string toString() { result = "PointerDiff" }
  }

  /**
   * The `Opcode` for a `ConvertInstruction`.
   *
   * See the `ConvertInstruction` documentation for more details.
   */
  class Convert extends UnaryOpcode, TConvert {
    final override string toString() { result = "Convert" }
  }

  /**
   * The `Opcode` for a `ConvertToNonVirtualBaseInstruction`.
   *
   * See the `ConvertToNonVirtualBaseInstruction` documentation for more details.
   */
  class ConvertToNonVirtualBase extends ConvertToBaseOpcode, TConvertToNonVirtualBase {
    final override string toString() { result = "ConvertToNonVirtualBase" }
  }

  /**
   * The `Opcode` for a `ConvertToVirtualBaseInstruction`.
   *
   * See the `ConvertToVirtualBaseInstruction` documentation for more details.
   */
  class ConvertToVirtualBase extends ConvertToBaseOpcode, TConvertToVirtualBase {
    final override string toString() { result = "ConvertToVirtualBase" }
  }

  /**
   * The `Opcode` for a `ConvertToDerivedInstruction`.
   *
   * See the `ConvertToDerivedInstruction` documentation for more details.
   */
  class ConvertToDerived extends UnaryOpcode, TConvertToDerived {
    final override string toString() { result = "ConvertToDerived" }
  }

  /**
   * The `Opcode` for a `CheckedConvertOrNullInstruction`.
   *
   * See the `CheckedConvertOrNullInstruction` documentation for more details.
   */
  class CheckedConvertOrNull extends UnaryOpcode, TCheckedConvertOrNull {
    final override string toString() { result = "CheckedConvertOrNull" }
  }

  /**
   * The `Opcode` for a `CheckedConvertOrThrowInstruction`.
   *
   * See the `CheckedConvertOrThrowInstruction` documentation for more details.
   */
  class CheckedConvertOrThrow extends UnaryOpcode, TCheckedConvertOrThrow {
    final override string toString() { result = "CheckedConvertOrThrow" }
  }

  /**
   * The `Opcode` for a `CompleteObjectAddressInstruction`.
   *
   * See the `CompleteObjectAddressInstruction` documentation for more details.
   */
  class CompleteObjectAddress extends UnaryOpcode, TCompleteObjectAddress {
    final override string toString() { result = "CompleteObjectAddress" }
  }

  /**
   * The `Opcode` for a `VariableAddressInstruction`.
   *
   * See the `VariableAddressInstruction` documentation for more details.
   */
  class VariableAddress extends Opcode, TVariableAddress {
    final override string toString() { result = "VariableAddress" }
  }

  /**
   * The `Opcode` for a `FieldAddressInstruction`.
   *
   * See the `FieldAddressInstruction` documentation for more details.
   */
  class FieldAddress extends UnaryOpcode, TFieldAddress {
    final override string toString() { result = "FieldAddress" }
  }

  /**
   * The `Opcode` for an `ElementsAddressInstruction`.
   *
   * See the `ElementsAddressInstruction` documentation for more details.
   */
  class ElementsAddress extends UnaryOpcode, TElementsAddress {
    final override string toString() { result = "ElementsAddress" }
  }

  /**
   * The `Opcode` for a `FunctionAddressInstruction`.
   *
   * See the `FunctionAddressInstruction` documentation for more details.
   */
  class FunctionAddress extends Opcode, TFunctionAddress {
    final override string toString() { result = "FunctionAddress" }
  }

  /**
   * The `Opcode` for a `ConstantInstruction`.
   *
   * See the `ConstantInstruction` documentation for more details.
   */
  class Constant extends Opcode, TConstant {
    final override string toString() { result = "Constant" }
  }

  /**
   * The `Opcode` for a `StringConstantInstruction`.
   *
   * See the `StringConstantInstruction` documentation for more details.
   */
  class StringConstant extends Opcode, TStringConstant {
    final override string toString() { result = "StringConstant" }
  }

  /**
   * The `Opcode` for a `ConditionalBranchInstruction`.
   *
   * See the `ConditionalBranchInstruction` documentation for more details.
   */
  class ConditionalBranch extends OpcodeWithCondition, TConditionalBranch {
    final override string toString() { result = "ConditionalBranch" }
  }

  /**
   * The `Opcode` for a `SwitchInstruction`.
   *
   * See the `SwitchInstruction` documentation for more details.
   */
  class Switch extends OpcodeWithCondition, TSwitch {
    final override string toString() { result = "Switch" }
  }

  /**
   * The `Opcode` for a `CallInstruction`.
   *
   * See the `CallInstruction` documentation for more details.
   */
  class Call extends Opcode, TCall {
    final override string toString() { result = "Call" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof CallTargetOperandTag
    }
  }

  /**
   * The `Opcode` for a `CatchByTypeInstruction`.
   *
   * See the `CatchByTypeInstruction` documentation for more details.
   */
  class CatchByType extends CatchOpcode, TCatchByType {
    final override string toString() { result = "CatchByType" }
  }

  /**
   * The `Opcode` for a `CatchAnyInstruction`.
   *
   * See the `CatchAnyInstruction` documentation for more details.
   */
  class CatchAny extends CatchOpcode, TCatchAny {
    final override string toString() { result = "CatchAny" }
  }

  /**
   * The `Opcode` for a `ThrowValueInstruction`.
   *
   * See the `ThrowValueInstruction` documentation for more details.
   */
  class ThrowValue extends ThrowOpcode, OpcodeWithLoad, TThrowValue {
    final override string toString() { result = "ThrowValue" }
  }

  /**
   * The `Opcode` for a `ReThrowInstruction`.
   *
   * See the `ReThrowInstruction` documentation for more details.
   */
  class ReThrow extends ThrowOpcode, TReThrow {
    final override string toString() { result = "ReThrow" }
  }

  /**
   * The `Opcode` for an `UnwindInstruction`.
   *
   * See the `UnwindInstruction` documentation for more details.
   */
  class Unwind extends Opcode, TUnwind {
    final override string toString() { result = "Unwind" }
  }

  /**
   * The `Opcode` for an `AliasedDefinitionInstruction`.
   *
   * See the `AliasedDefinitionInstruction` documentation for more details.
   */
  class AliasedDefinition extends Opcode, TAliasedDefinition {
    final override string toString() { result = "AliasedDefinition" }

    final override MemoryAccessKind getWriteMemoryAccess() {
      result instanceof EscapedInitializationMemoryAccess
    }
  }

  /**
   * The `Opcode` for an `AliasedUseInstruction`.
   *
   * See the `AliasedUseInstruction` documentation for more details.
   */
  class AliasedUse extends Opcode, TAliasedUse {
    final override string toString() { result = "AliasedUse" }

    final override MemoryAccessKind getReadMemoryAccess() { result instanceof NonLocalMemoryAccess }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  /**
   * The `Opcode` for a `PhiInstruction`.
   *
   * See the `PhiInstruction` documentation for more details.
   */
  class Phi extends Opcode, TPhi {
    final override string toString() { result = "Phi" }

    final override MemoryAccessKind getWriteMemoryAccess() { result instanceof PhiMemoryAccess }
  }

  /**
   * The `Opcode` for a `BuiltInInstruction`.
   *
   * See the `BuiltInInstruction` documentation for more details.
   */
  class BuiltIn extends BuiltInOperationOpcode, TBuiltIn {
    final override string toString() { result = "BuiltIn" }
  }

  /**
   * The `Opcode` for a `VarArgsStartInstruction`.
   *
   * See the `VarArgsStartInstruction` documentation for more details.
   */
  class VarArgsStart extends UnaryOpcode, TVarArgsStart {
    final override string toString() { result = "VarArgsStart" }
  }

  /**
   * The `Opcode` for a `VarArgsEndInstruction`.
   *
   * See the `VarArgsEndInstruction` documentation for more details.
   */
  class VarArgsEnd extends UnaryOpcode, TVarArgsEnd {
    final override string toString() { result = "VarArgsEnd" }
  }

  /**
   * The `Opcode` for a `VarArgInstruction`.
   *
   * See the `VarArgInstruction` documentation for more details.
   */
  class VarArg extends UnaryOpcode, TVarArg {
    final override string toString() { result = "VarArg" }
  }

  /**
   * The `Opcode` for a `NextVarArgInstruction`.
   *
   * See the `NextVarArgInstruction` documentation for more details.
   */
  class NextVarArg extends UnaryOpcode, TNextVarArg {
    final override string toString() { result = "NextVarArg" }
  }

  /**
   * The `Opcode` for a `CallSideEffectInstruction`.
   *
   * See the `CallSideEffectInstruction` documentation for more details.
   */
  class CallSideEffect extends WriteSideEffectOpcode, EscapedWriteOpcode, MayWriteOpcode,
    ReadSideEffectOpcode, EscapedReadOpcode, MayReadOpcode, TCallSideEffect {
    final override string toString() { result = "CallSideEffect" }
  }

  /**
   * The `Opcode` for a `CallReadSideEffectInstruction`.
   *
   * See the `CallReadSideEffectInstruction` documentation for more details.
   */
  class CallReadSideEffect extends ReadSideEffectOpcode, EscapedReadOpcode, MayReadOpcode,
    TCallReadSideEffect {
    final override string toString() { result = "CallReadSideEffect" }
  }

  /**
   * The `Opcode` for an `IndirectReadSideEffectInstruction`.
   *
   * See the `IndirectReadSideEffectInstruction` documentation for more details.
   */
  class IndirectReadSideEffect extends ReadSideEffectOpcode, IndirectReadOpcode,
    TIndirectReadSideEffect {
    final override string toString() { result = "IndirectReadSideEffect" }
  }

  /**
   * The `Opcode` for an `IndirectMustWriteSideEffectInstruction`.
   *
   * See the `IndirectMustWriteSideEffectInstruction` documentation for more details.
   */
  class IndirectMustWriteSideEffect extends WriteSideEffectOpcode, IndirectWriteOpcode,
    TIndirectMustWriteSideEffect {
    final override string toString() { result = "IndirectMustWriteSideEffect" }
  }

  /**
   * The `Opcode` for an `IndirectMayWriteSideEffectInstruction`.
   *
   * See the `IndirectMayWriteSideEffectInstruction` documentation for more details.
   */
  class IndirectMayWriteSideEffect extends WriteSideEffectOpcode, IndirectWriteOpcode,
    MayWriteOpcode, TIndirectMayWriteSideEffect {
    final override string toString() { result = "IndirectMayWriteSideEffect" }
  }

  /**
   * The `Opcode` for a `BufferReadSideEffectInstruction`.
   *
   * See the `BufferReadSideEffectInstruction` documentation for more details.
   */
  class BufferReadSideEffect extends ReadSideEffectOpcode, UnsizedBufferReadOpcode,
    TBufferReadSideEffect {
    final override string toString() { result = "BufferReadSideEffect" }
  }

  /**
   * The `Opcode` for a `BufferMustWriteSideEffectInstruction`.
   *
   * See the `BufferMustWriteSideEffectInstruction` documentation for more details.
   */
  class BufferMustWriteSideEffect extends WriteSideEffectOpcode, UnsizedBufferWriteOpcode,
    TBufferMustWriteSideEffect {
    final override string toString() { result = "BufferMustWriteSideEffect" }
  }

  /**
   * The `Opcode` for a `BufferMayWriteSideEffectInstruction`.
   *
   * See the `BufferMayWriteSideEffectInstruction` documentation for more details.
   */
  class BufferMayWriteSideEffect extends WriteSideEffectOpcode, UnsizedBufferWriteOpcode,
    MayWriteOpcode, TBufferMayWriteSideEffect {
    final override string toString() { result = "BufferMayWriteSideEffect" }
  }

  /**
   * The `Opcode` for a `SizedBufferReadSideEffectInstruction`.
   *
   * See the `SizedBufferReadSideEffectInstruction` documentation for more details.
   */
  class SizedBufferReadSideEffect extends ReadSideEffectOpcode, SizedBufferReadOpcode,
    TSizedBufferReadSideEffect {
    final override string toString() { result = "SizedBufferReadSideEffect" }
  }

  /**
   * The `Opcode` for a `SizedBufferMustWriteSideEffectInstruction`.
   *
   * See the `SizedBufferMustWriteSideEffectInstruction` documentation for more details.
   */
  class SizedBufferMustWriteSideEffect extends WriteSideEffectOpcode, SizedBufferWriteOpcode,
    TSizedBufferMustWriteSideEffect {
    final override string toString() { result = "SizedBufferMustWriteSideEffect" }
  }

  /**
   * The `Opcode` for a `SizedBufferMayWriteSideEffectInstruction`.
   *
   * See the `SizedBufferMayWriteSideEffectInstruction` documentation for more details.
   */
  class SizedBufferMayWriteSideEffect extends WriteSideEffectOpcode, SizedBufferWriteOpcode,
    MayWriteOpcode, TSizedBufferMayWriteSideEffect {
    final override string toString() { result = "SizedBufferMayWriteSideEffect" }
  }

  /**
   * The `Opcode` for an `InitializeDynamicAllocationInstruction`.
   *
   * See the `InitializeDynamicAllocationInstruction` documentation for more details.
   */
  class InitializeDynamicAllocation extends SideEffectOpcode, EntireAllocationWriteOpcode,
    TInitializeDynamicAllocation {
    final override string toString() { result = "InitializeDynamicAllocation" }
  }

  /**
   * The `Opcode` for a `ChiInstruction`.
   *
   * See the `ChiInstruction` documentation for more details.
   */
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

  /**
   * The `Opcode` for an `InlineAsmInstruction`.
   *
   * See the `InlineAsmInstruction` documentation for more details.
   */
  class InlineAsm extends Opcode, EscapedWriteOpcode, MayWriteOpcode, EscapedReadOpcode,
    MayReadOpcode, TInlineAsm {
    final override string toString() { result = "InlineAsm" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  /**
   * The `Opcode` for an `UnreachedInstruction`.
   *
   * See the `UnreachedInstruction` documentation for more details.
   */
  class Unreached extends Opcode, TUnreached {
    final override string toString() { result = "Unreached" }
  }

  /**
   * The `Opcode` for a `NewObjInstruction`.
   *
   * See the `NewObjInstruction` documentation for more details.
   */
  class NewObj extends Opcode, TNewObj {
    final override string toString() { result = "NewObj" }
  }
}
