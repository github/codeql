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
  TPhi() or
  TVarArgsStart() or
  TVarArgsEnd() or
  TVarArg() or
  TVarArgCopy()

class Opcode extends TOpcode {
  string toString() {
    result = "UnknownOpcode"
  }
}

abstract class UnaryOpcode extends Opcode {}

abstract class BinaryOpcode extends Opcode {}

abstract class PointerArithmeticOpcode extends BinaryOpcode {}

abstract class PointerOffsetOpcode extends PointerArithmeticOpcode {}

abstract class CompareOpcode extends BinaryOpcode {}

abstract class CopyOpcode extends Opcode {}

abstract class MemoryAccessOpcode extends Opcode {}

abstract class ReturnOpcode extends Opcode {}

abstract class ThrowOpcode extends Opcode {}

abstract class CatchOpcode extends Opcode {}

abstract class OpcodeWithCondition extends Opcode {}

abstract class BuiltInOpcode extends Opcode {}

module Opcode {
  class NoOp extends Opcode, TNoOp { override final string toString() { result = "NoOp" } }
  class Uninitialized extends MemoryAccessOpcode, TUninitialized { override final string toString() { result = "Uninitialized" } }
  class InitializeParameter extends MemoryAccessOpcode, TInitializeParameter { override final string toString() { result = "InitializeParameter" } }
  class InitializeThis extends Opcode, TInitializeThis { override final string toString() { result = "InitializeThis" } }
  class EnterFunction extends Opcode, TEnterFunction { override final string toString() { result = "EnterFunction" } }
  class ExitFunction extends Opcode, TExitFunction { override final string toString() { result = "ExitFunction" } }
  class ReturnValue extends ReturnOpcode, MemoryAccessOpcode, TReturnValue { override final string toString() { result = "ReturnValue" } }
  class ReturnVoid extends ReturnOpcode, TReturnVoid { override final string toString() { result = "ReturnVoid" } }
  class CopyValue extends CopyOpcode, TCopyValue { override final string toString() { result = "CopyValue" } }
  class Load extends CopyOpcode, MemoryAccessOpcode, TLoad { override final string toString() { result = "Load" } }
  class Store extends CopyOpcode, MemoryAccessOpcode, TStore { override final string toString() { result = "Store" } }
  class Add extends BinaryOpcode, TAdd { override final string toString() { result = "Add" } }
  class Sub extends BinaryOpcode, TSub { override final string toString() { result = "Sub" } }
  class Mul extends BinaryOpcode, TMul { override final string toString() { result = "Mul" } }
  class Div extends BinaryOpcode, TDiv { override final string toString() { result = "Div" } }
  class Rem extends BinaryOpcode, TRem { override final string toString() { result = "Rem" } }
  class Negate extends UnaryOpcode, TNegate { override final string toString() { result = "Negate" } }
  class ShiftLeft extends BinaryOpcode, TShiftLeft { override final string toString() { result = "ShiftLeft" } }
  class ShiftRight extends BinaryOpcode, TShiftRight { override final string toString() { result = "ShiftRight" } }
  class BitAnd extends BinaryOpcode, TBitAnd { override final string toString() { result = "BitAnd" } }
  class BitOr extends BinaryOpcode, TBitOr { override final string toString() { result = "BitOr" } }
  class BitXor extends BinaryOpcode, TBitXor { override final string toString() { result = "BitXor" } }
  class BitComplement extends UnaryOpcode, TBitComplement { override final string toString() { result = "BitComplement" } }
  class LogicalNot extends UnaryOpcode, TLogicalNot { override final string toString() { result = "LogicalNot" } }
  class CompareEQ extends CompareOpcode, TCompareEQ { override final string toString() { result = "CompareEQ" } }
  class CompareNE extends CompareOpcode, TCompareNE { override final string toString() { result = "CompareNE" } }
  class CompareLT extends CompareOpcode, TCompareLT { override final string toString() { result = "CompareLT" } }
  class CompareGT extends CompareOpcode, TCompareGT { override final string toString() { result = "CompareGT" } }
  class CompareLE extends CompareOpcode, TCompareLE { override final string toString() { result = "CompareLE" } }
  class CompareGE extends CompareOpcode, TCompareGE { override final string toString() { result = "CompareGE" } }
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
  class ThrowValue extends ThrowOpcode, MemoryAccessOpcode, TThrowValue { override final string toString() { result = "ThrowValue" } }
  class ReThrow extends ThrowOpcode, TReThrow { override final string toString() { result = "ReThrow" } }
  class Unwind extends Opcode, TUnwind { override final string toString() { result = "Unwind" } }
  class UnmodeledDefinition extends Opcode, TUnmodeledDefinition { override final string toString() { result = "UnmodeledDefinition" } }
  class UnmodeledUse extends Opcode, TUnmodeledUse { override final string toString() { result = "UnmodeledUse" } }
  class Phi extends Opcode, TPhi { override final string toString() { result = "Phi" } }
  class VarArgsStart extends BuiltInOpcode, TVarArgsStart { override final string toString() { result = "VarArgsStart" } }
  class VarArgsEnd extends BuiltInOpcode, TVarArgsEnd { override final string toString() { result = "VarArgsEnd" } }
  class VarArg extends BuiltInOpcode, TVarArg { override final string toString() { result = "VarArg" } }
  class VarArgCopy extends BuiltInOpcode, TVarArgCopy { override final string toString() { result = "VarArgCopy" } }
}
