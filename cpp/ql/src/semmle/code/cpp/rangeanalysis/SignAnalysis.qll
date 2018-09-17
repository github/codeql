/**
 * Provides sign analysis to determine whether expression are always positive
 * or negative.
 *
 * The analysis is implemented as an abstract interpretation over the
 * three-valued domain `{negative, zero, positive}`.
 */
import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.controlflow.IRGuards

private newtype TSign = TNeg() or TZero() or TPos()
private class Sign extends TSign {
  string toString() {
    result = "-" and this = TNeg() or
    result = "0" and this = TZero() or
    result = "+" and this = TPos()
  }
  Sign inc() {
    this = TNeg() and result = TNeg() or
    this = TNeg() and result = TZero() or
    this = TZero() and result = TPos() or
    this = TPos() and result = TPos()
  }
  Sign dec() {
    result.inc() = this
  }
  Sign neg() {
    this = TNeg() and result = TPos() or
    this = TZero() and result = TZero() or
    this = TPos() and result = TNeg()
  }
  Sign bitnot() {
    this = TNeg() and result = TPos() or
    this = TNeg() and result = TZero() or
    this = TZero() and result = TNeg() or
    this = TPos() and result = TNeg()
  }
  Sign add(Sign s) {
    this = TZero() and result = s or
    s = TZero() and result = this or
    this = s and this = result or
    this = TPos() and s = TNeg() or
    this = TNeg() and s = TPos()
  }
  Sign mul(Sign s) {
    result = TZero() and this = TZero() or
    result = TZero() and s = TZero() or
    result = TNeg() and this = TPos() and s = TNeg() or
    result = TNeg() and this = TNeg() and s = TPos() or
    result = TPos() and this = TPos() and s = TPos() or
    result = TPos() and this = TNeg() and s = TNeg()
  }
  Sign div(Sign s) {
    result = TZero() and s = TNeg() or
    result = TZero() and s = TPos() or
    result = TNeg() and this = TPos() and s = TNeg() or
    result = TNeg() and this = TNeg() and s = TPos() or
    result = TPos() and this = TPos() and s = TPos() or
    result = TPos() and this = TNeg() and s = TNeg()
  }
  Sign rem(Sign s) {
    result = TZero() and s = TNeg() or
    result = TZero() and s = TPos() or
    result = this and s = TNeg() or
    result = this and s = TPos()
  }
  Sign bitand(Sign s) {
    result = TZero() and this = TZero() or
    result = TZero() and s = TZero() or
    result = TZero() and this = TPos() or
    result = TZero() and s = TPos() or
    result = TNeg() and this = TNeg() and s = TNeg() or
    result = TPos() and this = TNeg() and s = TPos() or
    result = TPos() and this = TPos() and s = TNeg() or
    result = TPos() and this = TPos() and s = TPos()
  }
  Sign bitor(Sign s) {
    result = TZero() and this = TZero() and s = TZero() or
    result = TNeg() and this = TNeg() or
    result = TNeg() and s = TNeg() or
    result = TPos() and this = TPos() and s = TZero() or
    result = TPos() and this = TZero() and s = TPos() or
    result = TPos() and this = TPos() and s = TPos()
  }
  Sign bitxor(Sign s) {
    result = TZero() and this = s or
    result = this and s = TZero() or
    result = s and this = TZero() or
    result = TPos() and this = TPos() and s = TPos() or
    result = TNeg() and this = TNeg() and s = TPos() or
    result = TNeg() and this = TPos() and s = TNeg() or
    result = TPos() and this = TNeg() and s = TNeg()
  }
  Sign lshift(Sign s) {
    result = TZero() and this = TZero() or
    result = this and s = TZero() or
    this != TZero() and s != TZero()
  }
  Sign rshift(Sign s) {
    result = TZero() and this = TZero() or
    result = this and s = TZero() or
    result = TNeg() and this = TNeg() or
    result != TNeg() and this = TPos() and s != TZero()
  }
  Sign urshift(Sign s) {
    result = TZero() and this = TZero() or
    result = this and s = TZero() or
    result != TZero() and this = TNeg() and s != TZero() or
    result != TNeg() and this = TPos() and s != TZero()
  }
}

private Sign certainInstructionSign(Instruction inst) {
  exists(int i | inst.(IntegerConstantInstruction).getValue().toInt() = i |
    i < 0 and result = TNeg() or
    i = 0 and result = TZero() or
    i > 0 and result = TPos()
  )
  or
  not inst instanceof IntegerConstantInstruction and
  exists(float f | f = inst.(FloatConstantInstruction).getValue().toFloat() |
    f < 0 and result = TNeg() or
    f = 0 and result = TZero() or
    f > 0 and result = TPos()
  )
}


/** Holds if the sign of `e` is too complicated to determine. */
private predicate unknownSign(Instruction i) {
  (
    i instanceof UnmodeledDefinitionInstruction or
    i instanceof UninitializedInstruction or
    i instanceof InitializeParameterInstruction or
    i instanceof BuiltInInstruction or
    i instanceof CallInstruction
  )
}

/**
 * Holds if `lowerbound` is a lower bound for `compared` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate lowerBound(Instruction lowerbound, Instruction compared, Instruction pos, boolean isStrict) {
  exists(int adjustment, IRGuardCondition comp |
    pos.getAnOperand() = compared and
  /*
   *  Java library uses guardControlsSsaRead here. I think that the phi node logic doesn't need to
   * be duplicated but the implication predicates may need to be ported
   */
   (
     isStrict = true and
     adjustment = 0
     or
     isStrict = false and
     adjustment = 1
   ) and
   comp.ensuresLt(lowerbound, compared, 0, pos.getBlock(), true)
  )
}


/**
 * Holds if `upperbound` is an upper bound for `compared` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate upperBound(Instruction upperbound, Instruction compared, Instruction pos, boolean isStrict) {
  exists(int adjustment, IRGuardCondition comp |
    pos.getAnOperand() = compared and
  /*
   * Java library uses guardControlsSsaRead here. I think that the phi node logic doesn't need to
   * be duplicated but the implication predicates may need to be ported
   */
   (
     isStrict = true and
     adjustment = 0
     or
     isStrict = false and
     adjustment = 1
   ) and
   comp.ensuresLt(compared, upperbound, 0, pos.getBlock(), true)
  )
}

/**
 * Holds if `eqbound` is an equality/inequality for `v` at `pos`. This is
 * restricted to only include bounds for which we might determine a sign. The
 * boolean `isEq` gives the polarity:
 *  - `isEq = true` : `v = eqbound`
 *  - `isEq = false` : `v != eqbound`
 */
private predicate eqBound(Instruction eqbound, Instruction compared, Instruction pos, boolean isEq) {
  exists(IRGuardCondition guard |
    pos.getAnOperand() = compared and
    guard.ensuresEq(compared, eqbound, 0, pos.getBlock(), isEq)
  )
}



/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be positive in
 * order for `v` to be positive.
 */
private predicate posBound(Instruction bound, Instruction v, Instruction pos) {
  upperBound(bound, v, pos, _) or
  eqBound(bound, v, pos, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be negative in
 * order for `v` to be negative.
 */
private predicate negBound(Instruction bound, Instruction v, Instruction pos) {
  lowerBound(bound, v, pos, _) or
  eqBound(bound, v, pos, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that can restrict whether `v`
 * can be zero.
 */
private predicate zeroBound(Instruction bound, Instruction v, Instruction pos) {
  lowerBound(bound, v, pos, _) or
  upperBound(bound, v, pos, _) or
  eqBound(bound, v, pos, _)
}

/** Holds if `bound` allows `v` to be positive at `pos`. */
private predicate posBoundOk(Instruction bound, Instruction v, Instruction pos) {
  posBound(bound, v, pos) and TPos() = instructionSign(bound)
}

/** Holds if `bound` allows `v` to be negative at `pos`. */
private predicate negBoundOk(Instruction bound, Instruction v, Instruction pos) {
  negBound(bound, v, pos) and TNeg() = instructionSign(bound)
}

/** Holds if `bound` allows `v` to be zero at `pos`. */
private predicate zeroBoundOk(Instruction bound, Instruction v, Instruction pos) {
  lowerBound(bound, v, pos, _) and TNeg() = instructionSign(bound) or
  lowerBound(bound, v, pos, false) and TZero() = instructionSign(bound) or
  upperBound(bound, v, pos, _) and TPos() = instructionSign(bound) or
  upperBound(bound, v, pos, false) and TZero() = instructionSign(bound) or
  eqBound(bound, v, pos, true) and TZero() = instructionSign(bound) or
  eqBound(bound, v, pos, false) and TZero() != instructionSign(bound)
}

private Sign binaryOpLhsSign(Instruction i) {
  result = operandSign(i, i.(BinaryInstruction).getLeftOperand())
}

private Sign binaryOpRhsSign(Instruction i) {
  result = operandSign(i, i.(BinaryInstruction).getRightOperand())
}
pragma[noinline]
private predicate binaryOpSigns(Instruction i, Sign lhs, Sign rhs) {
  lhs = binaryOpLhsSign(i) and
  rhs = binaryOpRhsSign(i)
}

/**
 * Holds if there is a bound that might restrict whether `v` has the sign `s`
 * at `pos`.
 */
private predicate hasGuard(Instruction v, Instruction pos, Sign s) {
  s = TPos() and posBound(_, v, pos) or
  s = TNeg() and negBound(_, v, pos) or
  s = TZero() and zeroBound(_, v, pos)
}

cached
private Sign operandSign(Instruction pos, Instruction operand) {
  hasGuard(operand, pos, result)
  or
  not hasGuard(operand, pos, _) and
  result = instructionSign(operand)
}

cached
private Sign instructionSign(Instruction i) {
  result = certainInstructionSign(i)
  or
  not exists(certainInstructionSign(i)) and
  (
    unknownSign(i)
    or
    exists(Instruction prior |
      prior = i.(CopyInstruction).getSourceValue()
      |
      hasGuard(prior, i, result)
      or
      not exists(Sign s | hasGuard(prior, i, s)) and
      result = instructionSign(prior)
    )
    or
    result = instructionSign(i.(BitComplementInstruction).getOperand()).bitnot()
    or
    result = instructionSign(i.(AddInstruction))
    or
    exists(Sign s1, Sign s2 |
      binaryOpSigns(i, s1, s2)
      |
      i instanceof AddInstruction and result = s1.add(s2)
      or
      i instanceof SubInstruction and result = s1.add(s2.neg())
      or
      i instanceof MulInstruction and result = s1.mul(s2)
      or
      i instanceof DivInstruction and result = s1.div(s2)
      or
      i instanceof RemInstruction and result = s1.rem(s2)
      or
      i instanceof BitAndInstruction and result = s1.bitand(s2)
      or
      i instanceof BitOrInstruction and result = s1.bitor(s2)
      or
      i instanceof BitXorInstruction and result = s1.bitxor(s2)
      or
      i instanceof ShiftLeftInstruction and result = s1.lshift(s2)
      or
      i instanceof ShiftRightInstruction and
      i.getResultType().(IntegralType).isSigned() and
      result = s1.rshift(s2)
      or
      i instanceof ShiftRightInstruction and
      not i.getResultType().(IntegralType).isSigned() and
      result = s1.urshift(s2)
    )
    or
    // use hasGuard here?
    result = operandSign(i, i.(PhiInstruction).getAnOperand())
  )
}

/** Holds if `e` can be positive and cannot be negative. */
predicate positive(Instruction i) {
  instructionSign(i) = TPos() and
  not instructionSign(i) = TNeg()
}

/** Holds if `e` can be negative and cannot be positive. */
predicate negative(Instruction i) {
  instructionSign(i) = TNeg() and
  not instructionSign(i) = TPos()
}

/** Holds if `e` is strictly positive. */
predicate strictlyPositive(Instruction i) {
  instructionSign(i) = TPos() and
  not instructionSign(i) = TNeg() and
  not instructionSign(i) = TZero()
}

/** Holds if `e` is strictly negative. */
predicate strictlyNegative(Instruction i) {
  instructionSign(i) = TNeg() and
  not instructionSign(i) = TPos() and
  not instructionSign(i) = TZero()
}
