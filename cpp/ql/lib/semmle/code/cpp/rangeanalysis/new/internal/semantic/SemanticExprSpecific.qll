/**
 * C++-specific implementation of the semantic interface.
 */

private import cpp as Cpp
private import semmle.code.cpp.ir.IR as IR
private import Semantic
private import analysis.Bound as IRBound
private import semmle.code.cpp.controlflow.IRGuards as IRGuards
private import semmle.code.cpp.ir.ValueNumbering

module SemanticExprConfig {
  class Location = Cpp::Location;

  /**
   * The expressions on which we perform range analysis.
   */
  class Expr = IR::Instruction;

  SemBasicBlock getExprBasicBlock(Expr e) { result = getSemanticBasicBlock(e.getBlock()) }

  private predicate anyConstantExpr(Expr expr, SemType type, string value) {
    exists(IR::ConstantInstruction instr | getSemanticExpr(instr) = expr |
      type = getSemanticType(instr.getResultIRType()) and
      value = instr.getValue()
    )
  }

  predicate integerLiteral(Expr expr, SemIntegerType type, int value) {
    exists(string valueString |
      anyConstantExpr(expr, type, valueString) and
      value = valueString.toInt()
    )
  }

  predicate largeIntegerLiteral(Expr expr, SemIntegerType type, float approximateFloatValue) {
    exists(string valueString |
      anyConstantExpr(expr, type, valueString) and
      not exists(valueString.toInt()) and
      approximateFloatValue = valueString.toFloat()
    )
  }

  predicate floatingPointLiteral(Expr expr, SemFloatingPointType type, float value) {
    exists(string valueString |
      anyConstantExpr(expr, type, valueString) and value = valueString.toFloat()
    )
  }

  predicate booleanLiteral(Expr expr, SemBooleanType type, boolean value) {
    exists(string valueString |
      anyConstantExpr(expr, type, valueString) and
      (
        valueString = "true" and value = true
        or
        valueString = "false" and value = false
      )
    )
  }

  predicate nullLiteral(Expr expr, SemAddressType type) { anyConstantExpr(expr, type, _) }

  predicate stringLiteral(Expr expr, SemType type, string value) {
    anyConstantExpr(expr, type, value) and
    expr instanceof IR::StringConstantInstruction
  }

  predicate binaryExpr(Expr expr, Opcode opcode, SemType type, Expr leftOperand, Expr rightOperand) {
    exists(IR::BinaryInstruction instr |
      instr = expr and
      type = getSemanticType(instr.getResultIRType()) and
      leftOperand = getSemanticExpr(instr.getLeft()) and
      rightOperand = getSemanticExpr(instr.getRight()) and
      // REVIEW: Merge the two `Opcode` types.
      opcode.toString() = instr.getOpcode().toString()
    )
  }

  predicate unaryExpr(Expr expr, Opcode opcode, SemType type, Expr operand) {
    exists(IR::UnaryInstruction instr | instr = expr |
      type = getSemanticType(instr.getResultIRType()) and
      operand = getSemanticExpr(instr.getUnary()) and
      // REVIEW: Merge the two operand types.
      opcode.toString() = instr.getOpcode().toString()
    )
    or
    exists(IR::StoreInstruction instr | instr = expr |
      type = getSemanticType(instr.getResultIRType()) and
      operand = getSemanticExpr(instr.getSourceValue()) and
      opcode instanceof Opcode::Store
    )
  }

  predicate nullaryExpr(Expr expr, Opcode opcode, SemType type) {
    exists(IR::LoadInstruction load |
      load = expr and
      type = getSemanticType(load.getResultIRType()) and
      opcode instanceof Opcode::Load
    )
    or
    exists(IR::InitializeParameterInstruction init |
      init = expr and
      type = getSemanticType(init.getResultIRType()) and
      opcode instanceof Opcode::InitializeParameter
    )
  }

  predicate conditionalExpr(
    Expr expr, SemType type, Expr condition, Expr trueResult, Expr falseResult
  ) {
    none()
  }

  /** Holds if no range analysis should be performed on the phi edges in `f`. */
  private predicate excludeFunction(Cpp::Function f) { count(f.getEntryPoint()) > 1 }

  SemType getUnknownExprType(Expr expr) { result = getSemanticType(expr.getResultIRType()) }

  class BasicBlock = IR::IRBlock;

  predicate bbDominates(BasicBlock dominator, BasicBlock dominated) {
    dominator.dominates(dominated)
  }

  private predicate id(Cpp::Locatable x, Cpp::Locatable y) { x = y }

  private predicate idOf(Cpp::Locatable x, int y) = equivalenceRelation(id/2)(x, y)

  int getBasicBlockUniqueId(BasicBlock block) { idOf(block.getFirstInstruction().getAst(), result) }

  newtype TSsaVariable =
    TSsaInstruction(IR::Instruction instr) { instr.hasMemoryResult() } or
    TSsaOperand(IR::PhiInputOperand op) { op.isDefinitionInexact() }

  class SsaVariable extends TSsaVariable {
    string toString() { none() }

    Location getLocation() { none() }

    IR::Instruction asInstruction() { none() }

    IR::PhiInputOperand asOperand() { none() }
  }

  class SsaInstructionVariable extends SsaVariable, TSsaInstruction {
    IR::Instruction instr;

    SsaInstructionVariable() { this = TSsaInstruction(instr) }

    final override string toString() { result = instr.toString() }

    final override Location getLocation() { result = instr.getLocation() }

    final override IR::Instruction asInstruction() { result = instr }
  }

  class SsaOperand extends SsaVariable, TSsaOperand {
    IR::PhiInputOperand op;

    SsaOperand() { this = TSsaOperand(op) }

    final override string toString() { result = op.toString() }

    final override Location getLocation() { result = op.getLocation() }

    final override IR::PhiInputOperand asOperand() { result = op }
  }

  predicate explicitUpdate(SsaVariable v, Expr sourceExpr) {
    getSemanticExpr(v.asInstruction()) = sourceExpr
  }

  predicate phi(SsaVariable v) {
    exists(IR::PhiInstruction phi, Cpp::Function f |
      phi = v.asInstruction() and
      f = phi.getEnclosingFunction() and
      not excludeFunction(f)
    )
  }

  SsaVariable getAPhiInput(SsaVariable v) {
    exists(IR::PhiInstruction instr | v.asInstruction() = instr |
      result.asInstruction() = instr.getAnInput()
      or
      result.asOperand() = instr.getAnInputOperand()
    )
  }

  Expr getAUse(SsaVariable v) { result.(IR::LoadInstruction).getSourceValue() = v.asInstruction() }

  SemType getSsaVariableType(SsaVariable v) {
    result = getSemanticType(v.asInstruction().getResultIRType())
    or
    result = getSemanticType(v.asOperand().getUse().getResultIRType())
  }

  BasicBlock getSsaVariableBasicBlock(SsaVariable v) {
    result = v.asInstruction().getBlock()
    or
    result = v.asOperand().getAnyDef().getBlock()
  }

  /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
  predicate phiInputFromBlock(SsaVariable phi, SsaVariable inp, BasicBlock bb) {
    exists(IR::PhiInputOperand operand |
      bb = operand.getPredecessorBlock() and
      phi.asInstruction() = operand.getUse() and
      (
        inp.asInstruction() = operand.getDef()
        or
        inp.asOperand() = operand
      )
    )
  }

  class Bound instanceof IRBound::Bound {
    string toString() { result = super.toString() }

    final Location getLocation() { result = super.getLocation() }
  }

  private class ValueNumberBound extends Bound instanceof IRBound::ValueNumberBound {
    override string toString() { result = IRBound::ValueNumberBound.super.toString() }
  }

  predicate zeroBound(Bound bound) { bound instanceof IRBound::ZeroBound }

  predicate ssaBound(Bound bound, SsaVariable v) {
    v.asInstruction() = bound.(IRBound::ValueNumberBound).getValueNumber().getAnInstruction()
  }

  Expr getBoundExpr(Bound bound, int delta) {
    result = getSemanticExpr(bound.(IRBound::Bound).getInstruction(delta))
  }

  class Guard = IRGuards::IRGuardCondition;

  predicate guard(Guard guard, BasicBlock block) { block = guard.getBlock() }

  Expr getGuardAsExpr(Guard guard) { result = getSemanticExpr(guard) }

  predicate equalityGuard(Guard guard, Expr e1, Expr e2, boolean polarity) {
    exists(IR::Instruction left, IR::Instruction right |
      getSemanticExpr(left) = e1 and
      getSemanticExpr(right) = e2 and
      guard.comparesEq(left.getAUse(), right.getAUse(), 0, true, polarity)
    )
  }

  predicate guardDirectlyControlsBlock(Guard guard, BasicBlock controlled, boolean branch) {
    guard.controls(controlled, branch)
  }

  predicate guardHasBranchEdge(Guard guard, BasicBlock bb1, BasicBlock bb2, boolean branch) {
    guard.controlsEdge(bb1, bb2, branch)
  }

  Guard comparisonGuard(Expr e) { getSemanticExpr(result) = e }

  predicate implies_v2(Guard g1, boolean b1, Guard g2, boolean b2) {
    none() // TODO
  }

  /** Gets the expression associated with `instr`. */
  SemExpr getSemanticExpr(IR::Instruction instr) { result = instr }
}

predicate getSemanticExpr = SemanticExprConfig::getSemanticExpr/1;

SemBasicBlock getSemanticBasicBlock(IR::IRBlock block) { result = block }

IR::IRBlock getCppBasicBlock(SemBasicBlock block) { block = result }

SemSsaVariable getSemanticSsaVariable(IR::Instruction instr) {
  result.(SemanticExprConfig::SsaVariable).asInstruction() = instr
}

IR::Instruction getCppSsaVariableInstruction(SemSsaVariable var) {
  var.(SemanticExprConfig::SsaVariable).asInstruction() = result
}

SemBound getSemanticBound(IRBound::Bound bound) { result = bound }

IRBound::Bound getCppBound(SemBound bound) { bound = result }

SemGuard getSemanticGuard(IRGuards::IRGuardCondition guard) { result = guard }

IRGuards::IRGuardCondition getCppGuard(SemGuard guard) { guard = result }
