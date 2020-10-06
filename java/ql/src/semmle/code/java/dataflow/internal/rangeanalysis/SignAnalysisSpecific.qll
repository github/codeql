/**
 * Provides Java-specific definitions for use in sign analysis.
 */
module Private {
  import semmle.code.java.dataflow.RangeUtils as RU
  private import semmle.code.java.dataflow.SSA as Ssa
  private import semmle.code.java.controlflow.Guards as G
  private import java as J
  import Impl

  class ConstantIntegerExpr = RU::ConstantIntegerExpr;

  class Guard = G::Guard;

  class SsaVariable = Ssa::SsaVariable;

  class SsaPhiNode = Ssa::SsaPhiNode;

  class VarAccess = J::VarAccess;

  class FieldAccess = J::FieldAccess;

  class CharacterLiteral = J::CharacterLiteral;

  class IntegerLiteral = J::IntegerLiteral;

  class LongLiteral = J::LongLiteral;

  class CastExpr = J::CastExpr;

  class Type = J::Type;

  class Expr = J::Expr;

  class ComparisonExpr = J::ComparisonExpr;

  class NumericOrCharType = J::NumericOrCharType;

  predicate ssaRead = RU::ssaRead/2;

  predicate guardControlsSsaRead = RU::guardControlsSsaRead/3;
}

private module Impl {
  private import java
  private import semmle.code.java.dataflow.RangeUtils
  private import semmle.code.java.dataflow.SSA
  private import semmle.code.java.controlflow.Guards
  private import semmle.code.java.Reflection
  private import semmle.code.java.Collections
  private import semmle.code.java.Maps
  private import Sign
  private import SignAnalysisCommon
  private import SsaReadPositionCommon

  class UnsignedNumericType = CharacterType;

  float getNonIntegerValue(Expr e) {
    result = e.(LongLiteral).getValue().toFloat() or
    result = e.(FloatingPointLiteral).getValue().toFloat() or
    result = e.(DoubleLiteral).getValue().toFloat()
  }

  string getCharValue(Expr e) { result = e.(CharacterLiteral).getValue() }

  predicate containerSizeAccess(Expr e) {
    e.(MethodAccess).getMethod() instanceof StringLengthMethod
    or
    e.(MethodAccess).getMethod() instanceof CollectionSizeMethod
    or
    e.(MethodAccess).getMethod() instanceof MapSizeMethod
  }

  predicate positiveExpression(Expr e) { none() }

  predicate unknownIntegerAccess(Expr e) {
    e instanceof ArrayAccess and e.getType() instanceof NumericOrCharType
    or
    e instanceof MethodAccess and e.getType() instanceof NumericOrCharType
    or
    e instanceof ClassInstanceExpr and e.getType() instanceof NumericOrCharType
  }

  Sign explicitSsaDefSign(SsaVariable v) {
    exists(VariableUpdate def | def = v.(SsaExplicitUpdate).getDefiningExpr() |
      result = exprSign(def.(VariableAssign).getSource())
      or
      exists(EnhancedForStmt for | def = for.getVariable())
      or
      result = exprSign(def.(PostIncExpr).getExpr()).inc()
      or
      result = exprSign(def.(PreIncExpr).getExpr()).inc()
      or
      result = exprSign(def.(PostDecExpr).getExpr()).dec()
      or
      result = exprSign(def.(PreDecExpr).getExpr()).dec()
      or
      exists(AssignOp a | a = def and result = exprSign(a))
    )
  }

  Sign implicitSsaDefSign(SsaVariable v) {
    result = fieldSign(v.(SsaImplicitUpdate).getSourceVariable().getVariable())
    or
    result = fieldSign(v.(SsaImplicitInit).getSourceVariable().getVariable())
    or
    exists(Parameter p | v.(SsaImplicitInit).isParameterDefinition(p))
  }

  pragma[inline]
  Sign ssaVariableSign(SsaVariable v, Expr e) {
    result = ssaSign(v, any(SsaReadPositionBlock bb | getAnExpression(bb) = e))
    or
    not exists(SsaReadPositionBlock bb | getAnExpression(bb) = e) and
    result = ssaDefSign(v)
  }

  /** Gets a possible sign for `f`. */
  Sign fieldSign(Field f) {
    result = exprSign(f.getAnAssignedValue())
    or
    exists(PostIncExpr inc | inc.getExpr() = f.getAnAccess() and result = fieldSign(f).inc())
    or
    exists(PreIncExpr inc | inc.getExpr() = f.getAnAccess() and result = fieldSign(f).inc())
    or
    exists(PostDecExpr inc | inc.getExpr() = f.getAnAccess() and result = fieldSign(f).dec())
    or
    exists(PreDecExpr inc | inc.getExpr() = f.getAnAccess() and result = fieldSign(f).dec())
    or
    exists(AssignOp a | a.getDest() = f.getAnAccess() | result = exprSign(a))
    or
    exists(ReflectiveFieldAccess rfa | rfa.inferAccessedField() = f)
    or
    if f.fromSource()
    then not exists(f.getInitializer()) and result = TZero()
    else
      if f instanceof ArrayLengthField
      then result != TNeg()
      else
        if f.hasName("MAX_VALUE")
        then result = TPos()
        else
          if f.hasName("MIN_VALUE")
          then result = TNeg()
          else any()
  }

  Sign specificSubExprSign(Expr e) {
    result = exprSign(e.(AssignExpr).getSource())
    or
    result = exprSign(e.(PlusExpr).getExpr())
    or
    result = exprSign(e.(PostIncExpr).getExpr())
    or
    result = exprSign(e.(PostDecExpr).getExpr())
    or
    result = exprSign(e.(PreIncExpr).getExpr()).inc()
    or
    result = exprSign(e.(PreDecExpr).getExpr()).dec()
    or
    result = exprSign(e.(MinusExpr).getExpr()).neg()
    or
    result = exprSign(e.(BitNotExpr).getExpr()).bitnot()
    or
    exists(DivExpr div |
      div = e and
      result = exprSign(div.getLeftOperand()) and
      result != TZero()
    |
      div.getRightOperand().(FloatingPointLiteral).getValue().toFloat() = 0 or
      div.getRightOperand().(DoubleLiteral).getValue().toFloat() = 0
    )
    or
    exists(Sign s1, Sign s2 | binaryOpSigns(e, s1, s2) |
      (e instanceof AssignAddExpr or e instanceof AddExpr) and
      result = s1.add(s2)
      or
      (e instanceof AssignSubExpr or e instanceof SubExpr) and
      result = s1.add(s2.neg())
      or
      (e instanceof AssignMulExpr or e instanceof MulExpr) and
      result = s1.mul(s2)
      or
      (e instanceof AssignDivExpr or e instanceof DivExpr) and
      result = s1.div(s2)
      or
      (e instanceof AssignRemExpr or e instanceof RemExpr) and
      result = s1.rem(s2)
      or
      (e instanceof AssignAndExpr or e instanceof AndBitwiseExpr) and
      result = s1.bitand(s2)
      or
      (e instanceof AssignOrExpr or e instanceof OrBitwiseExpr) and
      result = s1.bitor(s2)
      or
      (e instanceof AssignXorExpr or e instanceof XorBitwiseExpr) and
      result = s1.bitxor(s2)
      or
      (e instanceof AssignLShiftExpr or e instanceof LShiftExpr) and
      result = s1.lshift(s2)
      or
      (e instanceof AssignRShiftExpr or e instanceof RShiftExpr) and
      result = s1.rshift(s2)
      or
      (e instanceof AssignURShiftExpr or e instanceof URShiftExpr) and
      result = s1.urshift(s2)
    )
    or
    result = exprSign(e.(ChooseExpr).getAResultExpr())
    or
    result = exprSign(e.(CastExpr).getExpr())
  }

  private Sign binaryOpLhsSign(Expr e) {
    result = exprSign(e.(BinaryExpr).getLeftOperand()) or
    result = exprSign(e.(AssignOp).getDest())
  }

  private Sign binaryOpRhsSign(Expr e) {
    result = exprSign(e.(BinaryExpr).getRightOperand()) or
    result = exprSign(e.(AssignOp).getRhs())
  }

  pragma[noinline]
  private predicate binaryOpSigns(Expr e, Sign lhs, Sign rhs) {
    lhs = binaryOpLhsSign(e) and
    rhs = binaryOpRhsSign(e)
  }

  Expr getARead(SsaVariable v) { result = v.getAUse() }

  Field getField(FieldAccess fa) { result = fa.getField() }

  Expr getAnExpression(SsaReadPositionBlock bb) { result = bb.getBlock().getANode() }

  Guard getComparisonGuard(ComparisonExpr ce) { result = ce }
}
