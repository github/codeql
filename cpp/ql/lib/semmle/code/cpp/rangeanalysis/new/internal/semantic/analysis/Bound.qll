import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.ValueNumbering

private newtype TBound =
  TBoundZero() or
  TBoundValueNumber(ValueNumber vn) {
    exists(Instruction i |
      vn.getAnInstruction() = i and
      (
        i.getResultIRType() instanceof IRIntegerType or
        i.getResultIRType() instanceof IRAddressType
      ) and
      not vn.getAnInstruction() instanceof ConstantInstruction
    |
      i instanceof PhiInstruction
      or
      i instanceof InitializeParameterInstruction
      or
      i instanceof CallInstruction
      or
      i instanceof VariableAddressInstruction
      or
      i instanceof FieldAddressInstruction
      or
      i.(LoadInstruction).getSourceAddress() instanceof VariableAddressInstruction
      or
      i.(LoadInstruction).getSourceAddress() instanceof FieldAddressInstruction
      or
      i.getAUse() instanceof ArgumentOperand
      or
      i instanceof PointerArithmeticInstruction
      or
      i.getAUse() instanceof AddressOperand
    )
  }

/**
 * A bound that may be inferred for an expression plus/minus an integer delta.
 */
abstract class Bound extends TBound {
  abstract string toString();

  /** Gets an expression that equals this bound plus `delta`. */
  abstract Instruction getInstruction(int delta);

  /** Gets an expression that equals this bound. */
  Instruction getInstruction() { result = this.getInstruction(0) }

  abstract Location getLocation();
}

/**
 * The bound that corresponds to the integer 0. This is used to represent all
 * integer bounds as bounds are always accompanied by an added integer delta.
 */
class ZeroBound extends Bound, TBoundZero {
  override string toString() { result = "0" }

  override Instruction getInstruction(int delta) {
    result.(ConstantValueInstruction).getValue().toInt() = delta
  }

  override Location getLocation() { result instanceof UnknownDefaultLocation }
}

/**
 * A bound corresponding to the value of an `Instruction`.
 */
class ValueNumberBound extends Bound, TBoundValueNumber {
  ValueNumber vn;

  ValueNumberBound() { this = TBoundValueNumber(vn) }

  /** Gets an `Instruction` that equals this bound. */
  override Instruction getInstruction(int delta) {
    this = TBoundValueNumber(valueNumber(result)) and delta = 0
  }

  override string toString() { result = "ValueNumberBound" }

  override Location getLocation() { result = vn.getLocation() }

  /** Gets the value number that equals this bound. */
  ValueNumber getValueNumber() { result = vn }
}
