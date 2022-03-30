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

private newtype TSign =
  TNeg() or
  TZero() or
  TPos()

private class Sign extends TSign {
  string toString() {
    result = "-" and this = TNeg()
    or
    result = "0" and this = TZero()
    or
    result = "+" and this = TPos()
  }

  Sign inc() {
    this = TNeg() and result = TNeg()
    or
    this = TNeg() and result = TZero()
    or
    this = TZero() and result = TPos()
    or
    this = TPos() and result = TPos()
  }

  Sign dec() { result.inc() = this }

  Sign neg() {
    this = TNeg() and result = TPos()
    or
    this = TZero() and result = TZero()
    or
    this = TPos() and result = TNeg()
  }

  Sign bitnot() {
    this = TNeg() and result = TPos()
    or
    this = TNeg() and result = TZero()
    or
    this = TZero() and result = TNeg()
    or
    this = TPos() and result = TNeg()
  }

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

  Sign div(Sign s) {
    result = TZero() and s = TNeg()
    or
    result = TZero() and s = TPos()
    or
    result = TNeg() and this = TPos() and s = TNeg()
    or
    result = TNeg() and this = TNeg() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TPos()
    or
    result = TPos() and this = TNeg() and s = TNeg()
  }

  Sign rem(Sign s) {
    result = TZero() and s = TNeg()
    or
    result = TZero() and s = TPos()
    or
    result = this and s = TNeg()
    or
    result = this and s = TPos()
  }

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

  Sign lshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    this != TZero() and s != TZero()
  }

  Sign rshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    result = TNeg() and this = TNeg()
    or
    result != TNeg() and this = TPos() and s != TZero()
  }

  Sign urshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    result != TZero() and this = TNeg() and s != TZero()
    or
    result != TNeg() and this = TPos() and s != TZero()
  }
}

private Sign certainInstructionSign(Instruction inst) {
  exists(int i | inst.(IntegerConstantInstruction).getValue().toInt() = i |
    i < 0 and result = TNeg()
    or
    i = 0 and result = TZero()
    or
    i > 0 and result = TPos()
  )
  or
  exists(float f | f = inst.(FloatConstantInstruction).getValue().toFloat() |
    f < 0 and result = TNeg()
    or
    f = 0 and result = TZero()
    or
    f > 0 and result = TPos()
  )
}

private newtype CastKind =
  TWiden() or
  TSame() or
  TNarrow()

private CastKind getCastKind(ConvertInstruction ci) {
  exists(int fromSize, int toSize |
    toSize = ci.getResultSize() and
    fromSize = ci.getUnary().getResultSize()
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
  // REVIEW: This should probably be a list of the instructions that we _do_ understand, rather than
  // the ones we don't understand. Currently, if we try to compute the sign of an instruction that
  // we don't understand, and it isn't on this list, we incorrectly compute the sign as "none"
  // instead of "+,0,-".
  // Even better, we could track the state of each instruction as a power set of {non-negative,
  // non-positive, non-zero}, which would mean that the representation of the sign of an unknown
  // value would be the empty set.
  (
    i instanceof UninitializedInstruction
    or
    i instanceof InitializeParameterInstruction
    or
    i instanceof BuiltInOperationInstruction
    or
    i instanceof CallInstruction
    or
    i instanceof ChiInstruction
  )
}

/**
 * Holds if `lowerbound` is a lower bound for `bounded`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate lowerBound(
  IRGuardCondition comp, Operand lowerbound, Operand bounded, boolean isStrict
) {
  exists(int adjustment, Operand compared |
    valueNumberOfOperand(bounded) = valueNumberOfOperand(compared) and
    (
      isStrict = true and
      adjustment = 0
      or
      isStrict = false and
      adjustment = 1
    ) and
    comp.ensuresLt(lowerbound, compared, adjustment, bounded.getUse().getBlock(), true)
  )
}

/**
 * Holds if `upperbound` is an upper bound for `bounded` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate upperBound(
  IRGuardCondition comp, Operand upperbound, Operand bounded, boolean isStrict
) {
  exists(int adjustment, Operand compared |
    valueNumberOfOperand(bounded) = valueNumberOfOperand(compared) and
    (
      isStrict = true and
      adjustment = 0
      or
      isStrict = false and
      adjustment = 1
    ) and
    comp.ensuresLt(compared, upperbound, adjustment, bounded.getUse().getBlock(), true)
  )
}

/**
 * Holds if `eqbound` is an equality/inequality for `bounded` at `pos`. This is
 * restricted to only include bounds for which we might determine a sign. The
 * boolean `isEq` gives the polarity:
 *  - `isEq = true` : `bounded = eqbound`
 *  - `isEq = false` : `bounded != eqbound`
 */
private predicate eqBound(IRGuardCondition guard, Operand eqbound, Operand bounded, boolean isEq) {
  exists(Operand compared |
    valueNumberOfOperand(bounded) = valueNumberOfOperand(compared) and
    guard.ensuresEq(compared, eqbound, 0, bounded.getUse().getBlock(), isEq)
  )
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be positive in
 * order for `v` to be positive.
 */
private predicate posBound(IRGuardCondition comp, Operand bound, Operand op) {
  upperBound(comp, bound, op, _) or
  eqBound(comp, bound, op, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be negative in
 * order for `v` to be negative.
 */
private predicate negBound(IRGuardCondition comp, Operand bound, Operand op) {
  lowerBound(comp, bound, op, _) or
  eqBound(comp, bound, op, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that can restrict whether `v`
 * can be zero.
 */
private predicate zeroBound(IRGuardCondition comp, Operand bound, Operand op) {
  lowerBound(comp, bound, op, _) or
  upperBound(comp, bound, op, _) or
  eqBound(comp, bound, op, _)
}

/** Holds if `bound` allows `v` to be positive at `pos`. */
private predicate posBoundOk(IRGuardCondition comp, Operand bound, Operand op) {
  posBound(comp, bound, op) and TPos() = operandSign(bound)
}

/** Holds if `bound` allows `v` to be negative at `pos`. */
private predicate negBoundOk(IRGuardCondition comp, Operand bound, Operand op) {
  negBound(comp, bound, op) and TNeg() = operandSign(bound)
}

/** Holds if `bound` allows `v` to be zero at `pos`. */
private predicate zeroBoundOk(IRGuardCondition comp, Operand bound, Operand op) {
  lowerBound(comp, bound, op, _) and TNeg() = operandSign(bound)
  or
  lowerBound(comp, bound, op, false) and TZero() = operandSign(bound)
  or
  upperBound(comp, bound, op, _) and TPos() = operandSign(bound)
  or
  upperBound(comp, bound, op, false) and TZero() = operandSign(bound)
  or
  eqBound(comp, bound, op, true) and TZero() = operandSign(bound)
  or
  eqBound(comp, bound, op, false) and TZero() != operandSign(bound)
}

private Sign binaryOpLhsSign(BinaryInstruction i) { result = operandSign(i.getLeftOperand()) }

private Sign binaryOpRhsSign(BinaryInstruction i) { result = operandSign(i.getRightOperand()) }

pragma[noinline]
private predicate binaryOpSigns(BinaryInstruction i, Sign lhs, Sign rhs) {
  lhs = binaryOpLhsSign(i) and
  rhs = binaryOpRhsSign(i)
}

private Sign unguardedOperandSign(Operand operand) {
  result = instructionSign(operand.getDef()) and
  not hasGuard(operand, result)
}

private Sign guardedOperandSign(Operand operand) {
  result = instructionSign(operand.getDef()) and
  hasGuard(operand, result)
}

private Sign guardedOperandSignOk(Operand operand) {
  result = TPos() and
  forex(IRGuardCondition guard, Operand bound | posBound(guard, bound, operand) |
    posBoundOk(guard, bound, operand)
  )
  or
  result = TNeg() and
  forex(IRGuardCondition guard, Operand bound | negBound(guard, bound, operand) |
    negBoundOk(guard, bound, operand)
  )
  or
  result = TZero() and
  forex(IRGuardCondition guard, Operand bound | zeroBound(guard, bound, operand) |
    zeroBoundOk(guard, bound, operand)
  )
}

/**
 * Holds if there is a bound that might restrict whether `v` has the sign `s`
 * at `pos`.
 */
private predicate hasGuard(Operand op, Sign s) {
  s = TPos() and posBound(_, _, op)
  or
  s = TNeg() and negBound(_, _, op)
  or
  s = TZero() and zeroBound(_, _, op)
}

cached
module SignAnalysisCached {
  /**
   * Gets a sign that `operand` may have at `pos`, taking guards into account.
   */
  cached
  Sign operandSign(Operand operand) {
    result = unguardedOperandSign(operand)
    or
    result = guardedOperandSign(operand) and
    result = guardedOperandSignOk(operand)
    or
    // `result` is unconstrained if the definition is inexact. Then any sign is possible.
    operand.isDefinitionInexact()
  }

  cached
  Sign instructionSign(Instruction i) {
    result = certainInstructionSign(i)
    or
    not exists(certainInstructionSign(i)) and
    not (
      result = TNeg() and
      i.getResultIRType().(IRIntegerType).isUnsigned()
    ) and
    (
      unknownSign(i)
      or
      exists(ConvertInstruction ci, Instruction prior, boolean fromSigned, boolean toSigned |
        i = ci and
        prior = ci.getUnary() and
        (
          if ci.getResultIRType().(IRIntegerType).isSigned()
          then toSigned = true
          else toSigned = false
        ) and
        (
          if prior.getResultIRType().(IRIntegerType).isSigned()
          then fromSigned = true
          else fromSigned = false
        ) and
        result = castSign(operandSign(ci.getAnOperand()), fromSigned, toSigned, getCastKind(ci))
      )
      or
      result = operandSign(i.(CopyInstruction).getSourceValueOperand())
      or
      result = operandSign(i.(BitComplementInstruction).getAnOperand()).bitnot()
      or
      result = operandSign(i.(NegateInstruction).getAnOperand()).neg()
      or
      exists(Sign s1, Sign s2 | binaryOpSigns(i, s1, s2) |
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
        i.getResultIRType().(IRIntegerType).isSigned() and
        result = s1.rshift(s2)
        or
        i instanceof ShiftRightInstruction and
        not i.getResultIRType().(IRIntegerType).isSigned() and
        result = s1.urshift(s2)
      )
      or
      // use hasGuard here?
      result = operandSign(i.(PhiInstruction).getAnOperand())
    )
  }
}

/** Holds if `i` can be positive and cannot be negative. */
predicate positiveInstruction(Instruction i) {
  instructionSign(i) = TPos() and
  not instructionSign(i) = TNeg()
}

/** Holds if `i` at `pos` can be positive at and cannot be negative. */
predicate positive(Operand op) {
  operandSign(op) = TPos() and
  not operandSign(op) = TNeg()
}

/** Holds if `i` can be negative and cannot be positive. */
predicate negativeInstruction(Instruction i) {
  instructionSign(i) = TNeg() and
  not instructionSign(i) = TPos()
}

/** Holds if `i` at `pos` can be negative and cannot be positive. */
predicate negative(Operand op) {
  operandSign(op) = TNeg() and
  not operandSign(op) = TPos()
}

/** Holds if `i` is strictly positive. */
predicate strictlyPositiveInstruction(Instruction i) {
  instructionSign(i) = TPos() and
  not instructionSign(i) = TNeg() and
  not instructionSign(i) = TZero()
}

/** Holds if `i` is strictly positive at `pos`. */
predicate strictlyPositive(Operand op) {
  operandSign(op) = TPos() and
  not operandSign(op) = TNeg() and
  not operandSign(op) = TZero()
}

/** Holds if `i` is strictly negative. */
predicate strictlyNegativeInstruction(Instruction i) {
  instructionSign(i) = TNeg() and
  not instructionSign(i) = TPos() and
  not instructionSign(i) = TZero()
}

/** Holds if `i` is strictly negative at `pos`. */
predicate strictlyNegative(Operand op) {
  operandSign(op) = TNeg() and
  not operandSign(op) = TPos() and
  not operandSign(op) = TZero()
}
