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
  TUnmodeledDefinition() or
  TUnmodeledUse() or
  TAliasedDefinition() or
  TAliasedUse() or
  TPhi() or
  TBuiltIn() or
  TVarArgsStart() or
  TVarArgsEnd() or
  TVarArg() or
  TVarArgCopy() or
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
  TChi() or
  TInlineAsm() or
  TUnreached() or
  TNewObj()

class Opcode extends TOpcode {
  string toString() { result = "UnknownOpcode" }
}

abstract class UnaryOpcode extends Opcode { }

abstract class BinaryOpcode extends Opcode { }

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

abstract class OpcodeWithCondition extends Opcode { }

abstract class BuiltInOperationOpcode extends Opcode { }

abstract class SideEffectOpcode extends Opcode { }

/**
 * An opcode that reads a value from memory.
 */
abstract class OpcodeWithLoad extends MemoryAccessOpcode { }

/**
 * An opcode that reads from a set of memory locations as a side effect.
 */
abstract class ReadSideEffectOpcode extends SideEffectOpcode { }

/**
 * An opcode that writes to a set of memory locations as a side effect.
 */
abstract class WriteSideEffectOpcode extends SideEffectOpcode { }

/**
 * An opcode that definitely writes to a set of memory locations as a side effect.
 */
abstract class MustWriteSideEffectOpcode extends WriteSideEffectOpcode { }

/**
 * An opcode that may overwrite some, all, or none of an existing set of memory locations. Modeled
 * as a read of the original contents, plus a "may" write of the new contents.
 */
abstract class MayWriteSideEffectOpcode extends WriteSideEffectOpcode { }

/**
 * An opcode that accesses a buffer via an `AddressOperand`.
 */
abstract class BufferAccessOpcode extends MemoryAccessOpcode { }

/**
 * An opcode that accesses a buffer via an `AddressOperand` with a `BufferSizeOperand` specifying
 * the number of elements accessed.
 */
abstract class SizedBufferAccessOpcode extends BufferAccessOpcode { }

module Opcode {
  class NoOp extends Opcode, TNoOp {
    final override string toString() { result = "NoOp" }
  }

  class Uninitialized extends MemoryAccessOpcode, TUninitialized {
    final override string toString() { result = "Uninitialized" }
  }

  class Error extends Opcode, TError {
    final override string toString() { result = "Error" }
  }

  class InitializeParameter extends MemoryAccessOpcode, TInitializeParameter {
    final override string toString() { result = "InitializeParameter" }
  }

  class InitializeIndirection extends MemoryAccessOpcode, TInitializeIndirection {
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

  class ReturnIndirection extends MemoryAccessOpcode, TReturnIndirection {
    final override string toString() { result = "ReturnIndirection" }
  }

  class CopyValue extends UnaryOpcode, CopyOpcode, TCopyValue {
    final override string toString() { result = "CopyValue" }
  }

  class Load extends CopyOpcode, OpcodeWithLoad, TLoad {
    final override string toString() { result = "Load" }
  }

  class Store extends CopyOpcode, MemoryAccessOpcode, TStore {
    final override string toString() { result = "Store" }
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

  class UnmodeledDefinition extends Opcode, TUnmodeledDefinition {
    final override string toString() { result = "UnmodeledDefinition" }
  }

  class UnmodeledUse extends Opcode, TUnmodeledUse {
    final override string toString() { result = "UnmodeledUse" }
  }

  class AliasedDefinition extends Opcode, TAliasedDefinition {
    final override string toString() { result = "AliasedDefinition" }
  }

  class AliasedUse extends Opcode, TAliasedUse {
    final override string toString() { result = "AliasedUse" }
  }

  class Phi extends Opcode, TPhi {
    final override string toString() { result = "Phi" }
  }

  class BuiltIn extends BuiltInOperationOpcode, TBuiltIn {
    final override string toString() { result = "BuiltIn" }
  }

  class VarArgsStart extends BuiltInOperationOpcode, TVarArgsStart {
    final override string toString() { result = "VarArgsStart" }
  }

  class VarArgsEnd extends BuiltInOperationOpcode, TVarArgsEnd {
    final override string toString() { result = "VarArgsEnd" }
  }

  class VarArg extends BuiltInOperationOpcode, TVarArg {
    final override string toString() { result = "VarArg" }
  }

  class VarArgCopy extends BuiltInOperationOpcode, TVarArgCopy {
    final override string toString() { result = "VarArgCopy" }
  }

  class CallSideEffect extends MayWriteSideEffectOpcode, TCallSideEffect {
    final override string toString() { result = "CallSideEffect" }
  }

  class CallReadSideEffect extends ReadSideEffectOpcode, TCallReadSideEffect {
    final override string toString() { result = "CallReadSideEffect" }
  }

  class IndirectReadSideEffect extends ReadSideEffectOpcode, MemoryAccessOpcode,
    TIndirectReadSideEffect {
    final override string toString() { result = "IndirectReadSideEffect" }
  }

  class IndirectMustWriteSideEffect extends MustWriteSideEffectOpcode, MemoryAccessOpcode,
    TIndirectMustWriteSideEffect {
    final override string toString() { result = "IndirectMustWriteSideEffect" }
  }

  class IndirectMayWriteSideEffect extends MayWriteSideEffectOpcode, MemoryAccessOpcode,
    TIndirectMayWriteSideEffect {
    final override string toString() { result = "IndirectMayWriteSideEffect" }
  }

  class BufferReadSideEffect extends ReadSideEffectOpcode, BufferAccessOpcode, TBufferReadSideEffect {
    final override string toString() { result = "BufferReadSideEffect" }
  }

  class BufferMustWriteSideEffect extends MustWriteSideEffectOpcode, BufferAccessOpcode,
    TBufferMustWriteSideEffect {
    final override string toString() { result = "BufferMustWriteSideEffect" }
  }

  class BufferMayWriteSideEffect extends MayWriteSideEffectOpcode, BufferAccessOpcode,
    TBufferMayWriteSideEffect {
    final override string toString() { result = "BufferMayWriteSideEffect" }
  }

  class SizedBufferReadSideEffect extends ReadSideEffectOpcode, SizedBufferAccessOpcode,
    TSizedBufferReadSideEffect {
    final override string toString() { result = "SizedBufferReadSideEffect" }
  }

  class SizedBufferMustWriteSideEffect extends MustWriteSideEffectOpcode, SizedBufferAccessOpcode,
    TSizedBufferMustWriteSideEffect {
    final override string toString() { result = "SizedBufferMustWriteSideEffect" }
  }

  class SizedBufferMayWriteSideEffect extends MayWriteSideEffectOpcode, SizedBufferAccessOpcode,
    TSizedBufferMayWriteSideEffect {
    final override string toString() { result = "SizedBufferMayWriteSideEffect" }
  }

  class Chi extends Opcode, TChi {
    final override string toString() { result = "Chi" }
  }

  class InlineAsm extends Opcode, TInlineAsm {
    final override string toString() { result = "InlineAsm" }
  }

  class Unreached extends Opcode, TUnreached {
    final override string toString() { result = "Unreached" }
  }

  class NewObj extends Opcode, TNewObj {
    final override string toString() { result = "NewObj" }
  }
}
