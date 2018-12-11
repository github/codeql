import cpp
private import semmle.code.cpp.ir.IR

private newtype TBound =
  TBoundZero() or
  TBoundInstruction(Instruction i) {
    i.getResultType() instanceof IntegralType or
    i.getResultType() instanceof PointerType
  } or
  TBoundOperand(Operand o) {
    o.getDefinitionInstruction().getResultType() instanceof IntegralType or
    o.getDefinitionInstruction().getResultType() instanceof PointerType
  }

/**
 * A bound that may be inferred for an expression plus/minus an integer delta.
 */
abstract class Bound extends TBound {
  abstract string toString();

  /** Gets an expression that equals this bound plus `delta`. */
  abstract Instruction getInstruction(int delta);

  /** Gets an expression that equals this bound. */
  Instruction getInstruction() { result = getInstruction(0) }

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
}


/**
 * The bound that corresponds to the integer 0. This is used to represent all
 * integer bounds as bounds are always accompanied by an added integer delta.
 */
class ZeroBound extends Bound, TBoundZero {
  override string toString() { result = "0" }

  override Instruction getInstruction(int delta) { result.(ConstantValueInstruction).getValue().toInt() = delta }
}

/**
 * A bound corresponding to the value of an `Instruction`.
 */
class InstructionBound extends Bound, TBoundInstruction {
  /** Gets the SSA variable that equals this bound. */
  override Instruction getInstruction(int delta) { this = TBoundInstruction(result) and delta = 0}

  override string toString() { result = getInstruction().toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    getInstruction().getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
}

/**
 * A bound corresponding to the value of an `Operand`.
 */
class OperandBound extends Bound, TBoundOperand {
  Operand getOperand() {
    this = TBoundOperand(result)
  }

  override Instruction getInstruction(int delta) {
    this = TBoundOperand(result.getAUse()) and
    delta = 0
  } 

  override string toString() { result = getOperand().toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    getOperand().getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
}
