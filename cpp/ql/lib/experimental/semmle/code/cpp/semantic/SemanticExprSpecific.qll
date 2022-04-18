/**
 * C++-specific implementation of the semantic interface.
 */

private import cpp as Cpp
private import semmle.code.cpp.ir.IR as IR
private import Semantic
private import experimental.semmle.code.cpp.rangeanalysis.Bound as IRBound
private import semmle.code.cpp.controlflow.IRGuards as IRGuards

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

  int getBasicBlockUniqueId(BasicBlock block) {
    // REVIEW: `getDisplayIndex()` is not intended for use in real queries, but for now it's the
    // best we can do because `equivalentRelation` won't accept a predicate whose parameters are IPA
    // types.
    result = block.getDisplayIndex()
  }

  class SsaVariable instanceof IR::Instruction {
    SsaVariable() { super.hasMemoryResult() }

    final string toString() { result = super.toString() }

    final Location getLocation() { result = super.getLocation() }
  }

  predicate explicitUpdate(SsaVariable v, Expr sourceExpr) { v = sourceExpr }

  predicate phi(SsaVariable v) { v instanceof IR::PhiInstruction }

  SsaVariable getAPhiInput(SsaVariable v) { result = v.(IR::PhiInstruction).getAnInput() }

  Expr getAUse(SsaVariable v) { result.(IR::LoadInstruction).getSourceValue() = v }

  SemType getSsaVariableType(SsaVariable v) {
    result = getSemanticType(v.(IR::Instruction).getResultIRType())
  }

  BasicBlock getSsaVariableBasicBlock(SsaVariable v) { result = v.(IR::Instruction).getBlock() }

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
        operand.getDef() = v and not operand instanceof IR::PhiInputOperand
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
        operand.getDef() = v and
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
      phi = operand.getUse() and input = operand.getDef()
    )
  }

  class Bound instanceof IRBound::Bound {
    Bound() {
      this instanceof IRBound::ZeroBound
      or
      this.(IRBound::ValueNumberBound).getValueNumber().getAnInstruction() instanceof SsaVariable
    }

    string toString() { result = super.toString() }

    final Location getLocation() { result = super.getLocation() }
  }

  private class ValueNumberBound extends Bound {
    IRBound::ValueNumberBound bound;

    ValueNumberBound() { bound = this }

    override string toString() {
      result =
        min(SsaVariable instr |
          instr = bound.getValueNumber().getAnInstruction()
        |
          instr
          order by
            instr.(IR::Instruction).getBlock().getDisplayIndex(),
            instr.(IR::Instruction).getDisplayIndexInBlock()
        ).toString()
    }
  }

  predicate zeroBound(Bound bound) { bound instanceof IRBound::ZeroBound }

  predicate ssaBound(Bound bound, SsaVariable v) {
    v = bound.(IRBound::ValueNumberBound).getValueNumber().getAnInstruction()
  }

  Expr getBoundExpr(Bound bound, int delta) {
    result = bound.(IRBound::Bound).getInstruction(delta)
  }

  class Guard = IRGuards::IRGuardCondition;

  predicate guard(Guard guard, BasicBlock block) {
    block = guard.(IRGuards::IRGuardCondition).getBlock()
  }

  Expr getGuardAsExpr(Guard guard) { result = guard }

  predicate equalityGuard(Guard guard, Expr e1, Expr e2, boolean polarity) {
    guard.(IRGuards::IRGuardCondition).comparesEq(e1.getAUse(), e2.getAUse(), 0, true, polarity)
  }

  predicate guardDirectlyControlsBlock(Guard guard, BasicBlock controlled, boolean branch) {
    guard.(IRGuards::IRGuardCondition).controls(controlled, branch)
  }

  predicate guardHasBranchEdge(Guard guard, BasicBlock bb1, BasicBlock bb2, boolean branch) {
    guard.(IRGuards::IRGuardCondition).controlsEdge(bb1, bb2, branch)
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

SemSsaVariable getSemanticSsaVariable(IR::Instruction instr) { result = instr }

IR::Instruction getCppSsaVariableInstruction(SemSsaVariable v) { v = result }

SemBound getSemanticBound(IRBound::Bound bound) { result = bound }

IRBound::Bound getCppBound(SemBound bound) { bound = result }

SemGuard getSemanticGuard(IRGuards::IRGuardCondition guard) { result = guard }

IRGuards::IRGuardCondition getCppGuard(SemGuard guard) { guard = result }
