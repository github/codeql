private import experimental.semmle.code.cpp.semantic.Semantic

newtype TSign =
  TNeg() or
  TZero() or
  TPos()

/** Class representing expression signs (+, -, 0). */
class Sign extends TSign {
  /** Gets the string representation of this sign. */
  string toString() {
    result = "-" and this = TNeg()
    or
    result = "0" and this = TZero()
    or
    result = "+" and this = TPos()
  }

  /** Gets a possible sign after incrementing an expression that has this sign. */
  Sign inc() {
    this = TNeg() and result = TNeg()
    or
    this = TNeg() and result = TZero()
    or
    this = TZero() and result = TPos()
    or
    this = TPos() and result = TPos()
  }

  /** Gets a possible sign after decrementing an expression that has this sign. */
  Sign dec() { result.inc() = this }

  /** Gets a possible sign after negating an expression that has this sign. */
  Sign neg() {
    this = TNeg() and result = TPos()
    or
    this = TZero() and result = TZero()
    or
    this = TPos() and result = TNeg()
  }

  /**
   * Gets a possible sign after bitwise complementing an expression that has this
   * sign.
   */
  Sign bitnot() {
    this = TNeg() and result = TPos()
    or
    this = TNeg() and result = TZero()
    or
    this = TZero() and result = TNeg()
    or
    this = TPos() and result = TNeg()
  }

  /**
   * Gets a possible sign after adding an expression with sign `s` to an expression
   * that has this sign.
   */
  Sign add(Sign s) {
    this = TZero() and result = s
    or
    s = TZero() and result = this
    or
    this = s and this = result
    or
    this = TPos() and s = TNeg()
    or
    this = TNeg() and s = TPos()
  }

  /**
   * Gets a possible sign after subtracting an expression with sign `s` from an expression
   * that has this sign.
   */
  Sign sub(Sign s) { result = add(s.neg()) }

  /**
   * Gets a possible sign after multiplying an expression with sign `s` to an expression
   * that has this sign.
   */
  Sign mul(Sign s) {
    result = TZero() and this = TZero()
    or
    result = TZero() and s = TZero()
    or
    result = TNeg() and this = TPos() and s = TNeg()
    or
    result = TNeg() and this = TNeg() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TPos()
    or
    result = TPos() and this = TNeg() and s = TNeg()
  }

  /**
   * Gets a possible sign after integer dividing an expression that has this sign
   * by an expression with sign `s`.
   */
  Sign div(Sign s) {
    result = TZero() and s = TNeg() // ex: 3 / -5 = 0
    or
    result = TZero() and s = TPos() // ex: 3 / 5 = 0
    or
    result = TNeg() and this = TPos() and s = TNeg()
    or
    result = TNeg() and this = TNeg() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TPos()
    or
    result = TPos() and this = TNeg() and s = TNeg()
  }

  /**
   * Gets a possible sign after modulo dividing an expression that has this sign
   * by an expression with sign `s`.
   */
  Sign rem(Sign s) {
    result = TZero() and s = TNeg()
    or
    result = TZero() and s = TPos()
    or
    result = this and s = TNeg()
    or
    result = this and s = TPos()
  }

  /**
   * Gets a possible sign after bitwise `and` of an expression that has this sign
   * and an expression with sign `s`.
   */
  Sign bitand(Sign s) {
    result = TZero() and this = TZero()
    or
    result = TZero() and s = TZero()
    or
    result = TZero() and this = TPos()
    or
    result = TZero() and s = TPos()
    or
    result = TNeg() and this = TNeg() and s = TNeg()
    or
    result = TPos() and this = TNeg() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TNeg()
    or
    result = TPos() and this = TPos() and s = TPos()
  }

  /**
   * Gets a possible sign after bitwise `or` of an expression that has this sign
   * and an expression with sign `s`.
   */
  Sign bitor(Sign s) {
    result = TZero() and this = TZero() and s = TZero()
    or
    result = TNeg() and this = TNeg()
    or
    result = TNeg() and s = TNeg()
    or
    result = TPos() and this = TPos() and s = TZero()
    or
    result = TPos() and this = TZero() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TPos()
  }

  /**
   * Gets a possible sign after bitwise `xor` of an expression that has this sign
   * and an expression with sign `s`.
   */
  Sign bitxor(Sign s) {
    result = TZero() and this = s
    or
    result = this and s = TZero()
    or
    result = s and this = TZero()
    or
    result = TPos() and this = TPos() and s = TPos()
    or
    result = TNeg() and this = TNeg() and s = TPos()
    or
    result = TNeg() and this = TPos() and s = TNeg()
    or
    result = TPos() and this = TNeg() and s = TNeg()
  }

  /**
   * Gets a possible sign after left shift of an expression that has this sign
   * by an expression with sign `s`.
   */
  Sign lshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    this != TZero() and s != TZero()
  }

  /**
   * Gets a possible sign after right shift of an expression that has this sign
   * by an expression with sign `s`.
   */
  Sign rshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    result = TNeg() and this = TNeg()
    or
    result != TNeg() and this = TPos() and s != TZero()
  }

  /**
   * Gets a possible sign after unsigned right shift of an expression that has
   * this sign by an expression with sign `s`.
   */
  Sign urshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    result != TZero() and this = TNeg() and s != TZero()
    or
    result != TNeg() and this = TPos() and s != TZero()
  }

  /** Perform `op` on this sign. */
  Sign applyUnaryOp(Opcode op) {
    op instanceof Opcode::CopyValue and result = this
    or
    op instanceof Opcode::Store and result = this
    or
    op instanceof Opcode::AddOne and result = inc()
    or
    op instanceof Opcode::SubOne and result = dec()
    or
    op instanceof Opcode::Negate and result = neg()
    or
    op instanceof Opcode::BitComplement and result = bitnot()
  }

  /** Perform `op` on this sign and sign `s`. */
  Sign applyBinaryOp(Sign s, Opcode op) {
    op instanceof Opcode::Add and result = add(s)
    or
    op instanceof Opcode::Sub and result = sub(s)
    or
    op instanceof Opcode::Mul and result = mul(s)
    or
    op instanceof Opcode::Div and result = div(s)
    or
    op instanceof Opcode::Rem and result = rem(s)
    or
    op instanceof Opcode::BitAnd and result = bitand(s)
    or
    op instanceof Opcode::BitOr and result = bitor(s)
    or
    op instanceof Opcode::BitXor and result = bitxor(s)
    or
    op instanceof Opcode::ShiftLeft and result = lshift(s)
    or
    op instanceof Opcode::ShiftRight and result = rshift(s)
    or
    op instanceof Opcode::ShiftRightUnsigned and result = urshift(s)
  }
}
