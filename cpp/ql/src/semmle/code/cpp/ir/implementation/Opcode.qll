private newtype TOpcode =
  TNoOp() or
  TUninitialized() or
  TInitializeParameter() or
  TInitializeThis() or
  TEnterFunction() or
  TExitFunction() or
  TReturnValue() or
  TReturnVoid() or
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
  TConvertToBase() or
  TConvertToVirtualBase() or
  TConvertToDerived() or
  TCheckedConvertOrNull() or
  TCheckedConvertOrThrow() or
  TDynamicCastToVoid() or
  TVariableAddress() or
  TFieldAddress() or
  TFunctionAddress() or
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
  TPhi() or
  TVarArgsStart() or
  TVarArgsEnd() or
  TVarArg() or
  TVarArgCopy() or
  TCallSideEffect() or
  TCallReadSideEffect() or
  TIndirectReadSideEffect() or
  TIndirectWriteSideEffect() or
  TIndirectMayWriteSideEffect() or
  TBufferReadSideEffect() or
  TBufferWriteSideEffect() or
  TBufferMayWriteSideEffect() or
  TChi() or
  TInlineAsm() or
  TUnreached()

class Opcode extends TOpcode {
  string toString() {
    result = "UnknownOpcode"
  }
}

abstract class UnaryOpcode extends Opcode {}

abstract class BinaryOpcode extends Opcode {}

abstract class PointerArithmeticOpcode extends BinaryOpcode {}

abstract class PointerOffsetOpcode extends PointerArithmeticOpcode {}

abstract class ArithmeticOpcode extends Opcode {}

abstract class BinaryArithmeticOpcode extends BinaryOpcode, ArithmeticOpcode {}

abstract class UnaryArithmeticOpcode extends UnaryOpcode, ArithmeticOpcode {}

abstract class BitwiseOpcode extends Opcode {}

abstract class BinaryBitwiseOpcode extends BinaryOpcode, BitwiseOpcode {}

abstract class UnaryBitwiseOpcode extends UnaryOpcode, BitwiseOpcode {}

abstract class CompareOpcode extends BinaryOpcode {}

abstract class RelationalOpcode extends CompareOpcode {}

abstract class CopyOpcode extends Opcode {}

abstract class MemoryAccessOpcode extends Opcode {}

abstract class ReturnOpcode extends Opcode {}

abstract class ThrowOpcode extends Opcode {}

abstract class CatchOpcode extends Opcode {}

abstract class OpcodeWithCondition extends Opcode {}

abstract class BuiltInOpcode extends Opcode {}

abstract class SideEffectOpcode extends Opcode {}

/**
 * An opcode that reads a value from memory.
 */
abstract class OpcodeWithLoad extends MemoryAccessOpcode {}

/**
 * An opcode that reads from a set of memory locations as a side effect.
 */
abstract class ReadSideEffectOpcode extends SideEffectOpcode {}

/**
 * An opcode that writes to a set of memory locations as a side effect.
 */
abstract class WriteSideEffectOpcode extends SideEffectOpcode {}

/**
 * An opcode that may overwrite some, all, or none of an existing set of memory locations. Modeled
 * as a read of the original contents, plus a "may" write of the new contents.
 */
abstract class MayWriteSideEffectOpcode extends SideEffectOpcode {}

/**
 * An opcode that accesses a buffer via an `AddressOperand` and a `BufferSizeOperand`.
 */
abstract class BufferAccessOpcode extends MemoryAccessOpcode {}

module Opcode {
  class NoOp extends Opcode, TNoOp { override final string toString() { result = "NoOp" } }
  class Uninitialized extends MemoryAccessOpcode, TUninitialized { override final string toString() { result = "Uninitialized" } }
  class InitializeParameter extends MemoryAccessOpcode, TInitializeParameter { override final string toString() { result = "InitializeParameter" } }
  class InitializeThis extends Opcode, TInitializeThis { override final string toString() { result = "InitializeThis" } }
  class EnterFunction extends Opcode, TEnterFunction { override final string toString() { result = "EnterFunction" } }
  class ExitFunction extends Opcode, TExitFunction { override final string toString() { result = "ExitFunction" } }
  class ReturnValue extends ReturnOpcode, OpcodeWithLoad, TReturnValue { override final string toString() { result = "ReturnValue" } }
  class ReturnVoid extends ReturnOpcode, TReturnVoid { override final string toString() { result = "ReturnVoid" } }
  class CopyValue extends UnaryOpcode, CopyOpcode, TCopyValue { override final string toString() { result = "CopyValue" } }
  class Load extends CopyOpcode, OpcodeWithLoad, TLoad { override final string toString() { result = "Load" } }
  class Store extends CopyOpcode, MemoryAccessOpcode, TStore { override final string toString() { result = "Store" } }
  class Add extends BinaryArithmeticOpcode, TAdd { override final string toString() { result = "Add" } }
  class Sub extends BinaryArithmeticOpcode, TSub { override final string toString() { result = "Sub" } }
  class Mul extends BinaryArithmeticOpcode, TMul { override final string toString() { result = "Mul" } }
  class Div extends BinaryArithmeticOpcode, TDiv { override final string toString() { result = "Div" } }
  class Rem extends BinaryArithmeticOpcode, TRem { override final string toString() { result = "Rem" } }
  class Negate extends UnaryArithmeticOpcode, TNegate { override final string toString() { result = "Negate" } }
  class ShiftLeft extends BinaryBitwiseOpcode, TShiftLeft { override final string toString() { result = "ShiftLeft" } }
  class ShiftRight extends BinaryBitwiseOpcode, TShiftRight { override final string toString() { result = "ShiftRight" } }
  class BitAnd extends BinaryBitwiseOpcode, TBitAnd { override final string toString() { result = "BitAnd" } }
  class BitOr extends BinaryBitwiseOpcode, TBitOr { override final string toString() { result = "BitOr" } }
  class BitXor extends BinaryBitwiseOpcode, TBitXor { override final string toString() { result = "BitXor" } }
  class BitComplement extends UnaryBitwiseOpcode, TBitComplement { override final string toString() { result = "BitComplement" } }
  class LogicalNot extends UnaryOpcode, TLogicalNot { override final string toString() { result = "LogicalNot" } }
  class CompareEQ extends CompareOpcode, TCompareEQ { override final string toString() { result = "CompareEQ" } }
  class CompareNE extends CompareOpcode, TCompareNE { override final string toString() { result = "CompareNE" } }
  class CompareLT extends RelationalOpcode, TCompareLT { override final string toString() { result = "CompareLT" } }
  class CompareGT extends RelationalOpcode, TCompareGT { override final string toString() { result = "CompareGT" } }
  class CompareLE extends RelationalOpcode, TCompareLE { override final string toString() { result = "CompareLE" } }
  class CompareGE extends RelationalOpcode, TCompareGE { override final string toString() { result = "CompareGE" } }
  class PointerAdd extends PointerOffsetOpcode, TPointerAdd { override final string toString() { result = "PointerAdd" } }
  class PointerSub extends PointerOffsetOpcode, TPointerSub { override final string toString() { result = "PointerSub" } }
  class PointerDiff extends PointerArithmeticOpcode, TPointerDiff { override final string toString() { result = "PointerDiff" } }
  class Convert extends UnaryOpcode, TConvert { override final string toString() { result = "Convert" } }
  class ConvertToBase extends UnaryOpcode, TConvertToBase { override final string toString() { result = "ConvertToBase" } }
  class ConvertToVirtualBase extends UnaryOpcode, TConvertToVirtualBase { override final string toString() { result = "ConvertToVirtualBase" } }
  class ConvertToDerived extends UnaryOpcode, TConvertToDerived { override final string toString() { result = "ConvertToDerived" } }
  class CheckedConvertOrNull extends UnaryOpcode, TCheckedConvertOrNull { override final string toString() { result = "CheckedConvertOrNull" } }
  class CheckedConvertOrThrow extends UnaryOpcode, TCheckedConvertOrThrow { override final string toString() { result = "CheckedConvertOrThrow" } }
  class DynamicCastToVoid extends UnaryOpcode, TDynamicCastToVoid { override final string toString() { result = "DynamicCastToVoid" } }
  class VariableAddress extends Opcode, TVariableAddress { override final string toString() { result = "VariableAddress" } }
  class FieldAddress extends UnaryOpcode, TFieldAddress { override final string toString() { result = "FieldAddress" } }
  class FunctionAddress extends Opcode, TFunctionAddress { override final string toString() { result = "FunctionAddress" } }
  class Constant extends Opcode, TConstant { override final string toString() { result = "Constant" } }
  class StringConstant extends Opcode, TStringConstant { override final string toString() { result = "StringConstant" } }
  class ConditionalBranch extends OpcodeWithCondition, TConditionalBranch { override final string toString() { result = "ConditionalBranch" } }
  class Switch extends OpcodeWithCondition, TSwitch { override final string toString() { result = "Switch" } }
  class Call extends Opcode, TCall { override final string toString() { result = "Call" } }
  class CatchByType extends CatchOpcode, TCatchByType { override final string toString() { result = "CatchByType" } }
  class CatchAny extends CatchOpcode, TCatchAny { override final string toString() { result = "CatchAny" } }
  class ThrowValue extends ThrowOpcode, OpcodeWithLoad, TThrowValue { override final string toString() { result = "ThrowValue" } }
  class ReThrow extends ThrowOpcode, TReThrow { override final string toString() { result = "ReThrow" } }
  class Unwind extends Opcode, TUnwind { override final string toString() { result = "Unwind" } }
  class UnmodeledDefinition extends Opcode, TUnmodeledDefinition { override final string toString() { result = "UnmodeledDefinition" } }
  class UnmodeledUse extends Opcode, TUnmodeledUse { override final string toString() { result = "UnmodeledUse" } }
  class AliasedDefinition extends Opcode, TAliasedDefinition { override final string toString() { result = "AliasedDefinition" } }
  class Phi extends Opcode, TPhi { override final string toString() { result = "Phi" } }
  class VarArgsStart extends BuiltInOpcode, TVarArgsStart { override final string toString() { result = "VarArgsStart" } }
  class VarArgsEnd extends BuiltInOpcode, TVarArgsEnd { override final string toString() { result = "VarArgsEnd" } }
  class VarArg extends BuiltInOpcode, TVarArg { override final string toString() { result = "VarArg" } }
  class VarArgCopy extends BuiltInOpcode, TVarArgCopy { override final string toString() { result = "VarArgCopy" } }
  class CallSideEffect extends MayWriteSideEffectOpcode, TCallSideEffect { override final string toString() { result = "CallSideEffect" } }
  class CallReadSideEffect extends ReadSideEffectOpcode, TCallReadSideEffect { override final string toString() { result = "CallReadSideEffect" } }
  class IndirectReadSideEffect extends ReadSideEffectOpcode, MemoryAccessOpcode, TIndirectReadSideEffect { override final string toString() { result = "IndirectReadSideEffect" } }
  class IndirectWriteSideEffect extends WriteSideEffectOpcode, MemoryAccessOpcode, TIndirectWriteSideEffect { override final string toString() { result = "IndirectWriteSideEffect" } }
  class IndirectMayWriteSideEffect extends MayWriteSideEffectOpcode, MemoryAccessOpcode, TIndirectMayWriteSideEffect { override final string toString() { result = "IndirectMayWriteSideEffect" } }
  class BufferReadSideEffect extends ReadSideEffectOpcode, BufferAccessOpcode, TBufferReadSideEffect { override final string toString() { result = "BufferReadSideEffect" } }
  class BufferWriteSideEffect extends WriteSideEffectOpcode, BufferAccessOpcode, TBufferWriteSideEffect { override final string toString() { result = "BufferWriteSideEffect" } }
  class BufferMayWriteSideEffect extends MayWriteSideEffectOpcode, BufferAccessOpcode, TBufferMayWriteSideEffect { override final string toString() { result = "BufferMayWriteSideEffect" } }
  class Chi extends Opcode, TChi { override final string toString() { result = "Chi" } }
  class InlineAsm extends Opcode, TInlineAsm { override final string toString() {result = "InlineAsm" }}
  class Unreached extends Opcode, TUnreached { override final string toString() { result = "Unreached" } }
}
