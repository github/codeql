/**
 * Definitions of all possible opcodes for `SemExpr`.
 */
private newtype TOpcode =
  TInitializeParameter() or
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
  TShiftRightUnsigned() or // TODO: Based on type
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
  TConstant() or
  TStringConstant() or
  TAddOne() or // TODO: Combine with `TAdd`
  TSubOne() or // TODO: Combine with `TSub`
  TConditional() or // TODO: Represent as flow
  TCall() or
  TBox() or
  TUnbox() or
  TUnknown()

class Opcode extends TOpcode {
  string toString() { result = "???" }
}

module Opcode {
  class InitializeParameter extends Opcode, TInitializeParameter {
    override string toString() { result = "InitializeParameter" }
  }

  class CopyValue extends Opcode, TCopyValue {
    override string toString() { result = "CopyValue" }
  }

  class Load extends Opcode, TLoad {
    override string toString() { result = "Load" }
  }

  class Store extends Opcode, TStore {
    override string toString() { result = "Store" }
  }

  class Add extends Opcode, TAdd {
    override string toString() { result = "Add" }
  }

  class PointerAdd extends Opcode, TPointerAdd {
    override string toString() { result = "PointerAdd" }
  }

  class Sub extends Opcode, TSub {
    override string toString() { result = "Sub" }
  }

  class PointerSub extends Opcode, TPointerSub {
    override string toString() { result = "PointerSub" }
  }

  class Mul extends Opcode, TMul {
    override string toString() { result = "Mul" }
  }

  class Div extends Opcode, TDiv {
    override string toString() { result = "Div" }
  }

  class Rem extends Opcode, TRem {
    override string toString() { result = "Rem" }
  }

  class Negate extends Opcode, TNegate {
    override string toString() { result = "Negate" }
  }

  class ShiftLeft extends Opcode, TShiftLeft {
    override string toString() { result = "ShiftLeft" }
  }

  class ShiftRight extends Opcode, TShiftRight {
    override string toString() { result = "ShiftRight" }
  }

  class ShiftRightUnsigned extends Opcode, TShiftRightUnsigned {
    override string toString() { result = "ShiftRightUnsigned" }
  }

  class BitAnd extends Opcode, TBitAnd {
    override string toString() { result = "BitAnd" }
  }

  class BitOr extends Opcode, TBitOr {
    override string toString() { result = "BitOr" }
  }

  class BitXor extends Opcode, TBitXor {
    override string toString() { result = "BitXor" }
  }

  class BitComplement extends Opcode, TBitComplement {
    override string toString() { result = "BitComplement" }
  }

  class LogicalNot extends Opcode, TLogicalNot {
    override string toString() { result = "LogicalNot" }
  }

  class CompareEQ extends Opcode, TCompareEQ {
    override string toString() { result = "CompareEQ" }
  }

  class CompareNE extends Opcode, TCompareNE {
    override string toString() { result = "CompareNE" }
  }

  class CompareLT extends Opcode, TCompareLT {
    override string toString() { result = "CompareLT" }
  }

  class CompareLE extends Opcode, TCompareLE {
    override string toString() { result = "CompareLE" }
  }

  class CompareGT extends Opcode, TCompareGT {
    override string toString() { result = "CompareGT" }
  }

  class CompareGE extends Opcode, TCompareGE {
    override string toString() { result = "CompareGE" }
  }

  class Convert extends Opcode, TConvert {
    override string toString() { result = "Convert" }
  }

  class AddOne extends Opcode, TAddOne {
    override string toString() { result = "AddOne" }
  }

  class SubOne extends Opcode, TSubOne {
    override string toString() { result = "SubOne" }
  }

  class Conditional extends Opcode, TConditional {
    override string toString() { result = "Conditional" }
  }

  class Constant extends Opcode, TConstant {
    override string toString() { result = "Constant" }
  }

  class StringConstant extends Opcode, TStringConstant {
    override string toString() { result = "StringConstant" }
  }

  class Box extends Opcode, TBox {
    override string toString() { result = "Box" }
  }

  class Unbox extends Opcode, TUnbox {
    override string toString() { result = "Unbox" }
  }

  class Unknown extends Opcode, TUnknown {
    override string toString() { result = "Unknown" }
  }
}
