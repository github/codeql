private import java as J
private import SemanticBound
private import SemanticCFG
private import SemanticExpr
private import SemanticGuard
private import SemanticSSA
private import SemanticType
private import semmle.code.java.dataflow.SSA as SSA
private import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon as SsaRead
private import semmle.code.java.dataflow.Bound as JBound
private import semmle.code.java.controlflow.Guards as JGuards
private import semmle.code.java.controlflow.internal.GuardsLogic as JGuardsLogic

private module Impl {
  newtype TExpr =
    TPrimaryExpr(J::Expr e) or
    TPostUpdateExpr(J::UnaryAssignExpr e) {
      e instanceof J::PostIncExpr or e instanceof J::PostDecExpr
    } or
    TEnhancedForInit(J::EnhancedForStmt for) or
    TParameterInit(SSA::SsaImplicitInit init, J::Parameter param) {
      init.isParameterDefinition(param)
    }

  TExpr getResultExpr(J::Expr e) { result = TPrimaryExpr(e) }
}

module SemanticExprConfig {
  private import Impl

  class Location = J::Location;

  class Expr extends TExpr {
    string toString() { none() }

    Location getLocation() { none() }

    BasicBlock getBasicBlock() { none() }
  }

  private class PrimaryExpr extends Expr, TPrimaryExpr {
    J::Expr e;

    PrimaryExpr() { this = TPrimaryExpr(e) }

    override string toString() { result = e.toString() }

    override Location getLocation() { result = e.getLocation() }

    override BasicBlock getBasicBlock() { result = e.getBasicBlock() }

    J::Expr getExpr() { result = e }
  }

  private class PostUpdateExpr extends Expr, TPostUpdateExpr {
    J::UnaryAssignExpr e;

    PostUpdateExpr() { this = TPostUpdateExpr(e) }

    override string toString() { result = "post-update for " + e.toString() }

    override Location getLocation() { result = e.getLocation() }

    override BasicBlock getBasicBlock() { result = e.getBasicBlock() }

    J::UnaryAssignExpr getExpr() { result = e }
  }

  private class EnhancedForInitExpr extends Expr, TEnhancedForInit {
    J::EnhancedForStmt for;

    EnhancedForInitExpr() { this = TEnhancedForInit(for) }

    override string toString() { result = "init of " + for.getVariable().toString() }

    override Location getLocation() { result = for.getVariable().getLocation() }

    override BasicBlock getBasicBlock() { result = for.getVariable().getBasicBlock() }
  }

  private class ParameterInitExpr extends Expr, TParameterInit {
    SSA::SsaImplicitInit init;
    J::Parameter param;

    ParameterInitExpr() { this = TParameterInit(init, param) }

    override string toString() { result = "param init: " + init.toString() }

    override Location getLocation() { result = init.getLocation() }

    override BasicBlock getBasicBlock() { result = init.getBasicBlock() }

    final J::Parameter getParameter() { result = param }
  }

  string exprToString(Expr e) { result = e.toString() }

  Location getExprLocation(Expr e) { result = e.getLocation() }

  SemBasicBlock getExprBasicBlock(Expr e) { result = getSemanticBasicBlock(e.getBasicBlock()) }

  predicate integerLiteral(Expr expr, SemIntegerType type, int value) {
    exists(J::Expr javaExpr | javaExpr = expr.(PrimaryExpr).getExpr() |
      type = getSemanticType(javaExpr.getType()) and
      (
        value = javaExpr.(J::IntegerLiteral).getIntValue()
        or
        value = javaExpr.(J::CharacterLiteral).getCodePointValue()
      )
      // For compatibility reasons, we don't provide exact values for `LongLiteral`s, even if the value
      // would fit in an `int`.
    )
  }

  predicate largeIntegerLiteral(Expr expr, SemIntegerType type, float approximateFloatValue) {
    exists(J::Expr javaExpr | javaExpr = expr.(PrimaryExpr).getExpr() |
      type = getSemanticType(javaExpr.getType()) and
      approximateFloatValue = javaExpr.(J::LongLiteral).getValue().toFloat()
    )
  }

  predicate floatingPointLiteral(Expr expr, SemFloatingPointType type, float value) {
    exists(J::Expr javaExpr | javaExpr = expr.(PrimaryExpr).getExpr() |
      type = getSemanticType(javaExpr.getType()) and
      (
        value = javaExpr.(J::FloatingPointLiteral).getFloatValue()
        or
        value = javaExpr.(J::DoubleLiteral).getDoubleValue()
      )
    )
  }

  predicate booleanLiteral(Expr expr, SemBooleanType type, boolean value) {
    exists(J::Expr javaExpr | javaExpr = expr.(PrimaryExpr).getExpr() |
      type = getSemanticType(javaExpr.getType()) and
      value = javaExpr.(J::BooleanLiteral).getBooleanValue()
    )
  }

  predicate nullLiteral(Expr expr, SemAddressType type) {
    type = getSemanticType(expr.(PrimaryExpr).getExpr().(J::NullLiteral).getType())
  }

  predicate stringLiteral(Expr expr, SemType type, string value) {
    exists(J::Expr javaExpr | javaExpr = expr.(PrimaryExpr).getExpr() |
      type = getSemanticType(javaExpr.getType()) and
      value = javaExpr.(J::StringLiteral).getValue()
    )
  }

  predicate binaryExpr(Expr expr, Opcode opcode, SemType type, Expr leftOperand, Expr rightOperand) {
    exists(J::Expr javaExpr | javaExpr = expr.(PrimaryExpr).getExpr() |
      type = getSemanticType(javaExpr.getType()) and
      (
        exists(J::BinaryExpr binary | binary = javaExpr |
          leftOperand = getResultExpr(binary.getLeftOperand()) and
          rightOperand = getResultExpr(binary.getRightOperand()) and
          (
            binary instanceof J::AddExpr and opcode instanceof Opcode::Add
            or
            binary instanceof J::SubExpr and opcode instanceof Opcode::Sub
            or
            binary instanceof J::MulExpr and opcode instanceof Opcode::Mul
            or
            binary instanceof J::DivExpr and opcode instanceof Opcode::Div
            or
            binary instanceof J::RemExpr and opcode instanceof Opcode::Rem
            or
            binary instanceof J::AndBitwiseExpr and opcode instanceof Opcode::BitAnd
            or
            binary instanceof J::OrBitwiseExpr and opcode instanceof Opcode::BitOr
            or
            binary instanceof J::XorBitwiseExpr and opcode instanceof Opcode::BitXor
            or
            binary instanceof J::LShiftExpr and opcode instanceof Opcode::ShiftLeft
            or
            binary instanceof J::RShiftExpr and opcode instanceof Opcode::ShiftRight
            or
            binary instanceof J::URShiftExpr and opcode instanceof Opcode::ShiftRightUnsigned
            or
            binary instanceof J::EQExpr and opcode instanceof Opcode::CompareEQ
            or
            binary instanceof J::NEExpr and opcode instanceof Opcode::CompareNE
            or
            binary instanceof J::LTExpr and opcode instanceof Opcode::CompareLT
            or
            binary instanceof J::LEExpr and opcode instanceof Opcode::CompareLE
            or
            binary instanceof J::GTExpr and opcode instanceof Opcode::CompareGT
            or
            binary instanceof J::GEExpr and opcode instanceof Opcode::CompareGE
          )
        )
        or
        exists(J::AssignOp assignOp | assignOp = javaExpr |
          leftOperand = getResultExpr(assignOp.getDest()) and
          rightOperand = getResultExpr(assignOp.getRhs()) and
          (
            assignOp instanceof J::AssignAddExpr and opcode instanceof Opcode::Add
            or
            assignOp instanceof J::AssignSubExpr and opcode instanceof Opcode::Sub
            or
            assignOp instanceof J::AssignMulExpr and opcode instanceof Opcode::Mul
            or
            assignOp instanceof J::AssignDivExpr and opcode instanceof Opcode::Div
            or
            assignOp instanceof J::AssignRemExpr and opcode instanceof Opcode::Rem
            or
            assignOp instanceof J::AssignAndExpr and opcode instanceof Opcode::BitAnd
            or
            assignOp instanceof J::AssignOrExpr and opcode instanceof Opcode::BitOr
            or
            assignOp instanceof J::AssignXorExpr and opcode instanceof Opcode::BitXor
            or
            assignOp instanceof J::AssignLShiftExpr and opcode instanceof Opcode::ShiftLeft
            or
            assignOp instanceof J::AssignRShiftExpr and opcode instanceof Opcode::ShiftRight
            or
            // TODO: Add new opcode or add an implicit conversion
            assignOp instanceof J::AssignURShiftExpr and
            opcode instanceof Opcode::ShiftRightUnsigned
          )
        )
      )
    )
  }

  private predicate primaryUnaryExpr(J::Expr javaExpr, Opcode opcode, Expr operand) {
    exists(J::UnaryExpr unary | unary = javaExpr |
      operand = getResultExpr(unary.getExpr()) and
      (
        unary instanceof J::MinusExpr and opcode instanceof Opcode::Negate
        or
        unary instanceof J::PlusExpr and opcode instanceof Opcode::CopyValue
        or
        unary instanceof J::BitNotExpr and opcode instanceof Opcode::BitComplement
        or
        unary instanceof J::LogNotExpr and opcode instanceof Opcode::LogicalNot
        or
        unary instanceof J::PreIncExpr and opcode instanceof Opcode::AddOne
        or
        unary instanceof J::PreDecExpr and opcode instanceof Opcode::SubOne
        or
        // Post-increment/decrement returns the original value. The actual increment/decrement part
        // is a separate `Expr`.
        unary instanceof J::PostIncExpr and opcode instanceof Opcode::CopyValue
        or
        unary instanceof J::PostDecExpr and opcode instanceof Opcode::CopyValue
      )
    )
    or
    exists(J::CastExpr cast | cast = javaExpr |
      // TODO: Boolean? Null? Boxing?
      getSemanticType(cast.getType()) instanceof SemNumericType and
      getSemanticType(cast.getExpr().getType()) instanceof SemNumericType and
      opcode instanceof Opcode::Convert and
      operand = getResultExpr(cast.getExpr())
    )
    or
    exists(J::AssignExpr assign | assign = javaExpr |
      opcode instanceof Opcode::CopyValue and
      operand = getResultExpr(assign.getSource())
    )
    or
    exists(J::LocalVariableDeclExpr decl | decl = javaExpr |
      opcode instanceof Opcode::CopyValue and
      operand = getResultExpr(decl.getInit())
    )
  }

  private predicate postUpdateUnaryExpr(J::UnaryAssignExpr javaExpr, Opcode opcode, Expr operand) {
    exists(J::UnaryAssignExpr unaryAssign | unaryAssign = javaExpr |
      operand = getResultExpr(unaryAssign.getExpr()) and
      (
        javaExpr instanceof J::PostIncExpr and opcode instanceof Opcode::AddOne
        or
        javaExpr instanceof J::PostDecExpr and opcode instanceof Opcode::SubOne
      )
    )
  }

  private predicate unaryExprWithoutType(Expr expr, Opcode opcode, Expr operand, J::Expr javaExpr) {
    primaryUnaryExpr(javaExpr, opcode, operand) and
    expr = TPrimaryExpr(javaExpr)
    or
    postUpdateUnaryExpr(javaExpr, opcode, operand) and
    expr = TPostUpdateExpr(javaExpr)
  }

  predicate unaryExpr(Expr expr, Opcode opcode, SemType type, Expr operand) {
    exists(J::Expr javaExpr, J::Type javaType |
      unaryExprWithoutType(expr, opcode, operand, javaExpr) and
      javaType = javaExpr.getType() and
      type = getSemanticType(javaType)
    )
  }

  predicate nullaryExpr(Expr expr, Opcode opcode, SemType type) {
    exists(ParameterInitExpr paramInit | paramInit = expr |
      opcode instanceof Opcode::InitializeParameter and
      type = getSemanticType(paramInit.getParameter().getType())
    )
    or
    exists(J::RValue rval | rval = expr.(PrimaryExpr).getExpr() |
      type = getSemanticType(rval.getType()) and
      opcode instanceof Opcode::Load
    )
  }

  predicate conditionalExpr(
    Expr expr, SemType type, Expr condition, Expr trueResult, Expr falseResult
  ) {
    exists(J::ConditionalExpr condExpr | condExpr = expr.(PrimaryExpr).getExpr() |
      type = getSemanticType(condExpr.getType()) and
      condition = getResultExpr(condExpr.getCondition()) and
      trueResult = getResultExpr(condExpr.getTrueExpr()) and
      falseResult = getResultExpr(condExpr.getFalseExpr())
    )
  }

  SemType getUnknownExprType(Expr expr) {
    result = getSemanticType(expr.(PrimaryExpr).getExpr().getType())
    or
    exists(J::EnhancedForStmt for | expr = TEnhancedForInit(for) |
      result = getSemanticType(for.getVariable().getType())
    )
  }

  class BasicBlock instanceof J::BasicBlock {
    final string toString() { result = super.toString() }

    final Location getLocation() { result = super.getLocation() }
  }

  predicate bbDominates(BasicBlock dominator, BasicBlock dominated) {
    dominator.(J::BasicBlock).bbDominates(dominated.(J::BasicBlock))
  }

  predicate hasDominanceInformation(BasicBlock block) { J::hasDominanceInformation(block) }

  class SsaVariable instanceof SSA::SsaVariable {
    final string toString() { result = super.toString() }

    final Location getLocation() { result = super.getLocation() }
  }

  predicate explicitUpdate(SsaVariable v, SemType type, Expr sourceExpr) {
    exists(SSA::SsaExplicitUpdate update | v = update |
      type = getSemanticType(update.getSourceVariable().getType()) and
      exists(J::Expr expr | expr = update.getDefiningExpr() |
        (
          expr instanceof J::AssignOp or
          expr instanceof J::PreIncExpr or
          expr instanceof J::PreDecExpr
        ) and
        sourceExpr = getResultExpr(expr)
        or
        sourceExpr = getResultExpr(expr.(J::AssignExpr).getSource())
        or
        sourceExpr = getResultExpr(expr.(J::LocalVariableDeclExpr).getInit())
        or
        (expr instanceof J::PostIncExpr or expr instanceof J::PostDecExpr) and
        sourceExpr = TPostUpdateExpr(expr)
        or
        exists(J::EnhancedForStmt for |
          for.getVariable() = expr and
          sourceExpr = TEnhancedForInit(for)
        )
      )
    )
  }

  predicate phi(SsaVariable v, SemType type) {
    type = getSemanticType(v.(SSA::SsaPhiNode).getSourceVariable().getType())
  }

  SsaVariable getAPhiInput(SsaVariable v) { result = v.(SSA::SsaPhiNode).getAPhiInput() }

  Expr getAUse(SsaVariable v) { result = getResultExpr(v.(SSA::SsaVariable).getAUse()) }

  BasicBlock getSsaVariableBasicBlock(SsaVariable v) {
    result = v.(SSA::SsaVariable).getBasicBlock()
  }

  class SsaReadPosition instanceof SsaRead::SsaReadPosition {
    final string toString() { result = super.toString() }

    Location getLocation() { none() }
  }

  private class SsaReadPositionBlock extends SsaReadPosition {
    SsaRead::SsaReadPositionBlock block;

    SsaReadPositionBlock() { this = block }

    final override Location getLocation() { result = block.getBlock().getLocation() }
  }

  private class SsaReadPositionPhiInputEdge extends SsaReadPosition {
    SsaRead::SsaReadPositionPhiInputEdge edge;

    SsaReadPositionPhiInputEdge() { this = edge }

    final override Location getLocation() { result = edge.getPhiBlock().getLocation() }
  }

  predicate hasReadOfSsaVariable(SsaReadPosition pos, SsaVariable v) {
    pos.(SsaRead::SsaReadPosition).hasReadOfVar(v)
  }

  predicate readBlock(SsaReadPosition pos, BasicBlock block) {
    block = pos.(SsaRead::SsaReadPositionBlock).getBlock()
  }

  predicate phiInputEdge(SsaReadPosition pos, BasicBlock origBlock, BasicBlock phiBlock) {
    exists(SsaRead::SsaReadPositionPhiInputEdge readBlock | readBlock = pos |
      origBlock = readBlock.getOrigBlock() and
      phiBlock = readBlock.getPhiBlock()
    )
  }

  predicate phiInput(SsaReadPosition pos, SsaVariable phi, SsaVariable input) {
    pos.(SsaRead::SsaReadPositionPhiInputEdge).phiInput(phi, input)
  }

  class Bound instanceof JBound::Bound {
    final string toString() { result = super.toString() }

    final Location getLocation() { result = super.getExpr().getLocation() }
  }

  predicate zeroBound(Bound bound) { bound instanceof JBound::ZeroBound }

  predicate ssaBound(Bound bound, SsaVariable v) { v = bound.(JBound::SsaBound).getSsa() }

  Expr getBoundExpr(Bound bound, int delta) {
    result = getResultExpr(bound.(JBound::Bound).getExpr(delta))
  }

  class Guard instanceof JGuards::Guard {
    final string toString() { result = super.toString() }

    final Location getLocation() { result = super.getLocation() }
  }

  predicate guard(Guard guard, BasicBlock block) { block = guard.(JGuards::Guard).getBasicBlock() }

  Expr getGuardAsExpr(Guard guard) { result = getResultExpr(guard.(J::Expr)) }

  predicate equalityGuard(Guard guard, Expr e1, Expr e2, boolean polarity) {
    guard.(JGuards::Guard).isEquality(getJavaExpr(e1), getJavaExpr(e2), polarity)
  }

  predicate guardDirectlyControlsBlock(Guard guard, BasicBlock controlled, boolean branch) {
    guard.(JGuards::Guard).directlyControls(controlled, branch)
  }

  predicate guardHasBranchEdge(Guard guard, BasicBlock bb1, BasicBlock bb2, boolean branch) {
    guard.(JGuards::Guard).hasBranchEdge(bb1, bb2, branch)
  }

  Guard comparisonGuard(Expr e) { result = getJavaExpr(e).(J::ComparisonExpr) }

  predicate implies_v2(Guard g1, boolean b1, Guard g2, boolean b2) {
    JGuardsLogic::implies_v2(g1, b1, g2, b2)
  }
}

private import Impl

SemExpr getSemanticExpr(J::Expr javaExpr) { result = TPrimaryExpr(javaExpr) }

J::Expr getJavaExpr(SemExpr e) { e = getSemanticExpr(result) }

SemExpr getEnhancedForInitExpr(J::EnhancedForStmt for) { result = TEnhancedForInit(for) }

SemBasicBlock getSemanticBasicBlock(J::BasicBlock block) { result = block }

J::BasicBlock getJavaBasicBlock(SemBasicBlock block) { block = getSemanticBasicBlock(result) }

SemSsaVariable getSemanticSsaVariable(SSA::SsaVariable v) { result = v }

SSA::SsaVariable getJavaSsaVariable(SemSsaVariable v) { v = getSemanticSsaVariable(result) }

SemSsaReadPosition getSemanticSsaReadPosition(SsaRead::SsaReadPosition pos) { result = pos }

SemBound getSemanticBound(JBound::Bound bound) { result = bound }

JBound::Bound getJavaBound(SemBound bound) { bound = getSemanticBound(result) }

SemGuard getSemanticGuard(JGuards::Guard guard) { result = guard }

JGuards::Guard getJavaGuard(SemGuard guard) { guard = getSemanticGuard(result) }
