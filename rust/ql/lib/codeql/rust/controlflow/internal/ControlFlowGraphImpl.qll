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
  /**
   * Removes transparent parenthesized AST nodes.
   */
  additional AstNode desugar(Rust::AstNode n) {
    result = desugar(n.(Rust::ParenExpr).getExpr())
    or
    result = desugar(n.(Rust::ParenPat).getPat())
    or
    not n instanceof Rust::ParenExpr and
    not n instanceof Rust::ParenPat and
    result = n
  }

  class AstNode extends Rust::AstNode {
    AstNode() {
      not this instanceof Rust::ParenExpr and
      not this instanceof Rust::ParenPat
    }
  }

  private Rust::AstNode runtimeChild(Rust::AstNode parent, int index) {
    parent instanceof Rust::Param and
    index = 0 and
    result = parent.(Rust::Param).getPat()
    or
    parent instanceof Rust::SelfParam and
    index = 0 and
    result = parent.(Rust::SelfParam).getName()
    or
    parent instanceof Rust::ExprStmt and
    index = 0 and
    result = parent.(Rust::ExprStmt).getExpr()
    or
    parent instanceof Rust::LetStmt and
    (
      index = 0 and result = parent.(Rust::LetStmt).getInitializer()
      or
      index = 1 and result = parent.(Rust::LetStmt).getPat()
      or
      index = 2 and result = parent.(Rust::LetStmt).getLetElse().getBlockExpr()
    )
    or
    parent instanceof Rust::MacroCall and
    not parent.getParentNode() instanceof Rust::MacroPat and
    index = 0 and
    result = parent.(Rust::MacroCall).getMacroCallExpansion()
    or
    parent instanceof Rust::BlockExpr and
    not parent.(Rust::BlockExpr).isAsync() and
    result = parent.(Rust::BlockExpr).getStmtList().getStmtOrExpr(index) and
    not result instanceof Rust::Const and
    not result instanceof Rust::Static
    or
    parent instanceof Rust::StmtList and
    parent.getParentNode() instanceof Rust::AsyncBlockExpr and
    result = parent.(Rust::StmtList).getStmtOrExpr(index) and
    not result instanceof Rust::Const and
    not result instanceof Rust::Static
    or
    parent instanceof Rust::ArrayExpr and
    result = parent.(Rust::ArrayExpr).getExpr(index)
    or
    parent instanceof Rust::AwaitExpr and
    index = 0 and
    result = parent.(Rust::AwaitExpr).getExpr()
    or
    parent instanceof Rust::BecomeExpr and
    index = 0 and
    result = parent.(Rust::BecomeExpr).getExpr()
    or
    parent instanceof Rust::BreakExpr and
    index = 0 and
    result = parent.(Rust::BreakExpr).getExpr()
    or
    parent instanceof Rust::CallExpr and
    (
      index = 0 and result = parent.(Rust::CallExpr).getFunction()
      or
      result = parent.(Rust::CallExpr).getSyntacticPositionalArgument(index - 1)
    )
    or
    parent instanceof Rust::InvocationExpr and
    not parent instanceof Rust::CallExpr and
    (
      index = 0 and result = parent.(Rust::InvocationExpr).getSyntacticReceiver()
      or
      result = parent.(Rust::InvocationExpr).getSyntacticPositionalArgument(index - 1)
    )
    or
    parent instanceof Rust::CastExpr and
    index = 0 and
    result = parent.(Rust::CastExpr).getExpr()
    or
    parent instanceof Rust::FieldExpr and
    index = 0 and
    result = parent.(Rust::FieldExpr).getContainer()
    or
    parent instanceof Rust::IfExpr and
    (
      index = 0 and result = parent.(Rust::IfExpr).getCondition()
      or
      index = 1 and result = parent.(Rust::IfExpr).getThen()
      or
      index = 2 and result = parent.(Rust::IfExpr).getElse()
    )
    or
    parent instanceof Rust::FormatArgsExpr and
    (
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
    )
    or
    parent instanceof Rust::LetExpr and
    (
      index = 0 and result = parent.(Rust::LetExpr).getScrutinee()
      or
      index = 1 and result = parent.(Rust::LetExpr).getPat()
    )
    or
    parent instanceof Rust::LoopExpr and
    index = 0 and
    result = parent.(Rust::LoopExpr).getLoopBody()
    or
    parent instanceof Rust::WhileExpr and
    (
      index = 0 and result = parent.(Rust::WhileExpr).getCondition()
      or
      index = 1 and result = parent.(Rust::WhileExpr).getLoopBody()
    )
    or
    parent instanceof Rust::ForExpr and
    (
      index = 0 and result = parent.(Rust::ForExpr).getIterable()
      or
      index = 1 and result = parent.(Rust::ForExpr).getPat()
      or
      index = 2 and result = parent.(Rust::ForExpr).getLoopBody()
    )
    or
    parent instanceof Rust::MacroExpr and
    index = 0 and
    result = parent.(Rust::MacroExpr).getMacroCall()
    or
    parent instanceof Rust::MatchExpr and
    (
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
    )
    or
    parent instanceof Rust::RangeExpr and
    (
      index = 0 and result = parent.(Rust::RangeExpr).getStart()
      or
      index = 1 and result = parent.(Rust::RangeExpr).getEnd()
    )
    or
    parent instanceof Rust::StructExpr and
    result = parent.(Rust::StructExpr).getStructExprFieldList().getField(index).getExpr()
    or
    parent instanceof Rust::ReturnExpr and
    index = 0 and
    result = parent.(Rust::ReturnExpr).getExpr()
    or
    parent instanceof Rust::TryExpr and
    index = 0 and
    result = parent.(Rust::TryExpr).getExpr()
    or
    parent instanceof Rust::TupleExpr and
    result = parent.(Rust::TupleExpr).getField(index)
    or
    parent instanceof Rust::YieldExpr and
    index = 0 and
    result = parent.(Rust::YieldExpr).getExpr()
    or
    parent instanceof Rust::YeetExpr and
    index = 0 and
    result = parent.(Rust::YeetExpr).getExpr()
    or
    parent instanceof Rust::IdentPat and
    (
      index = 0 and result = parent.(Rust::IdentPat).getPat()
      or
      index = 1 and result = parent.(Rust::IdentPat).getName()
    )
    or
    parent instanceof Rust::BoxPat and
    index = 0 and
    result = parent.(Rust::BoxPat).getPat()
    or
    parent instanceof Rust::DerefPat and
    index = 0 and
    result = parent.(Rust::DerefPat).getPat()
    or
    parent instanceof Rust::LiteralPat and
    index = 0 and
    result = parent.(Rust::LiteralPat).getLiteral()
    or
    parent instanceof Rust::MacroPat and
    index = 0 and
    result = parent.(Rust::MacroPat).getMacroCall().getMacroCallExpansion()
    or
    parent instanceof Rust::OrPat and
    result = parent.(Rust::OrPat).getPat(index)
    or
    parent instanceof Rust::RangePat and
    (
      index = 0 and result = parent.(Rust::RangePat).getStart()
      or
      index = 1 and result = parent.(Rust::RangePat).getEnd()
    )
    or
    parent instanceof Rust::StructPat and
    (
      result = parent.(Rust::StructPat).getStructPatFieldList().getField(index).getPat()
      or
      index = parent.(Rust::StructPat).getStructPatFieldList().getNumberOfFields() and
      result = parent.(Rust::StructPat).getStructPatFieldList().getRestPat()
    )
    or
    parent instanceof Rust::RefPat and
    index = 0 and
    result = parent.(Rust::RefPat).getPat()
    or
    parent instanceof Rust::SlicePat and
    result = parent.(Rust::SlicePat).getPat(index)
    or
    parent instanceof Rust::TuplePat and
    result = parent.(Rust::TuplePat).getField(index)
    or
    parent instanceof Rust::TupleStructPat and
    result = parent.(Rust::TupleStructPat).getField(index)
  }

  AstNode getChild(AstNode parent, int index) {
    result = desugar(runtimeChild(parent, index))
  }

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

  class Callable extends AstNode instanceof Scope::CfgScope {
  }

  AstNode callableGetBody(Callable c) {
    result = c.(Rust::Callable).getBody()
    or
    result = c.(Rust::AsyncBlockExpr).getStmtList()
  }

  class Parameter extends AstNode instanceof Rust::ParamBase {
    AstNode getPattern() { result = this }

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

  class LabeledStmt extends Stmt {
    LabeledStmt() { none() }

    Stmt getStmt() { none() }
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
      result = desugar(this.(Rust::BlockExpr).getStmtList().getStmtOrExpr(n))
      or
      result = desugar(this.(Rust::StmtList).getStmtOrExpr(n))
    }

    Stmt getLastStmt() {
      result = desugar(this.(Rust::BlockExpr).getStmtList().getTailExpr())
      or
      result = desugar(this.(Rust::StmtList).getTailExpr())
    }
  }

  class ExprStmt extends Stmt instanceof Rust::ExprStmt {
    Expr getExpr() { result = desugar(Rust::ExprStmt.super.getExpr()) }
  }

  class IfStmt extends Stmt {
    IfStmt() { none() }

    Expr getCondition() { none() }

    Stmt getThen() { none() }

    Stmt getElse() { none() }
  }

  class LoopStmt extends Stmt instanceof Rust::LoopingExpr {
    Stmt getBody() { result = this.(Rust::LoopingExpr).getLoopBody() }
  }

  class WhileStmt extends LoopStmt instanceof Rust::WhileExpr {
    Expr getCondition() { result = desugar(this.(Rust::WhileExpr).getCondition()) }
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

  class ForEachStmt extends LoopStmt {
    ForEachStmt() { none() }

    Expr getVariable() { none() }

    Expr getCollection() { none() }
  }

  class BreakStmt extends Stmt {
    BreakStmt() { none() }
  }

  class ContinueStmt extends Stmt instanceof Rust::ContinueExpr {
  }

  class GotoStmt extends Stmt {
    GotoStmt() { none() }
  }

  class ReturnStmt extends Stmt instanceof Rust::ReturnExpr {
    Expr getExpr() { result = desugar(this.(Rust::ReturnExpr).getExpr()) }
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

  class Switch extends AstNode {
    Switch() { none() }

    Expr getExpr() { none() }

    Case getCase(int index) { none() }

    Stmt getStmt(int index) { none() }
  }

  class Case extends AstNode {
    Case() { none() }

    AstNode getPattern(int index) { none() }

    Expr getGuard() { none() }

    AstNode getBody() { none() }
  }

  class DefaultCase extends Case {
    DefaultCase() { none() }
  }

  class ConditionalExpr extends Expr instanceof Rust::IfExpr {
    Expr getCondition() { result = desugar(this.(Rust::IfExpr).getCondition()) }

    Expr getThen() { result = desugar(this.(Rust::IfExpr).getThen()) }

    Expr getElse() { result = desugar(this.(Rust::IfExpr).getElse()) }
  }

  class BinaryExpr extends Expr instanceof Rust::BinaryExpr {
    Expr getLeftOperand() { result = desugar(this.(Rust::BinaryExpr).getLhs()) }

    Expr getRightOperand() { result = desugar(this.(Rust::BinaryExpr).getRhs()) }
  }

  class LogicalAndExpr extends BinaryExpr instanceof Rust::LogicalAndExpr {
  }

  class LogicalOrExpr extends BinaryExpr instanceof Rust::LogicalOrExpr {
  }

  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { none() }
  }

  class UnaryExpr extends Expr instanceof Rust::PrefixExpr {
    Expr getOperand() { result = desugar(this.(Rust::PrefixExpr).getExpr()) }
  }

  class LogicalNotExpr extends UnaryExpr instanceof Rust::LogicalNotExpr {
  }

  class Assignment extends BinaryExpr instanceof Rust::AssignmentOperation {
  }

  class AssignExpr extends Assignment instanceof Rust::AssignmentExpr {
  }

  class CompoundAssignment extends Assignment instanceof Rust::CompoundAssignmentExpr {
  }

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
      this.(Rust::BooleanLiteralExpr).getTextValue() = "true" and result = true
      or
      this.(Rust::BooleanLiteralExpr).getTextValue() = "false" and result = false
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
  pat = any(Rust::MatchExpr match).getLastArm().getPat()
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
  (cannotCauseMatchFailure(pat) or guaranteedMatchPosition(pat)) and
  not pat = any(Rust::ForExpr for).getPat()
}

private module Input implements InputSig1, InputSig2 {
  private import codeql.util.Void

  predicate cfgCachedStageRef() {
    CfgCachedStage::ref()
  }

  private newtype TLabel =
    TTarget(Rust::Expr target) or
    TTargetValue(Rust::Expr target, boolean value) {
      value = true or value = false
    }

  class Label extends TLabel {
    string toString() {
      exists(Rust::Expr target |
        this = TTarget(target) and
        result = target.toString()
      )
      or
      exists(Rust::Expr target, boolean value |
        this = TTargetValue(target, value) and
        result = target.toString() + " [" + value.toString() + "]"
      )
    }
  }

  predicate hasLabel(Ast::AstNode n, Label l) {
    l = TTarget(n.(Rust::ContinueExpr).getTarget())
    or
    l = TTarget(n.(Rust::LoopingExpr))
  }

  class CallableContext = Void;

  private predicate valueContext(Rust::AstNode n, ConditionKind kind) {
    kind.isBoolean() and
    (
      n = Ast::desugar(any(Rust::IfExpr e).getCondition())
      or
      n = Ast::desugar(any(Rust::WhileExpr e).getCondition())
      or
      n = Ast::desugar(any(Rust::MatchGuard g).getCondition())
      or
      n = Ast::desugar(any(Rust::BinaryLogicalOperation e).getLhs())
    )
    or
    exists(Rust::Expr parent | valueContext(parent, kind) |
      n = Ast::desugar(parent.(Rust::LogicalNotExpr).getExpr())
      or
      n = Ast::desugar(parent.(Rust::BinaryLogicalOperation).getRhs())
      or
      n = Ast::desugar(parent.(Rust::IfExpr).getABranch())
      or
      n = Ast::desugar(parent.(Rust::MatchExpr).getAnArm().getExpr())
      or
      n = Ast::desugar(parent.(Rust::BlockExpr).getStmtList().getTailExpr())
      or
      n = Ast::desugar(any(Rust::BreakExpr b | b.getTarget() = parent).getExpr())
    )
  }

  predicate inConditionalContext(Ast::AstNode n, ConditionKind kind) {
    valueContext(n, kind)
    or
    kind.isMatching() and
    (
      n instanceof Rust::Pat
      or
      n = Ast::desugar(any(Rust::TryExpr e).getExpr())
    )
  }

  predicate preOrderExpr(Ast::Expr e) {
    e instanceof Rust::MatchExpr
    or
    e instanceof Rust::LetExpr
    or
    e instanceof Rust::LoopingExpr
    or
    e instanceof Rust::BreakExpr
    or
    e instanceof Rust::TryExpr
    or
    e instanceof Rust::Pat and
    not e instanceof Rust::IdentPat and
    not e instanceof Rust::LiteralPat
  }

  predicate postOrInOrder(Ast::AstNode n) {
    n instanceof Rust::ParamBase
    or
    n instanceof Rust::MacroCall
  }

  private string breakTag() { result = "[break]" }

  private string breakValueTag(boolean value) {
    value = true and result = "[break-true]"
    or
    value = false and result = "[break-false]"
  }

  private string tryReturnTag() { result = "[try-return]" }

  private string patternStartTag() { result = "[pattern-start]" }

  private string emptyMatchTag() { result = "[empty-match]" }

  private string letElseDivergeTag() { result = "[let-else-diverge]" }

  private predicate conditionalBreak(Rust::BreakExpr b) {
    exists(b.getExpr()) and
    valueContext(b.getTarget(), any(ConditionKind kind | kind.isBoolean()))
  }

  predicate additionalNode(Ast::AstNode n, string tag, NormalSuccessor t) {
    (
      t instanceof DirectSuccessor and
      (
        n instanceof Rust::BreakExpr and
        (
          conditionalBreak(n) and tag = breakValueTag(_)
          or
          not conditionalBreak(n) and tag = breakTag()
        )
        or
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
    parent instanceof Rust::BoxPat and
    index = 0 and
    result = parent.(Rust::BoxPat).getPat()
    or
    parent instanceof Rust::DerefPat and
    index = 0 and
    result = parent.(Rust::DerefPat).getPat()
    or
    parent instanceof Rust::MacroPat and
    index = 0 and
    result = parent.(Rust::MacroPat).getMacroCall().getMacroCallExpansion()
    or
    parent instanceof Rust::OrPat and
    result = parent.(Rust::OrPat).getPat(index)
    or
    parent instanceof Rust::RangePat and
    (
      index = 0 and result = parent.(Rust::RangePat).getStart()
      or
      index = 1 and result = parent.(Rust::RangePat).getEnd()
    )
    or
    parent instanceof Rust::StructPat and
    (
      result = parent.(Rust::StructPat).getStructPatFieldList().getField(index).getPat()
      or
      index = parent.(Rust::StructPat).getStructPatFieldList().getNumberOfFields() and
      result = parent.(Rust::StructPat).getStructPatFieldList().getRestPat()
    )
    or
    parent instanceof Rust::RefPat and
    index = 0 and
    result = parent.(Rust::RefPat).getPat()
    or
    parent instanceof Rust::SlicePat and
    result = parent.(Rust::SlicePat).getPat(index)
    or
    parent instanceof Rust::TuplePat and
    result = parent.(Rust::TuplePat).getField(index)
    or
    parent instanceof Rust::TupleStructPat and
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

  private predicate isAfterMatch(
    PreControlFlowNode n, Rust::AstNode ast, boolean value
  ) {
    n.isAfterValue(Ast::desugar(ast),
      any(MatchingSuccessor t | t.getValue() = value))
  }

  private predicate parameterStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::ParamBase p, Ast::AstNode child |
      child = Ast::getChild(p, _)
    |
      n1.isBefore(p) and n2.isBefore(child)
      or
      p instanceof Rust::Param and
      isAfterMatch(n1, child, true) and
      n2.isIn(p)
      or
      p instanceof Rust::SelfParam and
      n1.isAfter(child) and
      n2.isIn(p)
      or
      n1.isIn(p) and n2.isAfter(p)
    )
  }

  private predicate letStmtStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::LetStmt let |
      n1.isBefore(let) and
      (
        n2.isBefore(Ast::desugar(let.getInitializer()))
        or
        not let.hasInitializer() and n2.isBefore(Ast::desugar(let.getPat()))
      )
      or
      n1.isAfter(Ast::desugar(let.getInitializer())) and
      n2.isBefore(Ast::desugar(let.getPat()))
      or
      isAfterMatch(n1, let.getPat(), true) and n2.isAfter(let)
      or
      isAfterMatch(n1, let.getPat(), false) and
      n2.isBefore(Ast::desugar(let.getLetElse().getBlockExpr()))
      or
      n1.isAfter(Ast::desugar(let.getLetElse().getBlockExpr())) and
      n2.isAdditional(let.getLetElse().getBlockExpr(), letElseDivergeTag())
    )
  }

  private predicate letExprStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::LetExpr let |
      n1.isBefore(let) and n2.isBefore(Ast::desugar(let.getScrutinee()))
      or
      n1.isAfter(Ast::desugar(let.getScrutinee())) and
      n2.isBefore(Ast::desugar(let.getPat()))
      or
      isAfterMatch(n1, let.getPat(), true) and n2.isAfterTrue(let)
      or
      isAfterMatch(n1, let.getPat(), false) and n2.isAfterFalse(let)
    )
  }

  private predicate matchArmStart(
    Rust::MatchExpr match, int index, PreControlFlowNode n
  ) {
    n.isBefore(Ast::desugar(match.getArm(index).getPat()))
  }

  private predicate matchArmBodyStart(
    Rust::MatchArm arm, PreControlFlowNode n
  ) {
    n.isBefore(Ast::desugar(arm.getGuard().getCondition()))
    or
    not arm.hasGuard() and n.isBefore(Ast::desugar(arm.getExpr()))
  }

  private predicate matchStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::MatchExpr match |
      n1.isBefore(match) and n2.isBefore(Ast::desugar(match.getScrutinee()))
      or
      n1.isAfter(Ast::desugar(match.getScrutinee())) and
      (
        matchArmStart(match, 0, n2)
        or
        not exists(match.getAnArm()) and n2.isAdditional(match, emptyMatchTag())
      )
      or
      exists(int i, Rust::MatchArm arm | arm = match.getArm(i) |
        isAfterMatch(n1, arm.getPat(), true) and matchArmBodyStart(arm, n2)
        or
        (
          isAfterMatch(n1, arm.getPat(), false)
          or
          n1.isAfterFalse(Ast::desugar(arm.getGuard().getCondition()))
        ) and
        matchArmStart(match, i + 1, n2)
        or
        n1.isAfterTrue(Ast::desugar(arm.getGuard().getCondition())) and
        n2.isBefore(Ast::desugar(arm.getExpr()))
        or
        exists(ConditionalSuccessor t |
          n1.isAfterValue(Ast::desugar(arm.getExpr()), t) and
          n2.isAfterValue(match, t)
        )
        or
        not valueContext(match, _) and
        n1.isAfter(Ast::desugar(arm.getExpr())) and
        n2.isAfter(match)
      )
    )
  }

  private predicate genericPatternStep(
    Rust::Pat pat, PreControlFlowNode n1, PreControlFlowNode n2
  ) {
    not pat instanceof Rust::IdentPat and
    not pat instanceof Rust::LiteralPat and
    not pat instanceof Rust::OrPat and
    (
      n1.isBefore(Ast::desugar(pat)) and
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
      n2.isBefore(Ast::desugar(getRankedPatternChild(pat, 1)))
      or
      exists(int i, Rust::Pat child | child = getRankedPatternChild(pat, i) |
        isAfterMatch(n1, child, true) and
        (
          n2.isBefore(Ast::desugar(getRankedPatternChild(pat, i + 1)))
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
    n1.isBefore(pat) and n2.isBefore(Ast::desugar(pat.getLiteral()))
    or
    n1.isAfter(Ast::desugar(pat.getLiteral())) and n2.isIn(pat)
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
      n2.isBefore(Ast::desugar(pat.getPat()))
      or
      not pat.hasPat() and n2.isBefore(Ast::desugar(pat.getName()))
    )
    or
    isAfterMatch(n1, pat.getPat(), true) and n2.isBefore(Ast::desugar(pat.getName()))
    or
    isAfterMatch(n1, pat.getPat(), false) and isAfterMatch(n2, pat, false)
    or
    n1.isAfter(Ast::desugar(pat.getName())) and n2.isIn(pat)
    or
    n1.isIn(pat) and isAfterMatch(n2, pat, true)
    or
    n1.isIn(pat) and not guaranteedMatch(pat) and isAfterMatch(n2, pat, false)
  }

  private predicate orPatternStep(
    Rust::OrPat pat, PreControlFlowNode n1, PreControlFlowNode n2
  ) {
    n1.isBefore(pat) and n2.isBefore(Ast::desugar(getRankedPatternChild(pat, 1)))
    or
    exists(int i, Rust::Pat child | child = getRankedPatternChild(pat, i) |
      isAfterMatch(n1, child, true) and isAfterMatch(n2, pat, true)
      or
      isAfterMatch(n1, child, false) and
      (
        n2.isBefore(Ast::desugar(getRankedPatternChild(pat, i + 1)))
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
      n1.isBefore(loop) and n2.isBefore(Ast::desugar(loop.getLoopBody()))
      or
      n1.isAfter(Ast::desugar(loop.getLoopBody())) and
      n2.isAdditional(loop, loopHeaderTag())
      or
      n1.isAdditional(loop, loopHeaderTag()) and
      n2.isBefore(Ast::desugar(loop.getLoopBody()))
    )
    or
    exists(Rust::ForExpr for |
      n1.isBefore(for) and n2.isBefore(Ast::desugar(for.getIterable()))
      or
      n1.isAfter(Ast::desugar(for.getIterable())) and
      n2.isBefore(Ast::desugar(for.getPat()))
      or
      isAfterMatch(n1, for.getPat(), true) and
      n2.isBefore(Ast::desugar(for.getLoopBody()))
      or
      isAfterMatch(n1, for.getPat(), false) and n2.isAfter(for)
      or
      n1.isAfter(Ast::desugar(for.getLoopBody())) and
      n2.isAdditional(for, loopHeaderTag())
      or
      n1.isAdditional(for, loopHeaderTag()) and
      n2.isBefore(Ast::desugar(for.getPat()))
    )
  }

  private predicate breakStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::BreakExpr break |
      n1.isBefore(break) and
      (
        n2.isBefore(Ast::desugar(break.getExpr()))
        or
        not exists(break.getExpr()) and n2.isAdditional(break, breakTag())
      )
      or
      conditionalBreak(break) and
      exists(BooleanSuccessor t |
        n1.isAfterValue(Ast::desugar(break.getExpr()), t) and
        n2.isAdditional(break, breakValueTag(t.getValue()))
      )
      or
      not conditionalBreak(break) and
      n1.isAfter(Ast::desugar(break.getExpr())) and
      n2.isAdditional(break, breakTag())
    )
  }

  private predicate tryStep(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Rust::TryExpr try |
      n1.isBefore(try) and n2.isBefore(Ast::desugar(try.getExpr()))
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
    exists(Rust::BreakExpr break |
      ast = break and
      c.getSuccessorType() instanceof BreakSuccessor and
      always = true and
      (
        n.isAdditional(break, breakTag()) and
        c.hasLabel(TTarget(break.getTarget()))
        or
        exists(boolean value |
          n.isAdditional(break, breakValueTag(value)) and
          c.hasLabel(TTargetValue(break.getTarget(), value))
        )
      )
    )
    or
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

  private predicate targetChild(
    Rust::Expr target, Ast::AstNode child
  ) {
    child = Ast::getChild(target, _)
  }

  predicate endAbruptCompletion(
    Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c
  ) {
    exists(Rust::Expr target |
      targetChild(target, ast) and
      c.getSuccessorType() instanceof BreakSuccessor
    |
      c.hasLabel(TTarget(target)) and n.isAfter(target)
      or
      exists(boolean value |
        c.hasLabel(TTargetValue(target, value)) and
        n.isAfterValue(target, any(BooleanSuccessor t | t.getValue() = value))
      )
    )
  }

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
    parameterStep(n1, n2)
    or
    letStmtStep(n1, n2)
    or
    letExprStep(n1, n2)
    or
    matchStep(n1, n2)
    or
    patternStep(n1, n2)
    or
    loopStep(n1, n2)
    or
    breakStep(n1, n2)
    or
    tryStep(n1, n2)
  }
}
