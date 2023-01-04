/**
 * C++-specific implementation of the semantic interface.
 */

private import cpp as Cpp
private import semmle.code.cpp.ir.IR as IR
private import Semantic
private import experimental.semmle.code.cpp.rangeanalysis.Bound as IRBound
private import semmle.code.cpp.controlflow.IRGuards as IRGuards
private import semmle.code.cpp.ir.ValueNumbering

module SemanticExprConfig {
  class Location = Cpp::Location;

  class Expr = IR::Instruction;

  SemBasicBlock getExprBasicBlock(Expr e) { result = getSemanticBasicBlock(e.getBlock()) }

  private predicate anyConstantExpr(Expr expr, SemType type, string value) {
    exists(IR::ConstantInstruction instr | instr = expr |
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
    anyConstantExpr(expr, type, value) and expr instanceof IR::StringConstantInstruction
  }

  predicate binaryExpr(Expr expr, Opcode opcode, SemType type, Expr leftOperand, Expr rightOperand) {
    exists(IR::BinaryInstruction instr | instr = expr |
      type = getSemanticType(instr.getResultIRType()) and
      leftOperand = instr.getLeft() and
      rightOperand = instr.getRight() and
      // REVIEW: Merge the two `Opcode` types.
      opcode.toString() = instr.getOpcode().toString()
    )
  }

  predicate unaryExpr(Expr expr, Opcode opcode, SemType type, Expr operand) {
    type = getSemanticType(expr.getResultIRType()) and
    (
      exists(IR::UnaryInstruction instr | instr = expr |
        operand = instr.getUnary() and
        // REVIEW: Merge the two operand types.
        opcode.toString() = instr.getOpcode().toString()
      )
      or
      exists(IR::StoreInstruction instr | instr = expr |
        operand = instr.getSourceValue() and
        opcode instanceof Opcode::Store
      )
    )
  }

  predicate nullaryExpr(Expr expr, Opcode opcode, SemType type) {
    type = getSemanticType(expr.getResultIRType()) and
    (
      expr instanceof IR::LoadInstruction and opcode instanceof Opcode::Load
      or
      expr instanceof IR::InitializeParameterInstruction and
      opcode instanceof Opcode::InitializeParameter
    )
  }

  predicate conditionalExpr(
    Expr expr, SemType type, Expr condition, Expr trueResult, Expr falseResult
  ) {
    none()
  }

  SemType getUnknownExprType(Expr expr) { result = getSemanticType(expr.getResultIRType()) }

  class BasicBlock = IR::IRBlock;

  predicate bbDominates(BasicBlock dominator, BasicBlock dominated) {
    dominator.dominates(dominated)
  }

  predicate hasDominanceInformation(BasicBlock block) { any() }

  private predicate id(Cpp::Locatable x, Cpp::Locatable y) { x = y }

  private predicate idOf(Cpp::Locatable x, int y) = equivalenceRelation(id/2)(x, y)

  int getBasicBlockUniqueId(BasicBlock block) { idOf(block.getFirstInstruction().getAst(), result) }

  newtype TSsaVariable =
    TSsaInstruction(IR::Instruction instr) { instr.hasMemoryResult() } or
    TSsaOperand(IR::Operand op) { op.isDefinitionInexact() } or
    TSsaPointerArithmeticGuard(IR::PointerArithmeticInstruction instr) {
      exists(Guard g, IR::Operand use | use = instr.getAUse() |
        g.comparesLt(use, _, _, _, _) or
        g.comparesLt(_, use, _, _, _) or
        g.comparesEq(use, _, _, _, _) or
        g.comparesEq(_, use, _, _, _)
      )
    }

  class SsaVariable extends TSsaVariable {
    string toString() { none() }

    Location getLocation() { none() }

    IR::Instruction asInstruction() { none() }

    IR::PointerArithmeticInstruction asPointerArithGuard() { none() }

    IR::Operand asOperand() { none() }
  }

  class SsaInstructionVariable extends SsaVariable, TSsaInstruction {
    IR::Instruction instr;

    SsaInstructionVariable() { this = TSsaInstruction(instr) }

    final override string toString() { result = instr.toString() }

    final override Location getLocation() { result = instr.getLocation() }

    final override IR::Instruction asInstruction() { result = instr }
  }

  class SsaPointerArithmeticGuard extends SsaVariable, TSsaPointerArithmeticGuard {
    IR::PointerArithmeticInstruction instr;

    SsaPointerArithmeticGuard() { this = TSsaPointerArithmeticGuard(instr) }

    final override string toString() { result = instr.toString() }

    final override Location getLocation() { result = instr.getLocation() }

    final override IR::PointerArithmeticInstruction asPointerArithGuard() { result = instr }
  }

  class SsaOperand extends SsaVariable, TSsaOperand {
    IR::Operand op;

    SsaOperand() { this = TSsaOperand(op) }

    final override string toString() { result = op.toString() }

    final override Location getLocation() { result = op.getLocation() }

    final override IR::Operand asOperand() { result = op }
  }

  predicate explicitUpdate(SsaVariable v, Expr sourceExpr) { v.asInstruction() = sourceExpr }

  predicate phi(SsaVariable v) { v.asInstruction() instanceof IR::PhiInstruction }

  SsaVariable getAPhiInput(SsaVariable v) {
    exists(IR::PhiInstruction instr | v.asInstruction() = instr |
      result.asInstruction() = instr.getAnInput()
      or
      result.asOperand() = instr.getAnInputOperand()
    )
  }

  Expr getAUse(SsaVariable v) {
    result.(IR::LoadInstruction).getSourceValue() = v.asInstruction()
    or
    result = valueNumber(v.asPointerArithGuard()).getAnInstruction()
  }

  SemType getSsaVariableType(SsaVariable v) {
    result = getSemanticType(v.asInstruction().getResultIRType())
  }

  BasicBlock getSsaVariableBasicBlock(SsaVariable v) {
    result = v.asInstruction().getBlock()
    or
    result = v.asOperand().getUse().getBlock()
  }

  private newtype TReadPosition =
    TReadPositionBlock(IR::IRBlock block) or
    TReadPositionPhiInputEdge(IR::IRBlock pred, IR::IRBlock succ) {
      exists(IR::PhiInputOperand input |
        pred = input.getPredecessorBlock() and
        succ = input.getUse().getBlock()
      )
    }

  class SsaReadPosition extends TReadPosition {
    string toString() { none() }

    Location getLocation() { none() }

    predicate hasRead(SsaVariable v) { none() }
  }

  private class SsaReadPositionBlock extends SsaReadPosition, TReadPositionBlock {
    IR::IRBlock block;

    SsaReadPositionBlock() { this = TReadPositionBlock(block) }

    final override string toString() { result = block.toString() }

    final override Location getLocation() { result = block.getLocation() }

    final override predicate hasRead(SsaVariable v) {
      exists(IR::Operand operand |
        operand.getDef() = v.asInstruction() or
        operand.getDef() = valueNumber(v.asPointerArithGuard()).getAnInstruction()
      |
        not operand instanceof IR::PhiInputOperand and
        operand.getUse().getBlock() = block
      )
    }
  }

  private class SsaReadPositionPhiInputEdge extends SsaReadPosition, TReadPositionPhiInputEdge {
    IR::IRBlock pred;
    IR::IRBlock succ;

    SsaReadPositionPhiInputEdge() { this = TReadPositionPhiInputEdge(pred, succ) }

    final override string toString() { result = pred.toString() + "->" + succ.toString() }

    final override Location getLocation() { result = succ.getLocation() }

    final override predicate hasRead(SsaVariable v) {
      exists(IR::PhiInputOperand operand |
        operand.getDef() = v.asInstruction() or
        operand.getDef() = valueNumber(v.asPointerArithGuard()).getAnInstruction()
      |
        operand.getPredecessorBlock() = pred and
        operand.getUse().getBlock() = succ
      )
    }
  }

  predicate hasReadOfSsaVariable(SsaReadPosition pos, SsaVariable v) { pos.hasRead(v) }

  predicate readBlock(SsaReadPosition pos, BasicBlock block) { pos = TReadPositionBlock(block) }

  predicate phiInputEdge(SsaReadPosition pos, BasicBlock origBlock, BasicBlock phiBlock) {
    pos = TReadPositionPhiInputEdge(origBlock, phiBlock)
  }

  predicate phiInput(SsaReadPosition pos, SsaVariable phi, SsaVariable input) {
    exists(IR::PhiInputOperand operand |
      pos = TReadPositionPhiInputEdge(operand.getPredecessorBlock(), operand.getUse().getBlock())
    |
      phi.asInstruction() = operand.getUse() and
      (
        input.asInstruction() = operand.getDef()
        or
        input.asOperand() = operand
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
    result = bound.(IRBound::Bound).getInstruction(delta)
  }

  class Guard = IRGuards::IRGuardCondition;

  predicate guard(Guard guard, BasicBlock block) { block = guard.getBlock() }

  Expr getGuardAsExpr(Guard guard) { result = guard }

  predicate equalityGuard(Guard guard, Expr e1, Expr e2, boolean polarity) {
    guard.comparesEq(e1.getAUse(), e2.getAUse(), 0, true, polarity)
  }

  predicate guardDirectlyControlsBlock(Guard guard, BasicBlock controlled, boolean branch) {
    guard.controls(controlled, branch)
  }

  predicate guardHasBranchEdge(Guard guard, BasicBlock bb1, BasicBlock bb2, boolean branch) {
    guard.controlsEdge(bb1, bb2, branch)
  }

  Guard comparisonGuard(Expr e) { result = e }

  predicate implies_v2(Guard g1, boolean b1, Guard g2, boolean b2) {
    none() // TODO
  }
}

SemExpr getSemanticExpr(IR::Instruction instr) { result = instr }

IR::Instruction getCppInstruction(SemExpr e) { e = result }

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
