private import java as J
private import SemanticCFG
private import SemanticExpr
private import SemanticCFGSpecific
private import SemanticSSA
private import SemanticType
private import semmle.code.java.dataflow.SSA as SSA

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

  class Expr extends TExpr {
    string toString() { none() }

    J::Location getLocation() { none() }

    J::BasicBlock getBasicBlock() { none() }
  }

  private class PrimaryExpr extends Expr, TPrimaryExpr {
    J::Expr e;

    PrimaryExpr() { this = TPrimaryExpr(e) }

    override string toString() { result = e.toString() }

    override J::Location getLocation() { result = e.getLocation() }

    override J::BasicBlock getBasicBlock() { result = e.getBasicBlock() }

    J::Expr getExpr() { result = e }
  }

  private class PostUpdateExpr extends Expr, TPostUpdateExpr {
    J::UnaryAssignExpr e;

    PostUpdateExpr() { this = TPostUpdateExpr(e) }

    override string toString() { result = "post-update for " + e.toString() }

    override J::Location getLocation() { result = e.getLocation() }

    override J::BasicBlock getBasicBlock() { result = e.getBasicBlock() }

    J::UnaryAssignExpr getExpr() { result = e }
  }

  private class EnhancedForInitExpr extends Expr, TEnhancedForInit {
    J::EnhancedForStmt for;

    EnhancedForInitExpr() { this = TEnhancedForInit(for) }

    override string toString() { result = "init of " + for.getVariable().toString() }

    override J::Location getLocation() { result = for.getVariable().getLocation() }

    override J::BasicBlock getBasicBlock() { result = for.getVariable().getBasicBlock() }
  }

  private class ParameterInitExpr extends Expr, TParameterInit {
    SSA::SsaImplicitInit init;
    J::Parameter param;

    ParameterInitExpr() { this = TParameterInit(init, param) }

    override string toString() { result = "param init: " + init.toString() }

    override J::Location getLocation() { result = init.getLocation() }

    override J::BasicBlock getBasicBlock() { result = init.getBasicBlock() }

    final J::Parameter getParameter() { result = param }
  }

  string exprToString(Expr e) { result = e.toString() }

  J::Location getExprLocation(Expr e) { result = e.getLocation() }

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

  predicate unaryExpr(Expr expr, Opcode opcode, SemType type, Expr operand) {
    exists(J::Expr javaExpr | expr = TPrimaryExpr(javaExpr) |
      type = getSemanticType(javaExpr.getType()) and
      (
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
          type instanceof SemNumericType and
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
      )
    )
    or
    exists(J::UnaryAssignExpr javaExpr | javaExpr = expr.(PostUpdateExpr).getExpr() |
      type = getSemanticType(javaExpr.getType()) and
      operand = getResultExpr(javaExpr.getExpr()) and
      (
        javaExpr instanceof J::PostIncExpr and opcode instanceof Opcode::AddOne
        or
        javaExpr instanceof J::PostDecExpr and opcode instanceof Opcode::SubOne
      )
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
}

private import Impl

SemExpr getSemanticExpr(J::Expr javaExpr) { result = TPrimaryExpr(javaExpr) }

J::Expr getJavaExpr(SemExpr e) { e = getSemanticExpr(result) }

SemExpr getUpdateExpr(SSA::SsaExplicitUpdate update) {
  exists(J::Expr expr | expr = update.getDefiningExpr() |
    (
      expr instanceof J::Assignment or
      expr instanceof J::PreIncExpr or
      expr instanceof J::PreDecExpr
    ) and
    result = getResultExpr(expr)
    or
    result = getResultExpr(expr.(J::LocalVariableDeclExpr).getInit())
    or
    (expr instanceof J::PostIncExpr or expr instanceof J::PostDecExpr) and
    result = TPostUpdateExpr(expr)
    or
    exists(J::EnhancedForStmt for |
      for.getVariable() = expr and
      result = TEnhancedForInit(for)
    )
  )
}

SemExpr getEnhancedForInitExpr(J::EnhancedForStmt for) { result = TEnhancedForInit(for) }
