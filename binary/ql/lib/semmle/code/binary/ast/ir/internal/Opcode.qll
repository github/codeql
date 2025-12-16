private newtype TOpcode =
  TLoad() or
  TStore() or
  TAdd() or
  TSub() or
  TMul() or
  TDiv() or
  TAnd() or
  TOr() or
  TXor() or
  TShl() or
  TShr() or
  TSar() or
  TRol() or
  TRor() or
  TGoto() or
  TConst() or
  TCall() or
  TCopy() or
  TJump() or
  TCJump() or
  TRetValue() or
  TRet() or
  TNop() or
  TNot() or
  TInit() or
  TFieldAddress() or
  // TODO: Ideally, this should either be removed when we handle unresolved CIL calls better.
  TExternalRef() or
  TFunEntry()

class Opcode extends TOpcode {
  string toString() { none() }
}

class FunEntry extends Opcode, TFunEntry {
  override string toString() { result = "FunEntry" }
}

class Load extends Opcode, TLoad {
  override string toString() { result = "Load" }
}

class Store extends Opcode, TStore {
  override string toString() { result = "Store" }
}

abstract private class AbstractBinaryOpcode extends Opcode { }

final class BinaryOpcode = AbstractBinaryOpcode;

class Add extends AbstractBinaryOpcode, TAdd {
  override string toString() { result = "Add" }
}

class Sub extends AbstractBinaryOpcode, TSub {
  override string toString() { result = "Sub" }
}

class Mul extends AbstractBinaryOpcode, TMul {
  override string toString() { result = "Mul" }
}

class Div extends AbstractBinaryOpcode, TDiv {
  override string toString() { result = "Div" }
}

class And extends AbstractBinaryOpcode, TAnd {
  override string toString() { result = "And" }
}

class Or extends AbstractBinaryOpcode, TOr {
  override string toString() { result = "Or" }
}

class Xor extends AbstractBinaryOpcode, TXor {
  override string toString() { result = "Xor" }
}

class Shl extends AbstractBinaryOpcode, TShl {
  override string toString() { result = "Shl" }
}

class Shr extends AbstractBinaryOpcode, TShr {
  override string toString() { result = "Shr" }
}

class Sar extends AbstractBinaryOpcode, TSar {
  override string toString() { result = "Sar" }
}

class Rol extends AbstractBinaryOpcode, TRol {
  override string toString() { result = "Rol" }
}

class Ror extends AbstractBinaryOpcode, TRor {
  override string toString() { result = "Ror" }
}

class Goto extends Opcode, TGoto {
  override string toString() { result = "Goto" }
}

class Const extends Opcode, TConst {
  override string toString() { result = "Const" }
}

class Call extends Opcode, TCall {
  override string toString() { result = "Call" }
}

class Copy extends Opcode, TCopy {
  override string toString() { result = "Copy" }
}

class Jump extends Opcode, TJump {
  override string toString() { result = "Jump" }
}

class CJump extends Opcode, TCJump {
  override string toString() { result = "CJump" }
}

class Ret extends Opcode, TRet {
  override string toString() { result = "Ret" }
}

class RetValue extends Opcode, TRetValue {
  override string toString() { result = "RetValue" }
}

class Nop extends Opcode, TNop {
  override string toString() { result = "Nop" }
}

class Not extends Opcode, TNot {
  override string toString() { result = "Not" }
}

class ExternalRef extends Opcode, TExternalRef {
  override string toString() { result = "ExternalRef" }
}

class Init extends Opcode, TInit {
  override string toString() { result = "Init" }
}

class FieldAddress extends Opcode, TFieldAddress {
  override string toString() { result = "FieldAddress" }
}

newtype ConditionKind =
  EQ() or
  NE() or
  LT() or
  LE() or
  GT() or
  GE()

string stringOfConditionKind(ConditionKind cond) {
  cond = EQ() and
  result = "EQ"
  or
  cond = NE() and
  result = "NE"
  or
  cond = LT() and
  result = "LT"
  or
  cond = LE() and
  result = "LE"
  or
  cond = GT() and
  result = "GT"
  or
  cond = GE() and
  result = "GE"
}
