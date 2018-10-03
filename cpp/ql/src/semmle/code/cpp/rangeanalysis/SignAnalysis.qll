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
private import semmle.code.cpp.ir.ValueNumbering
private import SignAnalysisCached

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
  exists(float f | f = inst.(FloatConstantInstruction).getValue().toFloat() |
    f < 0 and result = TNeg() or
    f = 0 and result = TZero() or
    f > 0 and result = TPos()
  )
}

private newtype CastKind = TWiden() or TSame() or TNarrow()

private CastKind getCastKind(ConvertInstruction ci) {
  exists(int fromSize, int toSize |
    toSize = ci.getResultSize() and
    fromSize = ci.getOperand().getResultSize()
    |
    fromSize < toSize and
    result = TWiden()
    or
    fromSize = toSize and
    result = TSame()
    or
    fromSize > toSize and
    result = TNarrow()
  )
}

private predicate bindBool(boolean bool) {
  bool = true or
  bool = false
}

private Sign castSign(Sign s, boolean fromSigned, boolean toSigned, CastKind ck) {
  result = TZero() and
  (
    bindBool(fromSigned) and
    bindBool(toSigned) and
    s = TZero()
    or
    bindBool(fromSigned) and
    bindBool(toSigned) and
    ck = TNarrow()
  )
  or
  result = TPos() and
  (
    bindBool(fromSigned) and
    bindBool(toSigned) and
    s = TPos()
    or
    bindBool(fromSigned) and
    bindBool(toSigned) and
    s = TNeg() and
    ck = TNarrow()
    or
    fromSigned = true and
    toSigned = false and
    s = TNeg()
  )
  or
  result = TNeg() and
  (
    fromSigned = true and
    toSigned = true and
    s = TNeg()
    or
    fromSigned = false and
    toSigned = true and
    s = TPos() and
    ck != TWiden()
  )
}

/** Holds if the sign of `e` is too complicated to determine. */
private predicate unknownSign(Instruction i) {
  (
    i instanceof UnmodeledDefinitionInstruction
    or
    i instanceof UninitializedInstruction
    or
    i instanceof InitializeParameterInstruction
    or
    i instanceof BuiltInInstruction
    or
    i instanceof CallInstruction
  )
}

/**
 * Holds if `lowerbound` is a lower bound for `bounded` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate lowerBound(IRGuardCondition comp, Instruction lowerbound, Instruction bounded, Instruction pos, boolean isStrict) {
  exists(int adjustment, Instruction compared |
    valueNumber(bounded) = valueNumber(compared) and
    bounded = pos.getAnOperand() and
    not unknownSign(lowerbound) and
   (
     isStrict = true and
     adjustment = 0
     or
     isStrict = false and
     adjustment = 1
   ) and
   comp.ensuresLt(lowerbound, compared, adjustment, pos.getBlock(), true)
  )
}


/**
 * Holds if `upperbound` is an upper bound for `bounded` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate upperBound(IRGuardCondition comp, Instruction upperbound, Instruction bounded, Instruction pos, boolean isStrict) {
  exists(int adjustment, Instruction compared |
    valueNumber(bounded) = valueNumber(compared) and
    bounded = pos.getAnOperand() and
    not unknownSign(upperbound) and
   (
     isStrict = true and
     adjustment = 0
     or
     isStrict = false and
     adjustment = 1
   ) and
   comp.ensuresLt(compared, upperbound, adjustment, pos.getBlock(), true)
  )
}

/**
 * Holds if `eqbound` is an equality/inequality for `bounded` at `pos`. This is
 * restricted to only include bounds for which we might determine a sign. The
 * boolean `isEq` gives the polarity:
 *  - `isEq = true` : `bounded = eqbound`
 *  - `isEq = false` : `bounded != eqbound`
 */
private predicate eqBound(IRGuardCondition guard, Instruction eqbound, Instruction bounded, Instruction pos, boolean isEq) {
  exists(Instruction compared |
    not unknownSign(eqbound) and
    valueNumber(bounded) = valueNumber(compared) and
    bounded = pos.getAnOperand() and
    guard.ensuresEq(compared, eqbound, 0, pos.getBlock(), isEq)
  )
}



/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be positive in
 * order for `v` to be positive.
 */
private predicate posBound(IRGuardCondition comp, Instruction bound, Instruction v, Instruction pos) {
  upperBound(comp, bound, v, pos, _) or
  eqBound(comp, bound, v, pos, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be negative in
 * order for `v` to be negative.
 */
private predicate negBound(IRGuardCondition comp, Instruction bound, Instruction v, Instruction pos) {
  lowerBound(comp, bound, v, pos, _) or
  eqBound(comp, bound, v, pos, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that can restrict whether `v`
 * can be zero.
 */
private predicate zeroBound(IRGuardCondition comp, Instruction bound, Instruction v, Instruction pos) {
  lowerBound(comp, bound, v, pos, _) or
  upperBound(comp, bound, v, pos, _) or
  eqBound(comp, bound, v, pos, _)
}

/** Holds if `bound` allows `v` to be positive at `pos`. */
private predicate posBoundOk(IRGuardCondition comp, Instruction bound, Instruction v, Instruction pos) {
  posBound(comp, bound, v, pos) and TPos() = operandSign(comp, bound)
}

/** Holds if `bound` allows `v` to be negative at `pos`. */
private predicate negBoundOk(IRGuardCondition comp, Instruction bound, Instruction v, Instruction pos) {
  negBound(comp, bound, v, pos) and TNeg() = operandSign(comp, bound)
}

/** Holds if `bound` allows `v` to be zero at `pos`. */
private predicate zeroBoundOk(IRGuardCondition comp, Instruction bound, Instruction v, Instruction pos) {
  lowerBound(comp, bound, v, pos, _) and TNeg() = operandSign(comp, bound) or
  lowerBound(comp, bound, v, pos, false) and TZero() = operandSign(comp, bound) or
  upperBound(comp, bound, v, pos, _) and TPos() = operandSign(comp, bound) or
  upperBound(comp, bound, v, pos, false) and TZero() = operandSign(comp, bound) or
  eqBound(comp, bound, v, pos, true) and TZero() = operandSign(comp, bound) or
  eqBound(comp, bound, v, pos, false) and TZero() != operandSign(comp, bound)
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

private Sign unguardedOperandSign(Instruction pos, Instruction operand) {
  result = instructionSign(operand) and
  not hasGuard(operand, pos, result)
}

private Sign guardedOperandSign(Instruction pos, Instruction operand) {
  result = instructionSign(operand) and
  hasGuard(operand, pos, result)
}

private Sign guardedOperandSignOk(Instruction pos, Instruction operand) {
  result = TPos() and forex(IRGuardCondition guard, Instruction bound | posBound(guard, bound, operand, pos) | posBoundOk(guard, bound, operand, pos)) or
  result = TNeg() and forex(IRGuardCondition guard, Instruction bound | negBound(guard, bound, operand, pos) | negBoundOk(guard, bound, operand, pos)) or
  result = TZero() and forex(IRGuardCondition guard, Instruction bound | zeroBound(guard, bound, operand, pos) | zeroBoundOk(guard, bound, operand, pos))
}

/**
 * Holds if there is a bound that might restrict whether `v` has the sign `s`
 * at `pos`.
 */
private predicate hasGuard(Instruction v, Instruction pos, Sign s) {
    s = TPos() and posBound(_, _, v, pos)
    or
    s = TNeg() and negBound(_, _, v, pos)
    or
    s = TZero() and zeroBound(_, _, v, pos)
}

cached private module SignAnalysisCached { 
  /**
   * Gets a sign that `operand` may have at `pos`, taking guards into account.
   */
  cached
  Sign operandSign(Instruction pos, Instruction operand) {
    result = unguardedOperandSign(pos, operand)
    or
    result = guardedOperandSign(pos, operand) and
    result = guardedOperandSignOk(pos, operand)
  }
  
  cached
  Sign instructionSign(Instruction i) {
    result = certainInstructionSign(i)
    or
    not exists(certainInstructionSign(i)) and
    not (
      result = TNeg() and
      i.getResultType().(IntegralType).isUnsigned()
    ) and
    (
      unknownSign(i)
      or
      exists(ConvertInstruction ci, Instruction prior, boolean fromSigned, boolean toSigned |
        i = ci and
        prior = ci.getOperand() and
        (
          if ci.getResultType().(IntegralType).isSigned()
          then toSigned = true
          else toSigned = false
        ) and
        (
          if prior.getResultType().(IntegralType).isSigned()
          then fromSigned = true
          else fromSigned = false
        ) and
        result = castSign(operandSign(ci, prior), fromSigned, toSigned, getCastKind(ci))
      )
      or
      exists(Instruction prior |
        prior = i.(CopyInstruction).getSourceValue()
        |
        result = operandSign(i, prior)
      )
      or
      result = operandSign(i, i.(BitComplementInstruction).getOperand()).bitnot()
      or
      result = operandSign(i, i.(NegateInstruction).getOperand()).neg()
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
}

/** Holds if `i` can be positive and cannot be negative. */
predicate positive(Instruction i) {
  instructionSign(i) = TPos() and
  not instructionSign(i) = TNeg()
}

/** Holds if `i` at `pos` can be positive at and cannot be negative. */
predicate positive(Instruction i, Instruction pos) {
  operandSign(pos, i) = TPos() and
  not operandSign(pos, i) = TNeg()
}

/** Holds if `i` can be negative and cannot be positive. */
predicate negative(Instruction i) {
  instructionSign(i) = TNeg() and
  not instructionSign(i) = TPos()
}

/** Holds if `i` at `pos` can be negative and cannot be positive. */
predicate negative(Instruction i, Instruction pos) {
  operandSign(pos, i) = TNeg() and
  not operandSign(pos, i) = TPos()
}

/** Holds if `i` is strictly positive. */
predicate strictlyPositive(Instruction i) {
  instructionSign(i) = TPos() and
  not instructionSign(i) = TNeg() and
  not instructionSign(i) = TZero()
}

/** Holds if `i` is strictly positive at `pos`. */
predicate strictlyPositive(Instruction i, Instruction pos) {
  operandSign(pos, i) = TPos() and
  not operandSign(pos, i) = TNeg() and
  not operandSign(pos, i) = TZero()
}
/** Holds if `i` is strictly negative. */
predicate strictlyNegative(Instruction i) {
  instructionSign(i) = TNeg() and
  not instructionSign(i) = TPos() and
  not instructionSign(i) = TZero()
}

/** Holds if `i` is strictly negative at `pos`. */
predicate strictlyNegative(Instruction i, Instruction pos) {
  operandSign(pos, i) = TNeg() and
  not operandSign(pos, i) = TPos() and
  not operandSign(pos, i) = TZero()
}
