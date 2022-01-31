/**
 * Provides C++-specific definitions for use in sign analysis.
 */
module Private {
  private import cpp as C
  private import semmle.code.cpp.ir.IR as IR
  private import semmle.code.cpp.controlflow.IRGuards as IRGuards
  private import Sign
  private import SsaReadPositionSpecific as SsaReadSpecific
  private import SsaReadPositionCommon

  class SsaVariable = SsaReadSpecific::SsaVariable;

  class SsaPhiNode = SsaReadSpecific::SsaPhiNode;

  class Type = IR::IRType;

  class NumericOrCharType = IR::IRNumericType;

  class UnsignedNumericType = IR::IRUnsignedIntegerType;

  /**
   * Empty type for fields.
   *
   * With aliased SSA, we already handle field accesses, or at least the most important ones, as
   * regular SSA definitions.
   */
  private newtype TField = MkField() { none() }

  class Field extends TField {
    string toString() { result = "field" }
  }

  private newtype TGuard = MkGuard() { none() }

  /**
   * Holds if the specified instruction is an equality (`==`, `polarity = true`) or inequality
   * (`!=`, `polarity = false`) guard, with operands `a` and `b`.
   */
  private predicate isEqualityGuard(
    IR::Instruction instr, IR::Operand a, IR::Operand b, boolean polarity
  ) {
    exists(IR::CompareInstruction compare | compare = instr |
      (
        a = compare.getLeftOperand() and b = compare.getRightOperand()
        or
        a = compare.getRightOperand() and b = compare.getLeftOperand()
      ) and
      (
        compare instanceof IR::CompareEQInstruction and polarity = true
        or
        compare instanceof IR::CompareNEInstruction and polarity = false
      )
    )
  }

  /**
   * Wraps an `IRGuardCondition` to expose to the shared sign analysis.
   */
  class Guard extends IRGuards::IRGuardCondition {
    predicate isEquality(Expr a, Expr b, boolean polarity) {
      isEqualityGuard(this, a.getIROperand(), b.getIROperand(), polarity)
    }
  }

  /** Gets the `Guard` whose comparison is `e`. */
  Guard getComparisonGuard(ComparisonExpr e) { result = e.getDef() }

  predicate guardControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
    guard.controls(controlled.(SsaReadPositionBlock).getBlock(), testIsTrue)
    or
    exists(SsaReadPositionPhiInputEdge phiRead | phiRead = controlled |
      guard.controlsEdge(phiRead.getOrigBlock(), phiRead.getPhiBlock(), testIsTrue)
    )
  }

  /**
   * Holds if the result is a `BinaryInstruction` whose operands have the values of `a` and `b` (in
   * that order).
   */
  private IR::BinaryInstruction binaryOp(Expr a, Expr b) {
    exists(IR::Instruction aDef, IR::Instruction bDef | aDef = a.getDef() and bDef = b.getDef() |
      result.getLeft() = aDef and result.getRight() = bDef
    )
  }

  /**
   * Holds if the result is an `AddInstruction` that adds `a` and `b`, in either order.
   */
  private IR::AddInstruction add(Expr a, Expr b) {
    result = binaryOp(a, b)
    or
    result = binaryOp(b, a)
  }

  /**
   * Gets an expression that equals `v - d`.
   */
  Expr ssaRead(SsaVariable v, int delta) {
    exists(IR::Instruction def | result.getDef() = def |
      def.(IR::LoadInstruction).getSourceValue() = v and delta = 0
      or
      exists(ConstantExpr const, int previousDelta |
        def = add(ssaRead(v, previousDelta), const) and
        delta = previousDelta - const.getValue().toInt()
      )
      or
      exists(IR::SubInstruction sub, ConstantExpr const, int previousDelta |
        sub = def and
        sub.getLeftOperand() = ssaRead(v, previousDelta).getIROperand() and
        sub.getRightOperand() = const.getIROperand() and
        delta = previousDelta + const.getValue().toInt()
      )
    )
  }

  VarAccess getARead(SsaVariable v) {
    // The `SsaVariable` is a `StoreInstruction`. Each corresponding reads wrap a use of a
    // `LoadInstruction`. The memory operand of each load is _not_ modeled as an `Expr`.
    exists(IR::LoadInstruction load |
      load.getSourceValue() = v and
      result.getIROperand().getDef() = load
    )
  }

  private newtype TExpr =
    MkExpr(IR::Operand operand) {
      (
        // Include numeric expressions for sign analysis.
        operand.getIRType() instanceof IR::IRNumericType
        or
        // Include Boolean expressions for guards.
        operand.getIRType() instanceof IR::IRBooleanType
      ) and
      not operand.isDefinitionInexact()
    }

  /**
   * Wraps a `RegisterOperand` to expose to the shared sign analysis.
   *
   * Note that `MemoryOperands` are exposed as `SsaVariable`s, not `Expr`s.
   */
  class Expr extends TExpr {
    /** The operand representing the _use_ of the expression. */
    IR::RegisterOperand operand;
    /** The (exact) definition of `operand`. */
    IR::Instruction def;

    Expr() {
      this = MkExpr(operand) and
      def = operand.getDef()
    }

    string toString() { result = operand.toString() }

    C::Location getLocation() { result = operand.getLocation() }

    IR::Operand getIROperand() { result = operand }

    IR::Instruction getDef() { result = def }

    IR::IRType getType() { result = operand.getIRType() }
  }

  class ComparisonExpr extends Expr {
    override IR::CompareInstruction def;
    IR::Opcode opcode;

    ComparisonExpr() {
      opcode = def.getOpcode() and
      // Only relational comparisons count, not equality comparisons.
      (
        opcode instanceof IR::Opcode::CompareLT
        or
        opcode instanceof IR::Opcode::CompareLE
        or
        opcode instanceof IR::Opcode::CompareGT
        or
        opcode instanceof IR::Opcode::CompareGE
      )
    }

    Expr getLesserOperand() {
      (
        opcode instanceof IR::Opcode::CompareLT
        or
        opcode instanceof IR::Opcode::CompareLE
      ) and
      result.getIROperand() = def.getLeftOperand()
      or
      (
        opcode instanceof IR::Opcode::CompareGT
        or
        opcode instanceof IR::Opcode::CompareGE
      ) and
      result.getIROperand() = def.getRightOperand()
    }

    Expr getGreaterOperand() {
      (
        opcode instanceof IR::Opcode::CompareLT
        or
        opcode instanceof IR::Opcode::CompareLE
      ) and
      result.getIROperand() = def.getRightOperand()
      or
      (
        opcode instanceof IR::Opcode::CompareGT
        or
        opcode instanceof IR::Opcode::CompareGE
      ) and
      result.getIROperand() = def.getLeftOperand()
    }

    predicate isStrict() {
      opcode instanceof IR::Opcode::CompareLT
      or
      opcode instanceof IR::Opcode::CompareGT
    }
  }

  class ConstantExpr extends Expr {
    override IR::ConstantValueInstruction def;

    string getValue() { result = def.getValue() }
  }

  class RealLiteral extends ConstantExpr {
    RealLiteral() { operand.getIRType() instanceof IR::IRFloatingPointType }
  }

  class ConstantIntegerExpr extends ConstantExpr {
    ConstantIntegerExpr() { operand.getIRType() instanceof IR::IRIntegerType }

    int getIntValue() { result = def.getValue().toInt() }
  }

  class CastExpr extends Expr {
    override IR::ConvertInstruction def;

    IR::IRType getSourceType() { result = def.getUnaryOperand().getIRType() }
  }

  float getNonIntegerValue(Expr e) {
    not exists(e.(ConstantIntegerExpr).getIntValue()) and
    result = e.(ConstantExpr).getValue().toFloat()
  }

  string getCharValue(Expr e) {
    none() // The IR does not have char types.
  }

  predicate containerSizeAccess(Expr e) {
    none() // TODO
  }

  predicate positiveExpression(Expr e) {
    none() // TODO
  }

  /**
   * Holds if the specific binary instruction acts as an increment or decrement operation.
   */
  private predicate effectiveUnaryOperation(
    IR::BinaryInstruction instr, TUnarySignOperation op, Expr nonUnitOperand
  ) {
    exists(ConstantIntegerExpr const |
      instr = add(const, nonUnitOperand) and
      (
        const.getIntValue() = 1 and op = TIncOp()
        or
        const.getIntValue() = -1 and op = TDecOp()
      )
      or
      instr.(IR::SubInstruction) = binaryOp(nonUnitOperand, const) and
      (
        const.getIntValue() = 1 and op = TDecOp()
        or
        const.getIntValue() = -1 and op = TIncOp()
      )
    )
  }

  class BinaryOperation extends Expr {
    override IR::BinaryInstruction def;
    TBinarySignOperation op;

    BinaryOperation() {
      exists(IR::BinaryOpcode opcode | opcode = def.getOpcode() |
        opcode instanceof IR::Opcode::Add and op = TAddOp()
        or
        opcode instanceof IR::Opcode::Sub and op = TSubOp()
        or
        opcode instanceof IR::Opcode::Mul and op = TMulOp()
        or
        opcode instanceof IR::Opcode::Div and op = TDivOp()
        or
        opcode instanceof IR::Opcode::Rem and op = TRemOp()
        or
        opcode instanceof IR::Opcode::BitAnd and op = TBitAndOp()
        or
        opcode instanceof IR::Opcode::BitOr and op = TBitOrOp()
        or
        opcode instanceof IR::Opcode::BitXor and op = TBitXorOp()
        or
        opcode instanceof IR::Opcode::ShiftLeft and op = TLShiftOp()
        or
        opcode instanceof IR::Opcode::ShiftRight and
        (
          if def.getLeftOperand().getIRType() instanceof IR::IRUnsignedIntegerType
          then op = TURShiftOp()
          else op = TRShiftOp()
        )
      ) and
      not effectiveUnaryOperation(def, _, _)
    }

    TBinarySignOperation getOp() { result = op }

    Expr getLeftOperand() { result.getIROperand() = def.getLeftOperand() }

    Expr getRightOperand() { result.getIROperand() = def.getRightOperand() }
  }

  class DivExpr extends BinaryOperation {
    override IR::DivInstruction def;
  }

  abstract class UnaryOperation extends Expr {
    TUnarySignOperation op;

    final TUnarySignOperation getOp() { result = op }

    abstract Expr getOperand();
  }

  class DirectUnaryOperation extends UnaryOperation {
    override IR::UnaryInstruction def;

    DirectUnaryOperation() {
      exists(IR::UnaryOpcode opcode | opcode = def.getOpcode() |
        opcode instanceof IR::Opcode::Negate and op = TNegOp()
        or
        opcode instanceof IR::Opcode::BitComplement and op = TBitNotOp()
      )
    }

    override Expr getOperand() { result.getIROperand() = def.getUnaryOperand() }
  }

  class EffectiveUnaryOperation extends UnaryOperation {
    override IR::BinaryInstruction def;
    Expr nonUnitOperand;

    EffectiveUnaryOperation() { effectiveUnaryOperation(def, op, nonUnitOperand) }

    override Expr getOperand() { result = nonUnitOperand }
  }

  class VarAccess extends Expr {
    override IR::LoadInstruction def;

    VarAccess() { not def.getSourceValueOperand().isDefinitionInexact() }
  }

  class FieldAccess extends VarAccess {
    FieldAccess() { none() }
  }

  Field getField(FieldAccess access) { none() }

  class VariableUpdate = SsaVariable;

  predicate numericExprWithUnknownSign(Expr e) {
    not (
      e instanceof BinaryOperation
      or
      e instanceof UnaryOperation
      or
      e instanceof ConstantExpr
      or
      e instanceof VarAccess
    )
  }

  Expr getAnExpression(SsaReadPositionBlock bb) {
    result.getIROperand().getUse().getBlock() = bb.getBlock()
  }

  predicate fieldWithUnknownSign(Field f) {
    none() // No need to model fields when we have aliased SSA.
  }

  Expr getAssignedValueToField(Field f) {
    none() // No need to model fields when we have aliased SSA.
  }

  /** Returns the assignment of the variable update `def`. */
  Expr getExprFromSsaAssignment(VariableUpdate def) {
    result.getIROperand() = def.(IR::StoreInstruction).getSourceValueOperand()
  }

  Expr getIncrementOperand(VariableUpdate def) { none() }

  Expr getDecrementOperand(VariableUpdate def) { none() }

  predicate fieldIncrementOperationOperand(Field f) { none() }

  predicate fieldDecrementOperationOperand(Field f) { none() }

  TSign specificFieldSign(Field f) { none() }

  VariableUpdate getExplicitSsaAssignment(SsaVariable v) { result = v }

  predicate explicitSsaDefWithAnySign(VariableUpdate u) { none() }

  Field getImplicitSsaDeclaration(SsaVariable v) { none() }

  predicate nonFieldImplicitSsaDefinition(SsaVariable v) { not v instanceof IR::StoreInstruction }

  Expr getASubExprWithSameSign(Expr e) { none() }
}
