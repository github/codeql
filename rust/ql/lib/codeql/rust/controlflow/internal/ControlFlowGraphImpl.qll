private import rust as Rust
private import codeql.Locations
private import codeql.controlflow.ControlFlowGraph
private import codeql.controlflow.SuccessorType
private import codeql.rust.controlflow.internal.Scope as Scope
private import codeql.rust.elements.internal.VariableImpl::Impl as VariableImpl

private module Cfg0 = Make0<Location, Ast>;

private module Cfg1 = Make1<Input>;

private module Cfg2 = Make2<Input>;

private import Cfg0
private import Cfg1
private import Cfg2
import Public

class CfgScope = Ast::Callable;

/**
 * Provides an implementation of the shared control-flow AST signature for Rust.
 */
private module Ast implements AstSig<Location> {
  class AstNode = Rust::AstNode;

  private Rust::AstNode runtimeChild(Rust::AstNode parent, int index) {
    index = 0 and
    result = parent.(Rust::Param).getPat()
    or
    index = 0 and
    result = parent.(Rust::SelfParam).getName()
    or
    index = 0 and
    result = parent.(Rust::ExprStmt).getExpr()
    or
    index = 0 and result = parent.(Rust::LetStmt).getInitializer()
    or
    index = 1 and result = parent.(Rust::LetStmt).getPat()
    or
    index = 2 and result = parent.(Rust::LetStmt).getLetElse().getBlockExpr()
    or
    parent instanceof Rust::MacroCall and
    not parent.getParentNode() instanceof Rust::MacroPat and
    index = 0 and
    result = parent.(Rust::MacroCall).getMacroCallExpansion()
    or
    not parent.(Rust::BlockExpr).isAsync() and
    result = parent.(Rust::BlockExpr).getStmtList().getStmtOrExpr(index) and
    not result instanceof Rust::Const and
    not result instanceof Rust::Static
    or
    parent.getParentNode() instanceof Rust::AsyncBlockExpr and
    result = parent.(Rust::StmtList).getStmtOrExpr(index) and
    not result instanceof Rust::Const and
    not result instanceof Rust::Static
    or
    result = parent.(Rust::ArrayExpr).getExpr(index)
    or
    index = 0 and
    result = parent.(Rust::AwaitExpr).getExpr()
    or
    index = 0 and
    result = parent.(Rust::BecomeExpr).getExpr()
    or
    index = 0 and
    result = parent.(Rust::BreakExpr).getExpr()
    or
    index = 0 and result = parent.(Rust::CallExpr).getFunction()
    or
    result = parent.(Rust::CallExpr).getSyntacticPositionalArgument(index - 1)
    or
    not parent instanceof Rust::CallExpr and
    (
      index = 0 and result = parent.(Rust::InvocationExpr).getSyntacticReceiver()
      or
      result = parent.(Rust::InvocationExpr).getSyntacticPositionalArgument(index - 1)
    )
    or
    index = 0 and
    result = parent.(Rust::CastExpr).getExpr()
    or
    index = 0 and
    result = parent.(Rust::FieldExpr).getContainer()
    or
    index = 0 and result = parent.(Rust::IfExpr).getCondition()
    or
    index = 1 and result = parent.(Rust::IfExpr).getThen()
    or
    index = 2 and result = parent.(Rust::IfExpr).getElse()
    or
    index = -1 and result = parent.(Rust::FormatArgsExpr).getTemplate()
    or
    result = parent.(Rust::FormatArgsExpr).getArg(index).getExpr()
    or
    result =
      any(Rust::FormatTemplateVariableAccess v, Rust::Format f, int i, int kind |
        f = parent.(Rust::FormatArgsExpr).getFormat(i) and
        (
          v.getArgument() = f.getArgumentRef() and kind = 0
          or
          v.getArgument() = f.getWidthArgument() and kind = 1
          or
          v.getArgument() = f.getPrecisionArgument() and kind = 2
        ) and
        index = parent.(Rust::FormatArgsExpr).getNumberOfArgs() + i * 3 + kind
      |
        v
      )
    or
    index = 0 and result = parent.(Rust::LetExpr).getScrutinee()
    or
    index = 1 and result = parent.(Rust::LetExpr).getPat()
    or
    index = 0 and
    result = parent.(Rust::LoopExpr).getLoopBody()
    or
    index = 0 and result = parent.(Rust::WhileExpr).getCondition()
    or
    index = 1 and result = parent.(Rust::WhileExpr).getLoopBody()
    or
    index = 0 and result = parent.(Rust::ForExpr).getIterable()
    or
    index = 1 and result = parent.(Rust::ForExpr).getPat()
    or
    index = 2 and result = parent.(Rust::ForExpr).getLoopBody()
    or
    index = 0 and
    result = parent.(Rust::MacroExpr).getMacroCall()
    or
    index = 0 and result = parent.(Rust::MatchExpr).getScrutinee()
    or
    exists(int i |
      index = 3 * i + 1 and result = parent.(Rust::MatchExpr).getArm(i).getPat()
      or
      index = 3 * i + 2 and
      result = parent.(Rust::MatchExpr).getArm(i).getGuard().getCondition()
      or
      index = 3 * i + 3 and result = parent.(Rust::MatchExpr).getArm(i).getExpr()
    )
    or
    index = 0 and result = parent.(Rust::RangeExpr).getStart()
    or
    index = 1 and result = parent.(Rust::RangeExpr).getEnd()
    or
    result = parent.(Rust::StructExpr).getStructExprFieldList().getField(index).getExpr()
    or
    index = 0 and
    result = parent.(Rust::ReturnExpr).getExpr()
    or
    index = 0 and
    result = parent.(Rust::TryExpr).getExpr()
    or
    result = parent.(Rust::TupleExpr).getField(index)
    or
    index = 0 and
    result = parent.(Rust::YieldExpr).getExpr()
    or
    index = 0 and
    result = parent.(Rust::YeetExpr).getExpr()
    or
    index = 0 and result = parent.(Rust::IdentPat).getPat()
    or
    index = 1 and result = parent.(Rust::IdentPat).getName()
    or
    index = 0 and
    result = parent.(Rust::BoxPat).getPat()
    or
    index = 0 and
    result = parent.(Rust::DerefPat).getPat()
    or
    index = 0 and
    result = parent.(Rust::LiteralPat).getLiteral()
    or
    index = 0 and
    result = parent.(Rust::MacroPat).getMacroCall().getMacroCallExpansion()
    or
    result = parent.(Rust::OrPat).getPat(index)
    or
    index = 0 and result = parent.(Rust::RangePat).getStart()
    or
    index = 1 and result = parent.(Rust::RangePat).getEnd()
    or
    result = parent.(Rust::StructPat).getStructPatFieldList().getField(index).getPat()
    or
    index = parent.(Rust::StructPat).getStructPatFieldList().getNumberOfFields() and
    result = parent.(Rust::StructPat).getStructPatFieldList().getRestPat()
    or
    index = 0 and
    result = parent.(Rust::RefPat).getPat()
    or
    result = parent.(Rust::SlicePat).getPat(index)
    or
    result = parent.(Rust::TuplePat).getField(index)
    or
    result = parent.(Rust::TupleStructPat).getField(index)
  }

  AstNode getChild(AstNode parent, int index) { result = runtimeChild(parent, index) }

  private Callable getEnclosingCallableImpl(Rust::AstNode node) {
    exists(Rust::AstNode parent | parent = node.getParentNode() |
      result = parent
      or
      not parent instanceof Scope::CfgScope and
      not node instanceof Rust::Const and
      not node instanceof Rust::Static and
      result = getEnclosingCallableImpl(parent)
    )
    or
    (
      node instanceof Rust::Const or
      node instanceof Rust::Static
    ) and
    result.(Rust::SourceFile).getFile() = node.getFile()
  }

  Callable getEnclosingCallable(AstNode node) { result = getEnclosingCallableImpl(node) }

  class Callable extends AstNode instanceof Scope::CfgScope { }

  AstNode callableGetBody(Callable c) {
    result = c.(Rust::Callable).getBody()
    or
    result = c.(Rust::AsyncBlockExpr).getStmtList()
  }

  class Parameter extends AstNode instanceof Rust::ParamBase {
    AstNode getPattern() {
      result = this.(Rust::Param).getPat()
      or
      not this instanceof Rust::Param and
      result = this
    }

    Expr getDefaultValue() { none() }
  }

  Parameter callableGetParameter(Callable c, int index) {
    index = 0 and
    result = c.(Rust::Callable).getSelfParam()
    or
    result = c.(Rust::Callable).getParam(index - 1)
  }

  class Stmt extends AstNode {
    Stmt() {
      this instanceof Rust::Stmt
      or
      this instanceof Rust::Expr
      or
      this instanceof Rust::StmtList
    }
  }

  class LabeledStmt extends Stmt instanceof Rust::LabelableExpr {
    Stmt getStmt() { result = this }
  }

  class Expr extends AstNode {
    Expr() {
      this instanceof Rust::Expr
      or
      this instanceof Rust::Pat
    }
  }

  class BlockStmt extends Stmt {
    BlockStmt() {
      this instanceof Rust::BlockExpr and
      not this.(Rust::BlockExpr).isAsync()
      or
      this instanceof Rust::StmtList and
      this.getParentNode() instanceof Rust::AsyncBlockExpr
    }

    Stmt getStmt(int n) {
      result = this.(Rust::BlockExpr).getStmtList().getStmtOrExpr(n)
      or
      result = this.(Rust::StmtList).getStmtOrExpr(n)
    }

    Stmt getLastStmt() {
      result = this.(Rust::BlockExpr).getStmtList().getTailExpr()
      or
      result = this.(Rust::StmtList).getTailExpr()
    }
  }

  class ExprStmt extends Stmt instanceof Rust::ExprStmt {
    Expr getExpr() { result = Rust::ExprStmt.super.getExpr() }
  }

  class IfStmt extends Stmt {
    IfStmt() { none() }

    Expr getCondition() { none() }

    Stmt getThen() { none() }

    Stmt getElse() { none() }
  }

  class LoopStmt extends Stmt instanceof Rust::LoopingExpr {
    Stmt getBody() { result = super.getLoopBody() }
  }

  class WhileStmt extends LoopStmt instanceof Rust::WhileExpr {
    Expr getCondition() { result = super.getCondition() }
  }

  class DoStmt extends LoopStmt {
    DoStmt() { none() }

    Expr getCondition() { none() }
  }

  class UntilStmt extends LoopStmt {
    UntilStmt() { none() }

    Expr getCondition() { none() }
  }

  class ForStmt extends LoopStmt {
    ForStmt() { none() }

    AstNode getInit(int index) { none() }

    Expr getCondition() { none() }

    AstNode getUpdate(int index) { none() }
  }

  class ForEachStmt extends LoopStmt instanceof Rust::ForExpr {
    Expr getVariable() { result = super.getPat() }

    Expr getCollection() { result = super.getIterable() }
  }

  class BreakStmt extends Stmt instanceof Rust::BreakExpr { }

  class ContinueStmt extends Stmt instanceof Rust::ContinueExpr { }

  class GotoStmt extends Stmt {
    GotoStmt() { none() }
  }

  class ReturnStmt extends Stmt instanceof Rust::ReturnExpr {
    Expr getExpr() { result = super.getExpr() }
  }

  class Throw extends AstNode {
    Throw() { none() }

    Expr getExpr() { none() }
  }

  class TryStmt extends Stmt {
    TryStmt() { none() }

    AstNode getBody(int index) { none() }

    CatchClause getCatch(int index) { none() }

    Stmt getFinally() { none() }
  }

  class CatchClause extends AstNode {
    CatchClause() { none() }

    AstNode getPattern() { none() }

    AstNode getVariable() { none() }

    Expr getCondition() { none() }

    Stmt getBody() { none() }
  }

  class Switch extends AstNode instanceof Rust::MatchExpr {
    Switch() { exists(super.getAnArm()) }

    Expr getExpr() { result = super.getScrutinee() }

    Case getCase(int index) { result = super.getArm(index) }

    Stmt getStmt(int index) { none() }
  }

  class Case extends AstNode instanceof Rust::MatchArm {
    AstNode getPattern(int index) {
      result = super.getPat() and
      index = 0
    }

    Expr getGuard() { result = super.getGuard().getCondition() }

    AstNode getBody() { result = super.getExpr() }
  }

  class DefaultCase extends Case {
    DefaultCase() { none() }
  }

  class ConditionalExpr extends Expr instanceof Rust::IfExpr {
    Expr getCondition() { result = this.(Rust::IfExpr).getCondition() }

    Expr getThen() { result = this.(Rust::IfExpr).getThen() }

    Expr getElse() { result = this.(Rust::IfExpr).getElse() }
  }

  class BinaryExpr extends Expr instanceof Rust::BinaryExpr {
    Expr getLeftOperand() { result = this.(Rust::BinaryExpr).getLhs() }

    Expr getRightOperand() { result = this.(Rust::BinaryExpr).getRhs() }
  }

  class LogicalAndExpr extends BinaryExpr instanceof Rust::LogicalAndExpr { }

  class LogicalOrExpr extends BinaryExpr instanceof Rust::LogicalOrExpr { }

  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { none() }
  }

  class UnaryExpr extends Expr instanceof Rust::PrefixExpr {
    Expr getOperand() { result = this.(Rust::PrefixExpr).getExpr() }
  }

  class LogicalNotExpr extends UnaryExpr instanceof Rust::LogicalNotExpr { }

  class Assignment extends BinaryExpr instanceof Rust::AssignmentOperation { }

  class AssignExpr extends Assignment instanceof Rust::AssignmentExpr { }

  class CompoundAssignment extends Assignment instanceof Rust::CompoundAssignmentExpr { }

  class AssignLogicalAndExpr extends CompoundAssignment {
    AssignLogicalAndExpr() { none() }
  }

  class AssignLogicalOrExpr extends CompoundAssignment {
    AssignLogicalOrExpr() { none() }
  }

  class AssignNullCoalescingExpr extends CompoundAssignment {
    AssignNullCoalescingExpr() { none() }
  }

  class BooleanLiteral extends Expr instanceof Rust::BooleanLiteralExpr {
    boolean getValue() {
      super.getTextValue() = "true" and result = true
      or
      super.getTextValue() = "false" and result = false
    }
  }

  class PatternMatchExpr extends Expr {
    PatternMatchExpr() { none() }

    Expr getExpr() { none() }

    AstNode getPattern() { none() }
  }
}

/**
 * Holds if `pat` cannot itself cause a match failure.
 */
private predicate cannotCauseMatchFailure(Rust::Pat pat) {
  pat instanceof Rust::RangePat
  or
  pat =
    any(Rust::IdentPat p |
      p.hasPat() or
      VariableImpl::variableDecl(_, p.getName(), _)
    )
  or
  pat instanceof Rust::WildcardPat
  or
  pat instanceof Rust::RestPat
  or
  pat instanceof Rust::RefPat
  or
  pat instanceof Rust::TuplePat
  or
  pat instanceof Rust::MacroPat
}

/**
 * Holds if `pat` is guaranteed to match at its position in the AST.
 */
private predicate guaranteedMatchPosition(Rust::Pat pat) {
  pat = any(Rust::LetStmt let | not let.hasLetElse()).getPat()
  or
  pat = any(Rust::ForExpr for).getPat()
  or
  pat = any(Rust::Param p).getPat()
  or
  exists(Rust::Pat parent | guaranteedMatchPosition(parent) |
    parent = pat.getParentPat() and not parent instanceof Rust::OrPat
    or
    parent.(Rust::OrPat).getLastPat() = pat
    or
    parent.(Rust::MacroPat).getMacroCall().getMacroCallExpansion() = pat
  )
}

private predicate guaranteedMatch(Rust::Pat pat) {
  cannotCauseMatchFailure(pat) or guaranteedMatchPosition(pat)
}

private module Input implements InputSig1, InputSig2 {
  private import codeql.util.Void

  predicate cfgCachedStageRef() { CfgCachedStage::ref() }

  class Label = string;

  predicate hasLabel(Ast::AstNode n, Label l) {
    l = n.(Rust::BreakExpr).getLifetime().getText()
    or
    l = n.(Rust::ContinueExpr).getLifetime().getText()
    or
    l = n.(Rust::LabelableExpr).getLabel().getLifetime().getText()
  }

  class CallableContext = Void;

  predicate isExhaustive(Ast::Switch switch) { any() }

  predicate inConditionalContext(Ast::AstNode n, ConditionKind kind) {
    kind.isMatching() and
    (
      n instanceof Rust::Pat
      or
      n = any(Rust::TryExpr e).getExpr()
    )
  }

  predicate preOrderExpr(Ast::Expr e) {
    e instanceof Rust::LetExpr
    or
    e instanceof Rust::TryExpr
    or
    e instanceof Rust::Pat and
    not e instanceof Rust::IdentPat and
    not e instanceof Rust::LiteralPat
  }

  predicate postOrInOrder(Ast::AstNode n) { n instanceof Rust::MacroCall }

  private string tryReturnTag() { result = "[try-return]" }

  private string patternStartTag() { result = "[pattern-start]" }

  private string emptyMatchTag() { result = "[empty-match]" }

  private string letElseDivergeTag() { result = "[let-else-diverge]" }

  predicate additionalNode(Ast::AstNode n, string tag, NormalSuccessor t) {
    (
      t instanceof DirectSuccessor and
      (
        n instanceof Rust::TryExpr and tag = tryReturnTag()
        or
        n instanceof Rust::MatchExpr and
        not exists(n.(Rust::MatchExpr).getAnArm()) and
        tag = emptyMatchTag()
        or
        n = any(Rust::LetStmt let).getLetElse().getBlockExpr() and
        tag = letElseDivergeTag()
      )
      or
      n instanceof Rust::Pat and
      not n instanceof Rust::OrPat and
      exists(getPatternChild(n, _)) and
      tag = patternStartTag() and
      t.(MatchingSuccessor).getValue() = true
    )
  }

  private Rust::Pat getPatternChild(Rust::Pat parent, int index) {
    index = 0 and
    result = parent.(Rust::BoxPat).getPat()
    or
    index = 0 and
    result = parent.(Rust::DerefPat).getPat()
    or
    index = 0 and
    result = parent.(Rust::MacroPat).getMacroCall().getMacroCallExpansion()
    or
    result = parent.(Rust::OrPat).getPat(index)
    or
    index = 0 and result = parent.(Rust::RangePat).getStart()
    or
    index = 1 and result = parent.(Rust::RangePat).getEnd()
    or
    result = parent.(Rust::StructPat).getStructPatFieldList().getField(index).getPat()
    or
    index = parent.(Rust::StructPat).getStructPatFieldList().getNumberOfFields() and
    result = parent.(Rust::StructPat).getStructPatFieldList().getRestPat()
    or
    index = 0 and
    result = parent.(Rust::RefPat).getPat()
    or
    result = parent.(Rust::SlicePat).getPat(index)
    or
    result = parent.(Rust::TuplePat).getField(index)
    or
    result = parent.(Rust::TupleStructPat).getField(index)
  }

  private Rust::Pat getRankedPatternChild(Rust::Pat parent, int childRank) {
    result =
      rank[childRank](Rust::Pat child, int index |
        child = getPatternChild(parent, index)
      |
        child order by index
      )
  }

  private predicate isAfterMatch(PreControlFlowNode n, Rust::AstNode ast, boolean value) {
    n.isAfterValue(ast, any(MatchingSuccessor t | t.getValue() = value))
  }

  private predicate letStmtStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::LetStmt let |
      n1.isBefore(let) and
      (
        n2.isBefore(let.getInitializer())
        or
        not let.hasInitializer() and n2.isBefore(let.getPat())
      )
      or
      n1.isAfter(let.getInitializer()) and
      n2.isBefore(let.getPat())
      or
      isAfterMatch(n1, let.getPat(), true) and n2.isAfter(let)
      or
      isAfterMatch(n1, let.getPat(), false) and
      n2.isBefore(let.getLetElse().getBlockExpr())
      or
      n1.isAfter(let.getLetElse().getBlockExpr()) and
      n2.isAdditional(let.getLetElse().getBlockExpr(), letElseDivergeTag())
    )
  }

  private predicate letExprStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::LetExpr let |
      n1.isBefore(let) and n2.isBefore(let.getScrutinee())
      or
      n1.isAfter(let.getScrutinee()) and
      n2.isBefore(let.getPat())
      or
      isAfterMatch(n1, let.getPat(), true) and n2.isAfterTrue(let)
      or
      isAfterMatch(n1, let.getPat(), false) and n2.isAfterFalse(let)
    )
  }

  private predicate emptyMatchStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::MatchExpr match |
      not exists(match.getAnArm()) and
      (
        n1.isBefore(match) and n2.isBefore(match.getScrutinee())
        or
        n1.isAfter(match.getScrutinee()) and
        n2.isAdditional(match, emptyMatchTag())
      )
    )
  }

  private predicate genericPatternStep(Rust::Pat pat, PreControlFlowNode n1, PreControlFlowNode n2) {
    not pat instanceof Rust::IdentPat and
    not pat instanceof Rust::LiteralPat and
    not pat instanceof Rust::OrPat and
    (
      n1.isBefore(pat) and
      (
        exists(getRankedPatternChild(pat, _)) and
        n2.isAdditional(pat, patternStartTag())
        or
        not exists(getRankedPatternChild(pat, _)) and isAfterMatch(n2, pat, true)
        or
        not guaranteedMatch(pat) and isAfterMatch(n2, pat, false)
      )
      or
      n1.isAdditional(pat, patternStartTag()) and
      n2.isBefore(getRankedPatternChild(pat, 1))
      or
      exists(int i, Rust::Pat child | child = getRankedPatternChild(pat, i) |
        isAfterMatch(n1, child, true) and
        (
          n2.isBefore(getRankedPatternChild(pat, i + 1))
          or
          not exists(getRankedPatternChild(pat, i + 1)) and
          isAfterMatch(n2, pat, true)
        )
        or
        isAfterMatch(n1, child, false) and isAfterMatch(n2, pat, false)
      )
    )
  }

  private predicate literalPatternStep(
    Rust::LiteralPat pat, PreControlFlowNode n1, PreControlFlowNode n2
  ) {
    n1.isBefore(pat) and n2.isBefore(pat.getLiteral())
    or
    n1.isAfter(pat.getLiteral()) and n2.isIn(pat)
    or
    n1.isIn(pat) and isAfterMatch(n2, pat, true)
    or
    n1.isIn(pat) and not guaranteedMatch(pat) and isAfterMatch(n2, pat, false)
  }

  private predicate identPatternStep(
    Rust::IdentPat pat, PreControlFlowNode n1, PreControlFlowNode n2
  ) {
    n1.isBefore(pat) and
    (
      n2.isBefore(pat.getPat())
      or
      not pat.hasPat() and n2.isBefore(pat.getName())
    )
    or
    isAfterMatch(n1, pat.getPat(), true) and n2.isBefore(pat.getName())
    or
    isAfterMatch(n1, pat.getPat(), false) and isAfterMatch(n2, pat, false)
    or
    n1.isAfter(pat.getName()) and n2.isIn(pat)
    or
    n1.isIn(pat) and isAfterMatch(n2, pat, true)
    or
    n1.isIn(pat) and not guaranteedMatch(pat) and isAfterMatch(n2, pat, false)
  }

  private predicate orPatternStep(Rust::OrPat pat, PreControlFlowNode n1, PreControlFlowNode n2) {
    n1.isBefore(pat) and n2.isBefore(getRankedPatternChild(pat, 1))
    or
    exists(int i, Rust::Pat child | child = getRankedPatternChild(pat, i) |
      isAfterMatch(n1, child, true) and isAfterMatch(n2, pat, true)
      or
      isAfterMatch(n1, child, false) and
      (
        n2.isBefore(getRankedPatternChild(pat, i + 1))
        or
        not exists(getRankedPatternChild(pat, i + 1)) and
        not guaranteedMatch(pat) and
        isAfterMatch(n2, pat, false)
      )
    )
  }

  private predicate patternStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::Pat pat |
      genericPatternStep(pat, n1, n2)
      or
      literalPatternStep(pat, n1, n2)
      or
      identPatternStep(pat, n1, n2)
      or
      orPatternStep(pat, n1, n2)
    )
  }

  private string loopHeaderTag() { result = "[LoopHeader]" }

  private predicate loopStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::LoopExpr loop |
      n1.isBefore(loop) and n2.isBefore(loop.getLoopBody())
      or
      n1.isAfter(loop.getLoopBody()) and
      n2.isAdditional(loop, loopHeaderTag())
      or
      n1.isAdditional(loop, loopHeaderTag()) and
      n2.isBefore(loop.getLoopBody())
    )
  }

  private predicate tryStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::TryExpr try |
      n1.isBefore(try) and n2.isBefore(try.getExpr())
      or
      isAfterMatch(n1, try.getExpr(), true) and n2.isAfter(try)
      or
      isAfterMatch(n1, try.getExpr(), false) and
      n2.isAdditional(try, tryReturnTag())
    )
  }

  predicate beginAbruptCompletion(
    Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    ast instanceof Rust::TryExpr and
    n.isAdditional(ast, tryReturnTag()) and
    c.asSimpleAbruptCompletion() instanceof ReturnSuccessor and
    always = true
    or
    ast instanceof Rust::MatchExpr and
    n.isAdditional(ast, emptyMatchTag()) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = true
    or
    ast = any(Rust::LetStmt let).getLetElse().getBlockExpr() and
    n.isAdditional(ast, letElseDivergeTag()) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = true
  }

  predicate endAbruptCompletion(Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
    none()
  }

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
    letStmtStep(n1, n2)
    or
    letExprStep(n1, n2)
    or
    emptyMatchStep(n1, n2)
    or
    patternStep(n1, n2)
    or
    loopStep(n1, n2)
    or
    tryStep(n1, n2)
  }
}
