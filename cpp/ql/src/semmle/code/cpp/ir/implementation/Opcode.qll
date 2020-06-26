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
 * An operation whose result is computed from a single operand.
 */
abstract class UnaryOpcode extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) { tag instanceof UnaryOperandTag }
}

/**
 * An operation whose result is computed from two operands.
 */
abstract class BinaryOpcode extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) {
    tag instanceof LeftOperandTag or
    tag instanceof RightOperandTag
  }
}

/**
 * An operation that performs a binary arithmetic operation involving at least one pointer
 * operand.
 */
abstract class PointerArithmeticOpcode extends BinaryOpcode { }

/**
 * An operation that adds or subtracts an integer offset from a pointer.
 */
abstract class PointerOffsetOpcode extends PointerArithmeticOpcode { }

/**
 * An operation that computes the result of an arithmetic operation.
 */
abstract class ArithmeticOpcode extends Opcode { }

/**
 * An operation that performs an arithmetic operation on two numeric operands.
 */
abstract class BinaryArithmeticOpcode extends BinaryOpcode, ArithmeticOpcode { }

/**
 * An operation whose result is computed by performing an arithmetic operation on a single
 * numeric operand.
 */
abstract class UnaryArithmeticOpcode extends UnaryOpcode, ArithmeticOpcode { }

/**
 * An operation that computes the result of a bitwise operation.
 */
abstract class BitwiseOpcode extends Opcode { }

/**
 * An operation that performs a bitwise operation on two integer operands.
 */
abstract class BinaryBitwiseOpcode extends BinaryOpcode, BitwiseOpcode { }

/**
 * An operation that performs a bitwise operation on a single integer operand.
 */
abstract class UnaryBitwiseOpcode extends UnaryOpcode, BitwiseOpcode { }

/**
 * An operation that compares two numeric operands.
 */
abstract class CompareOpcode extends BinaryOpcode { }

/**
 * An operation that does a relative comparison of two values, such as `<` or `>=`.
 */
abstract class RelationalOpcode extends CompareOpcode { }

/**
 * An operation that returns a copy of its operand.
 */
abstract class CopyOpcode extends Opcode { }

/**
 * An operation that converts from the address of a derived class to the address of a base class.
 */
abstract class ConvertToBaseOpcode extends UnaryOpcode { }

/**
 * An operation that returns control to the caller of the function.
 */
abstract class ReturnOpcode extends Opcode { }

/**
 * An operation that throws an exception.
 */
abstract class ThrowOpcode extends Opcode { }

/**
 * An operation that starts a `catch` handler.
 */
abstract class CatchOpcode extends Opcode { }

abstract private class OpcodeWithCondition extends Opcode {
  final override predicate hasOperandInternal(OperandTag tag) { tag instanceof ConditionOperandTag }
}

/**
 * An operation representing a built-in operation.
 */
abstract class BuiltInOperationOpcode extends Opcode { }

/**
 * An operation representing a side effect of a function call.
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
 * An operation representing a read side effect of a function call on a
 * specific parameter.
 */
abstract class ReadSideEffectOpcode extends SideEffectOpcode {
  final override predicate hasOperandInternal(OperandTag tag) {
    tag instanceof SideEffectOperandTag
  }
}

/**
 * An operation representing a write side effect of a function call on a
 * specific parameter.
 */
abstract class WriteSideEffectOpcode extends SideEffectOpcode { }

/**
 * Provides `Opcode`s that specify the operation performed by an `Instruction`.
 */
module Opcode {
  /**
   * An operation that has no effect.
   */
  class NoOp extends Opcode, TNoOp {
    final override string toString() { result = "NoOp" }
  }

  /**
   * An operation that returns an uninitialized value.
   */
  class Uninitialized extends IndirectWriteOpcode, TUninitialized {
    final override string toString() { result = "Uninitialized" }
  }

  /**
   * An operation that produces a well-defined but unknown result and has
   * unknown side effects, including side effects that are not conservatively
   * modeled in the SSA graph.
   */
  class Error extends Opcode, TError {
    final override string toString() { result = "Error" }
  }

  /**
   * An operation that initializes a parameter of the enclosing function with the value of the
   * corresponding argument passed by the caller.
   */
  class InitializeParameter extends IndirectWriteOpcode, TInitializeParameter {
    final override string toString() { result = "InitializeParameter" }
  }

  /**
   * An operation that initializes the memory pointed to by a parameter of the enclosing function
   * with the value of that memory on entry to the function.
   */
  class InitializeIndirection extends EntireAllocationWriteOpcode, TInitializeIndirection {
    final override string toString() { result = "InitializeIndirection" }
  }

  /**
   * An operation that initializes the `this` pointer parameter of the enclosing function.
   */
  class InitializeThis extends Opcode, TInitializeThis {
    final override string toString() { result = "InitializeThis" }
  }

  /**
   * An operation representing the entry point to a function.
   */
  class EnterFunction extends Opcode, TEnterFunction {
    final override string toString() { result = "EnterFunction" }
  }

  /**
   * An operation representing the exit point of a function.
   */
  class ExitFunction extends Opcode, TExitFunction {
    final override string toString() { result = "ExitFunction" }
  }

  /**
   * An operation that returns control to the caller of the function, including a return value.
   */
  class ReturnValue extends ReturnOpcode, OpcodeWithLoad, TReturnValue {
    final override string toString() { result = "ReturnValue" }
  }

  /**
   * An operation that returns control to the caller of the function, without returning a value.
   */
  class ReturnVoid extends ReturnOpcode, TReturnVoid {
    final override string toString() { result = "ReturnVoid" }
  }

  /**
   * An operation that represents the use of the value pointed to by a parameter of the function
   * after the function returns control to its caller.
   */
  class ReturnIndirection extends EntireAllocationReadOpcode, TReturnIndirection {
    final override string toString() { result = "ReturnIndirection" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  /**
   * An operation that returns a register result containing a copy of its register operand.
   */
  class CopyValue extends UnaryOpcode, CopyOpcode, TCopyValue {
    final override string toString() { result = "CopyValue" }
  }

  /**
   * An operation that returns a register result containing a copy of its memory operand.
   */
  class Load extends CopyOpcode, OpcodeWithLoad, TLoad {
    final override string toString() { result = "Load" }
  }

  /**
   * An operation that returns a memory result containing a copy of its register operand.
   */
  class Store extends CopyOpcode, IndirectWriteOpcode, TStore {
    final override string toString() { result = "Store" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof StoreValueOperandTag
    }
  }

  /**
   * An operation that computes the sum of two numeric operands.
   */
  class Add extends BinaryArithmeticOpcode, TAdd {
    final override string toString() { result = "Add" }
  }

  /**
   * An operation that computes the difference of two numeric operands.
   */
  class Sub extends BinaryArithmeticOpcode, TSub {
    final override string toString() { result = "Sub" }
  }

  /**
   * An operation that computes the product of two numeric operands.
   */
  class Mul extends BinaryArithmeticOpcode, TMul {
    final override string toString() { result = "Mul" }
  }

  /**
   * An operation that computes the quotient of two numeric operands.
   */
  class Div extends BinaryArithmeticOpcode, TDiv {
    final override string toString() { result = "Div" }
  }

  /**
   * An operation that computes the remainder of two integer operands.
   */
  class Rem extends BinaryArithmeticOpcode, TRem {
    final override string toString() { result = "Rem" }
  }

  /**
   * An operation that negates a single numeric operand.
   */
  class Negate extends UnaryArithmeticOpcode, TNegate {
    final override string toString() { result = "Negate" }
  }

  /**
   * An operation that shifts its left operand to the left by the number of bits specified by its
   * right operand.
   */
  class ShiftLeft extends BinaryBitwiseOpcode, TShiftLeft {
    final override string toString() { result = "ShiftLeft" }
  }

  /**
   * An operation that shifts its left operand to the right by the number of bits specified by its
   * right operand.
   */
  class ShiftRight extends BinaryBitwiseOpcode, TShiftRight {
    final override string toString() { result = "ShiftRight" }
  }

  /**
   * An operation that computes the bitwise "and" of two integer operands.
   */
  class BitAnd extends BinaryBitwiseOpcode, TBitAnd {
    final override string toString() { result = "BitAnd" }
  }

  /**
   * An operation that computes the bitwise "or" of two integer operands.
   */
  class BitOr extends BinaryBitwiseOpcode, TBitOr {
    final override string toString() { result = "BitOr" }
  }

  /**
   * An operation that computes the bitwise "xor" of two integer operands.
   */
  class BitXor extends BinaryBitwiseOpcode, TBitXor {
    final override string toString() { result = "BitXor" }
  }

  /**
   * An operation that computes the bitwise complement of its operand.
   */
  class BitComplement extends UnaryBitwiseOpcode, TBitComplement {
    final override string toString() { result = "BitComplement" }
  }

  /**
   * An operation that computes the logical complement of its operand.
   */
  class LogicalNot extends UnaryOpcode, TLogicalNot {
    final override string toString() { result = "LogicalNot" }
  }

  /**
   * An operation that returns a `true` result if its operands are equal.
   */
  class CompareEQ extends CompareOpcode, TCompareEQ {
    final override string toString() { result = "CompareEQ" }
  }

  /**
   * An operation that returns a `true` result if its operands are not equal.
   */
  class CompareNE extends CompareOpcode, TCompareNE {
    final override string toString() { result = "CompareNE" }
  }

  /**
   * An operation that returns a `true` result if its left operand is less than its right operand.
   */
  class CompareLT extends RelationalOpcode, TCompareLT {
    final override string toString() { result = "CompareLT" }
  }

  /**
   * An operation that returns a `true` result if its left operand is greater than its right operand.
   */
  class CompareGT extends RelationalOpcode, TCompareGT {
    final override string toString() { result = "CompareGT" }
  }

  /**
   * An operation that returns a `true` result if its left operand is less than or equal to its
   * right operand.
   */
  class CompareLE extends RelationalOpcode, TCompareLE {
    final override string toString() { result = "CompareLE" }
  }

  /**
   * An operation that returns a `true` result if its left operand is greater than or equal to its
   * right operand.
   */
  class CompareGE extends RelationalOpcode, TCompareGE {
    final override string toString() { result = "CompareGE" }
  }

  /**
   * An operation that adds an integer offset to a pointer.
   */
  class PointerAdd extends PointerOffsetOpcode, TPointerAdd {
    final override string toString() { result = "PointerAdd" }
  }

  /**
   * An operation that subtracts an integer offset from a pointer.
   */
  class PointerSub extends PointerOffsetOpcode, TPointerSub {
    final override string toString() { result = "PointerSub" }
  }

  /**
   * An operation that computes the difference between two pointers.
   */
  class PointerDiff extends PointerArithmeticOpcode, TPointerDiff {
    final override string toString() { result = "PointerDiff" }
  }

  /**
   * An operation that converts the value of its operand to a value of a different type.
   */
  class Convert extends UnaryOpcode, TConvert {
    final override string toString() { result = "Convert" }
  }

  /**
   * An operation that converts from the address of a derived class to the address of a direct
   * non-virtual base class.
   */
  class ConvertToNonVirtualBase extends ConvertToBaseOpcode, TConvertToNonVirtualBase {
    final override string toString() { result = "ConvertToNonVirtualBase" }
  }

  /**
   * An operation that converts from the address of a derived class to the address of a virtual base
   * class.
   */
  class ConvertToVirtualBase extends ConvertToBaseOpcode, TConvertToVirtualBase {
    final override string toString() { result = "ConvertToVirtualBase" }
  }

  /**
   * An operation that converts from the address of a base class to the address of a direct
   * non-virtual derived class.
   */
  class ConvertToDerived extends UnaryOpcode, TConvertToDerived {
    final override string toString() { result = "ConvertToDerived" }
  }

  /**
   * An operation that converts the address of a polymorphic object to the address of a different
   * subobject of the same polymorphic object, returning a null address if the dynamic type of the
   * object is not compatible with the result type.
   */
  class CheckedConvertOrNull extends UnaryOpcode, TCheckedConvertOrNull {
    final override string toString() { result = "CheckedConvertOrNull" }
  }

  /**
   * An operation that converts the address of a polymorphic object to the address of a different
   * subobject of the same polymorphic object, throwing an exception if the dynamic type of the object
   * is not compatible with the result type.
   */
  class CheckedConvertOrThrow extends UnaryOpcode, TCheckedConvertOrThrow {
    final override string toString() { result = "CheckedConvertOrThrow" }
  }

  /**
   * An operation that returns the address of the complete object that contains the subobject
   * pointed to by its operand.
   */
  class CompleteObjectAddress extends UnaryOpcode, TCompleteObjectAddress {
    final override string toString() { result = "CompleteObjectAddress" }
  }

  /**
   * An operation that returns the address of a variable.
   */
  class VariableAddress extends Opcode, TVariableAddress {
    final override string toString() { result = "VariableAddress" }
  }

  /**
   * An operation that computes the address of a non-static field of an object.
   */
  class FieldAddress extends UnaryOpcode, TFieldAddress {
    final override string toString() { result = "FieldAddress" }
  }

  /**
   * An operation that computes the address of the first element of a managed array.
   */
  class ElementsAddress extends UnaryOpcode, TElementsAddress {
    final override string toString() { result = "ElementsAddress" }
  }

  /**
   * An operation that returns the address of a function.
   */
  class FunctionAddress extends Opcode, TFunctionAddress {
    final override string toString() { result = "FunctionAddress" }
  }

  /**
   * An operation whose result is a constant value.
   */
  class Constant extends Opcode, TConstant {
    final override string toString() { result = "Constant" }
  }

  /**
   * An operation whose result is the address of a string literal.
   */
  class StringConstant extends Opcode, TStringConstant {
    final override string toString() { result = "StringConstant" }
  }

  /**
   * An operation that branches to one of two successor instructions based on the value of a Boolean
   * operand.
   */
  class ConditionalBranch extends OpcodeWithCondition, TConditionalBranch {
    final override string toString() { result = "ConditionalBranch" }
  }

  /**
   * An operation that branches to one of multiple successor instructions based on the value of an
   * integer operand.
   */
  class Switch extends OpcodeWithCondition, TSwitch {
    final override string toString() { result = "Switch" }
  }

  /**
   * An operation that calls a function.
   */
  class Call extends Opcode, TCall {
    final override string toString() { result = "Call" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof CallTargetOperandTag
    }
  }

  /**
   * An operation that catches an exception of a specific type.
   */
  class CatchByType extends CatchOpcode, TCatchByType {
    final override string toString() { result = "CatchByType" }
  }

  /**
   * An operation that catches any exception.
   */
  class CatchAny extends CatchOpcode, TCatchAny {
    final override string toString() { result = "CatchAny" }
  }

  /**
   * An operation that throws a new exception.
   */
  class ThrowValue extends ThrowOpcode, OpcodeWithLoad, TThrowValue {
    final override string toString() { result = "ThrowValue" }
  }

  /**
   * An operation that re-throws the current exception.
   */
  class ReThrow extends ThrowOpcode, TReThrow {
    final override string toString() { result = "ReThrow" }
  }

  /**
   * An operation that exits the current function by propagating an exception.
   */
  class Unwind extends Opcode, TUnwind {
    final override string toString() { result = "Unwind" }
  }

  /**
   * An operation that initializes all escaped memory.
   */
  class AliasedDefinition extends Opcode, TAliasedDefinition {
    final override string toString() { result = "AliasedDefinition" }

    final override MemoryAccessKind getWriteMemoryAccess() { result instanceof EscapedMemoryAccess }
  }

  /**
   * An operation that initializes all memory that existed before this function was called.
   */
  class InitializeNonLocal extends Opcode, TInitializeNonLocal {
    final override string toString() { result = "InitializeNonLocal" }

    final override MemoryAccessKind getWriteMemoryAccess() {
      result instanceof NonLocalMemoryAccess
    }
  }

  /**
   * An operation that consumes all escaped memory on exit from the function.
   */
  class AliasedUse extends Opcode, TAliasedUse {
    final override string toString() { result = "AliasedUse" }

    final override MemoryAccessKind getReadMemoryAccess() { result instanceof NonLocalMemoryAccess }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  /**
   * An operation representing the choice of one of multiple input values based on control flow.
   */
  class Phi extends Opcode, TPhi {
    final override string toString() { result = "Phi" }

    final override MemoryAccessKind getWriteMemoryAccess() { result instanceof PhiMemoryAccess }
  }

  /**
   * An operation representing a built-in operation that does not have a specific opcode. The
   * actual operation is specified by the `getBuiltInOperation()` predicate.
   */
  class BuiltIn extends BuiltInOperationOpcode, TBuiltIn {
    final override string toString() { result = "BuiltIn" }
  }

  /**
   * An operation that returns a `va_list` to access the arguments passed to the `...` parameter.
   */
  class VarArgsStart extends UnaryOpcode, TVarArgsStart {
    final override string toString() { result = "VarArgsStart" }
  }

  /**
   * An operation that cleans up a `va_list` after it is no longer in use.
   */
  class VarArgsEnd extends UnaryOpcode, TVarArgsEnd {
    final override string toString() { result = "VarArgsEnd" }
  }

  /**
   * An operation that returns the address of the argument currently pointed to by a `va_list`.
   */
  class VarArg extends UnaryOpcode, TVarArg {
    final override string toString() { result = "VarArg" }
  }

  /**
   * An operation that modifies a `va_list` to point to the next argument that was passed to the
   * `...` parameter.
   */
  class NextVarArg extends UnaryOpcode, TNextVarArg {
    final override string toString() { result = "NextVarArg" }
  }

  /**
   * An operation representing the side effect of a function call on any memory that might be
   * accessed by that call.
   */
  class CallSideEffect extends WriteSideEffectOpcode, EscapedWriteOpcode, MayWriteOpcode,
    ReadSideEffectOpcode, EscapedReadOpcode, MayReadOpcode, TCallSideEffect {
    final override string toString() { result = "CallSideEffect" }
  }

  /**
   * An operation representing the side effect of a function call on any memory
   * that might be read by that call.
   */
  class CallReadSideEffect extends ReadSideEffectOpcode, EscapedReadOpcode, MayReadOpcode,
    TCallReadSideEffect {
    final override string toString() { result = "CallReadSideEffect" }
  }

  /**
   * An operation representing the read of an indirect parameter within a function call.
   */
  class IndirectReadSideEffect extends ReadSideEffectOpcode, IndirectReadOpcode,
    TIndirectReadSideEffect {
    final override string toString() { result = "IndirectReadSideEffect" }
  }

  /**
   * An operation representing the write of an indirect parameter within a function call.
   */
  class IndirectMustWriteSideEffect extends WriteSideEffectOpcode, IndirectWriteOpcode,
    TIndirectMustWriteSideEffect {
    final override string toString() { result = "IndirectMustWriteSideEffect" }
  }

  /**
   * An operation representing the potential write of an indirect parameter within a function call.
   */
  class IndirectMayWriteSideEffect extends WriteSideEffectOpcode, IndirectWriteOpcode,
    MayWriteOpcode, TIndirectMayWriteSideEffect {
    final override string toString() { result = "IndirectMayWriteSideEffect" }
  }

  /**
   * An operation representing the read of an indirect buffer parameter within a function call.
   */
  class BufferReadSideEffect extends ReadSideEffectOpcode, UnsizedBufferReadOpcode,
    TBufferReadSideEffect {
    final override string toString() { result = "BufferReadSideEffect" }
  }

  /**
   * An operation representing the write of an indirect buffer parameter within a function call. The
   * entire buffer is overwritten.
   */
  class BufferMustWriteSideEffect extends WriteSideEffectOpcode, UnsizedBufferWriteOpcode,
    TBufferMustWriteSideEffect {
    final override string toString() { result = "BufferMustWriteSideEffect" }
  }

  /**
   * An operation representing the write of an indirect buffer parameter within a function call.
   */
  class BufferMayWriteSideEffect extends WriteSideEffectOpcode, UnsizedBufferWriteOpcode,
    MayWriteOpcode, TBufferMayWriteSideEffect {
    final override string toString() { result = "BufferMayWriteSideEffect" }
  }

  /**
   * An operation representing the read of an indirect buffer parameter within a function call.
   */
  class SizedBufferReadSideEffect extends ReadSideEffectOpcode, SizedBufferReadOpcode,
    TSizedBufferReadSideEffect {
    final override string toString() { result = "SizedBufferReadSideEffect" }
  }

  /**
   * An operation representing the write of an indirect buffer parameter within a function call. The
   * entire buffer is overwritten.
   */
  class SizedBufferMustWriteSideEffect extends WriteSideEffectOpcode, SizedBufferWriteOpcode,
    TSizedBufferMustWriteSideEffect {
    final override string toString() { result = "SizedBufferMustWriteSideEffect" }
  }

  /**
   * An operation representing the write of an indirect buffer parameter within a function call.
   */
  class SizedBufferMayWriteSideEffect extends WriteSideEffectOpcode, SizedBufferWriteOpcode,
    MayWriteOpcode, TSizedBufferMayWriteSideEffect {
    final override string toString() { result = "SizedBufferMayWriteSideEffect" }
  }

  /**
   * An operation representing the initial value of newly allocated memory, such as the result of a
   * call to `malloc`.
   */
  class InitializeDynamicAllocation extends SideEffectOpcode, EntireAllocationWriteOpcode,
    TInitializeDynamicAllocation {
    final override string toString() { result = "InitializeDynamicAllocation" }
  }

  /**
   * An operation representing the effect that a write to a memory may have on potential aliases of
   * that memory.
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
   * An operation representing a GNU or MSVC inline assembly statement.
   */
  class InlineAsm extends Opcode, EscapedWriteOpcode, MayWriteOpcode, EscapedReadOpcode,
    MayReadOpcode, TInlineAsm {
    final override string toString() { result = "InlineAsm" }

    final override predicate hasOperandInternal(OperandTag tag) {
      tag instanceof SideEffectOperandTag
    }
  }

  /**
   * An operation representing unreachable code.
   */
  class Unreached extends Opcode, TUnreached {
    final override string toString() { result = "Unreached" }
  }

  /**
   * An operation that allocates a new object on the managed heap.
   */
  class NewObj extends Opcode, TNewObj {
    final override string toString() { result = "NewObj" }
  }
}
