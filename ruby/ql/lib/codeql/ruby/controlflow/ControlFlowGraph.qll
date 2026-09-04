/** Provides classes representing the control flow graph. */
overlay[local]
module;

private import ruby as R
private import codeql.Locations
private import codeql.controlflow.ControlFlowGraph
import codeql.controlflow.SuccessorType
private import codeql.ruby.ast.internal.Synthesis
private import codeql.ruby.ast.internal.Scope

private module Cfg0 = Make0<Location, Ast>;

private module Cfg1 = Make1<Input>;

private module Cfg2 = Make2<Input>;

private import Cfg0
private import Cfg1
private import Cfg2
import Public

/**
 * An AST node with an associated control-flow graph.
 *
 * Top-levels, methods, blocks, and lambdas are all CFG scopes.
 *
 * Note that module declarations are not themselves CFG scopes, as they are part of
 * the CFG of the enclosing top-level or callable.
 */
class CfgScope extends R::Ast::Scope instanceof CfgScopeImpl {
  /** Gets the CFG scope that this scope is nested under, if any. */
  final CfgScope getOuterCfgScope() {
    exists(R::Ast::AstNode parent |
      parent = this.getParent() and
      result = getEnclosingCallable(parent)
    )
  }
}

/**
 * A control flow node.
 *
 * A control flow node is a node in the control flow graph (CFG). There is a
 * many-to-one relationship between CFG nodes and AST nodes.
 *
 * Only nodes that can be reached from an entry point are included in the CFG.
 */
class CfgNode extends ControlFlowNode {
  /** Gets the name of the primary QL class for this node. */
  overlay[global]
  string getAPrimaryQlClass() { none() }

  /** Gets a successor node of a given type, if any. */
  final CfgNode getASuccessor(SuccessorType t) { result = super.getASuccessor(t) }

  /** Gets an immediate successor, if any. */
  final CfgNode getASuccessor() { result = this.getASuccessor(_) }

  /** Gets an immediate predecessor node of a given flow type, if any. */
  final CfgNode getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

  /** Gets an immediate predecessor, if any. */
  final CfgNode getAPredecessor() { result = this.getAPredecessor(_) }
}

private Ast::AstNode desugar(R::Ast::AstNode n) { result = n or result = n.getDesugared() }

class CfgScopeImpl = Ast::Callable;

predicate getEnclosingCallable = Ast::getEnclosingCallable/1;

/** Provides an implementation of the AST signature for Ruby. */
private module Ast implements AstSig<Location> {
  private import codeql.ruby.ast.internal.AST

  private predicate additionalExclude(R::Ast::AstNode n) {
    n instanceof R::Ast::DestructuredLhsExpr or
    exists(n.getDesugared())
  }

  class AstNode extends R::Ast::AstNode {
    AstNode() {
      not any(Synthesis s).excludeFromControlFlowTree(this) and not additionalExclude(this)
    }
  }

  private R::Ast::AstNode adjustedGetChild(R::Ast::AstNode parent, int index) {
    exists(R::Ast::WhenClause when | parent = when |
      when.getPattern(index) = result
      or
      when.getBody() = result and index = toGenerated(result).getParentIndex()
    )
    or
    exists(R::Ast::MethodCall call | parent = call and not call instanceof R::Ast::BinaryOperation |
      index = -1 and call.getReceiver() = result
      or
      call.getArgument(index) = result
      or
      index = call.getNumberOfArguments() and
      call.getBlock() = result
    )
    or
    exists(R::Ast::ClassDeclaration cls | parent = cls |
      index = 0 and cls.getScopeExpr() = result
      or
      index = 1 and cls.getSuperclassExpr() = result
      or
      cls.getStmt(index - 2) = result
    )
    or
    exists(R::Ast::ModuleDeclaration mod | parent = mod |
      index = 0 and mod.getScopeExpr() = result
      or
      mod.getStmt(index - 1) = result
    )
    or
    exists(R::Ast::SingletonClass cls | parent = cls |
      index = 0 and cls.getValue() = result
      or
      cls.getStmt(index - 1) = result
    )
    or
    exists(R::Ast::SingletonMethod method | parent = method |
      index = 0 and method.getObject() = result
    )
    or
    exists(R::Ast::Pair pair | parent = pair |
      index = 0 and pair.getKey() = result
      or
      index = 1 and pair.getValue() = result
    )
    or
    exists(R::Ast::ArrayPattern arraypattern | parent = arraypattern |
      index = -1 and arraypattern.getClass() = result
      or
      arraypattern.getPrefixElement(index) = result
      or
      exists(int restix | restix = count(arraypattern.getPrefixElement(_)) |
        restix = index and arraypattern.getRestVariableAccess() = result
        or
        arraypattern.getSuffixElement(index - restix - 1) = result
      )
    )
    or
    exists(R::Ast::FindPattern findpattern | parent = findpattern |
      index = -2 and findpattern.getClass() = result
      or
      index = -1 and findpattern.getPrefixVariableAccess() = result
      or
      findpattern.getElement(index) = result
      or
      index = count(findpattern.getElement(_)) and
      findpattern.getSuffixVariableAccess() = result
    )
    or
    exists(R::Ast::HashPattern hashpattern | parent = hashpattern |
      index = -1 and hashpattern.getClass() = result
      or
      exists(int i |
        hashpattern.getKey(i) = result and
        index = 2 * i
        or
        hashpattern.getValue(i) = result and
        index = 2 * i + 1
      )
      or
      index = 2 * count(hashpattern.getValue(_)) and hashpattern.getRestVariableAccess() = result
    )
  }

  private R::Ast::AstNode baseGetChild(R::Ast::AstNode parent, int index) {
    result = adjustedGetChild(parent, index)
    or
    not exists(adjustedGetChild(parent, _)) and
    not parent instanceof R::Ast::Callable and
    (
      synthChild(parent, index, result)
      or
      result = parent.getAChild() and
      not synthChild(parent, _, result) and
      toGenerated(result).getParentIndex() = index
    )
  }

  AstNode getChild(AstNode parent, int index) { result = desugar(baseGetChild(parent, index)) }

  private R::Ast::Scope parentScope(R::Ast::Scope n) {
    result = n.getOuterScope() and
    not n instanceof Callable
  }

  cached
  Callable getEnclosingCallable(AstNode node) { result = parentScope*(scopeOfInclSynth(node)) }

  // TODO: Include EndBlock
  class Callable extends AstNode {
    Callable() { this instanceof R::Ast::Toplevel or this instanceof R::Ast::Callable }
  }

  additional AstNode toplevelBody(R::Ast::Toplevel t, int index) {
    result = t.getBeginBlock(index) or
    result = desugar(t.getStmt(index - count(t.getABeginBlock())))
  }

  AstNode callableGetBody(Callable c) {
    result = toplevelBody(c, _) or
    result = c.(R::Ast::Callable).getBody()
  }

  class Parameter extends AstNode instanceof R::Ast::Parameter {
    AstNode getPattern() {
      this.(R::Ast::NamedParameter).getDefiningAccess() = result
      or
      not exists(this.(R::Ast::NamedParameter).getDefiningAccess()) and
      this = result
    }

    Expr getDefaultValue() {
      result = desugar(this.(R::Ast::KeywordParameter).getDefaultValue()) or
      result = desugar(this.(R::Ast::OptionalParameter).getDefaultValue())
    }
  }

  Parameter callableGetParameter(Callable c, int index) {
    c.(R::Ast::Callable).getParameter(index) = result
  }

  class Stmt extends AstNode instanceof R::Ast::Stmt { }

  // Most ast nodes in Ruby are both statements and expressions with only a few
  // that are only statements. Similarly, most nodes accept statement children,
  // but a few only accept expression children. But since this really only
  // matters for parsing, we can just treat expressions and statements as the
  // same thing to avoid hard-to-find mistakes.
  class Expr = Stmt;

  class BlockStmt extends Stmt instanceof R::Ast::StmtSequence {
    BlockStmt() { not this instanceof TryStmt }

    Stmt getStmt(int n) { result = desugar(super.getStmt(n)) }

    Stmt getLastStmt() { result = desugar(super.getLastStmt()) }
  }

  class ExprStmt extends Stmt {
    ExprStmt() { none() }

    Expr getExpr() { none() }
  }

  class IfStmt extends Stmt instanceof R::Ast::ConditionalExpr {
    IfStmt() {
      exists(Stmt branch |
        branch = desugar(super.getBranch(_)) and not branch instanceof R::Ast::Expr
      )
    }

    Expr getCondition() { result = desugar(super.getCondition()) }

    Stmt getThen() { result = desugar(super.getBranch(true)) }

    Stmt getElse() { result = desugar(super.getBranch(false)) }
  }

  class LoopStmt extends Stmt instanceof R::Ast::Loop {
    Stmt getBody() { result = desugar(super.getBody()) }
  }

  class WhileStmt extends LoopStmt instanceof R::Ast::ConditionalLoop {
    WhileStmt() { this instanceof R::Ast::WhileExpr or this instanceof R::Ast::WhileModifierExpr }

    Expr getCondition() { result = desugar(super.getCondition()) }
  }

  class UntilStmt extends LoopStmt instanceof R::Ast::ConditionalLoop {
    UntilStmt() { this instanceof R::Ast::UntilExpr or this instanceof R::Ast::UntilModifierExpr }

    Expr getCondition() { result = desugar(super.getCondition()) }
  }

  class DoStmt extends LoopStmt {
    DoStmt() { none() }

    Expr getCondition() { none() }
  }

  class ForStmt extends LoopStmt {
    ForStmt() { none() }

    AstNode getInit(int index) { none() }

    Expr getCondition() { none() }

    AstNode getUpdate(int index) { none() }
  }

  // `ForExpr` would be a match for `ForEachStmt`, but it is desugared.
  class ForEachStmt extends LoopStmt {
    ForEachStmt() { none() }

    Expr getVariable() { none() }

    Expr getCollection() { none() }
  }

  class BreakStmt extends Stmt instanceof R::Ast::BreakStmt { }

  class ContinueStmt extends Stmt instanceof R::Ast::NextStmt { }

  class GotoStmt extends Stmt {
    GotoStmt() { none() }
  }

  class ReturnStmt extends Stmt instanceof R::Ast::ReturnStmt {
    Expr getExpr() { result = desugar(super.getValue()) }
  }

  // raise is just a method call
  class Throw extends AstNode {
    Throw() { none() }

    Expr getExpr() { none() }
  }

  class TryStmt extends Stmt instanceof R::Ast::BodyStmt {
    TryStmt() { exists(this.getRescue(_)) or exists(this.getElse()) or this.hasEnsure() }

    AstNode getBody(int index) { result = desugar(super.getStmt(index)) }

    CatchClause getCatch(int index) { result = super.getRescue(index) }

    Stmt getFinally() { result = super.getEnsure() }
  }

  AstNode getTryElse(TryStmt try) { result = try.(R::Ast::BodyStmt).getElse() }

  class CatchClause extends AstNode instanceof R::Ast::RescueClause {
    AstNode getPattern() { result = desugar(super.getPattern()) }

    AstNode getVariable() { result = super.getVariableExpr() }

    Expr getCondition() { none() }

    Stmt getBody() { result = super.getBody() }
  }

  class Switch extends AstNode instanceof R::Ast::CaseExpr {
    Expr getExpr() { result = desugar(super.getValue()) }

    Case getCase(int index) { result = super.getBranch(index) }

    Stmt getStmt(int index) { none() }
  }

  class Case extends AstNode {
    Case() { this = any(R::Ast::CaseExpr switch).getABranch() }

    AstNode getPattern(int index) {
      desugar(this.(R::Ast::WhenClause).getPattern(index)) = result
      or
      desugar(this.(R::Ast::InClause).getPattern()) = result and index = 0
    }

    Expr getGuard() { desugar(this.(R::Ast::InClause).getCondition()) = result }

    AstNode getBody() {
      desugar(this.(R::Ast::WhenClause).getBody()) = result or
      desugar(this.(R::Ast::InClause).getBody()) = result or
      desugar(this.(R::Ast::CaseElseBranch).getBody()) = result
    }
  }

  class DefaultCase extends Case instanceof R::Ast::CaseElseBranch { }

  predicate fallsThrough(Case c) { none() }

  class ConditionalExpr extends Expr instanceof R::Ast::ConditionalExpr {
    ConditionalExpr() { not this instanceof IfStmt }

    Expr getCondition() { result = desugar(super.getCondition()) }

    Expr getThen() { result = desugar(super.getBranch(true)) }

    Expr getElse() { result = desugar(super.getBranch(false)) }
  }

  class BinaryExpr extends Expr {
    BinaryExpr() { this instanceof R::Ast::BinaryOperation or this instanceof R::Ast::Assignment }

    Expr getLeftOperand() {
      result = desugar(this.(R::Ast::BinaryOperation).getLeftOperand()) or
      result = desugar(this.(R::Ast::Assignment).getLeftOperand())
    }

    Expr getRightOperand() {
      result = desugar(this.(R::Ast::BinaryOperation).getRightOperand()) or
      result = desugar(this.(R::Ast::Assignment).getRightOperand())
    }
  }

  class LogicalAndExpr extends BinaryExpr instanceof R::Ast::LogicalAndExpr { }

  class LogicalOrExpr extends BinaryExpr instanceof R::Ast::LogicalOrExpr { }

  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { none() }
  }

  class UnaryExpr extends Expr instanceof R::Ast::UnaryOperation {
    Expr getOperand() { result = desugar(super.getOperand()) }
  }

  class LogicalNotExpr extends UnaryExpr instanceof R::Ast::NotExpr { }

  class Assignment extends BinaryExpr instanceof R::Ast::Assignment { }

  class AssignExpr extends Assignment instanceof R::Ast::AssignExpr { }

  // Compound assignments are desugared.
  class CompoundAssignment extends Assignment {
    CompoundAssignment() { none() }
  }

  class AssignLogicalAndExpr extends CompoundAssignment { }

  class AssignLogicalOrExpr extends CompoundAssignment { }

  class AssignNullCoalescingExpr extends CompoundAssignment { }

  class BooleanLiteral extends Expr instanceof R::Ast::BooleanLiteral {
    boolean getValue() { result = super.getValue() }
  }

  class PatternMatchExpr extends Expr {
    PatternMatchExpr() { none() }

    Expr getExpr() { none() }

    AstNode getPattern() { none() }
  }
}

private predicate rescuable(R::Ast::AstNode n) {
  exists(R::Ast::RescueModifierExpr rescueModifier | n = desugar(rescueModifier.getBody()))
  or
  exists(Ast::TryStmt try | n = try.getBody(_))
  or
  exists(R::Ast::AstNode parent | n = desugar(parent.getAChild()) and rescuable(parent))
}

/**
 * Holds if `c` happens in an exception-aware context, that is, it may be
 * `rescue`d or `ensure`d. In such cases, we assume that the target of `c`
 * may raise an exception (in addition to evaluating normally).
 */
private predicate mayRaise(R::Ast::Call c) { rescuable(c) }

private module Input implements InputSig1, InputSig2 {
  private import codeql.util.Void
  private import codeql.util.Unit
  private import internal.NonReturning

  predicate cfgCachedStageRef() { CfgCachedStage::ref() }

  class Label = Void;

  predicate preOrderExpr(Ast::Expr e) {
    e instanceof R::Ast::StmtSequence or
    e instanceof R::Ast::RescueClause or
    e instanceof R::Ast::ConditionalExpr or
    e instanceof R::Ast::Loop or
    e instanceof R::Ast::RescueModifierExpr
  }

  predicate postOrInOrder(Ast::AstNode n) {
    n instanceof R::Ast::Call and
    not n instanceof R::Ast::BinaryOperation and
    not n instanceof R::Ast::UnaryOperation
    or
    n instanceof R::Ast::RedoStmt
    or
    n instanceof R::Ast::RetryStmt
  }

  class CallableContext = Unit;

  Ast::AstNode callableGetBodyPart(Ast::Callable c, CallableContext ctx, int index) {
    result = Ast::toplevelBody(c, index) and
    exists(ctx)
  }

  predicate catchAll(Ast::CatchClause catch) {
    not exists(catch.(R::Ast::RescueClause).getAnException())
  }

  predicate beginAbruptCompletion(
    Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    ast.(NonReturningCall).getASuccessorType() = c.asSimpleAbruptCompletion() and
    n.isIn(ast) and
    always = true
    or
    mayRaise(ast) and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = false
    or
    ast instanceof R::Ast::RedoStmt and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof RedoSuccessor and
    always = true
    or
    ast instanceof R::Ast::RetryStmt and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof RetrySuccessor and
    always = true
  }

  predicate endAbruptCompletion(Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
    exists(R::Ast::Callable callable |
      callable.getBody() = ast and
      n.(NormalExitNodeImpl).getEnclosingCallable() = callable
    |
      c.asSimpleAbruptCompletion() instanceof BreakSuccessor or
      c.asSimpleAbruptCompletion() instanceof ContinueSuccessor or
      c.asSimpleAbruptCompletion() instanceof RedoSuccessor
    )
    or
    exists(R::Ast::RescueModifierExpr rescueModifier |
      ast = desugar(rescueModifier.getBody()) and
      c.getSuccessorType() instanceof ExceptionSuccessor and
      n.isBefore(desugar(rescueModifier.getHandler()))
    )
    or
    ast = any(Ast::LoopStmt loop).getBody() and
    c.asSimpleAbruptCompletion() instanceof RedoSuccessor and
    n.isBefore(ast)
    or
    exists(Ast::TryStmt try |
      ast = try.getCatch(_).getBody() and
      c.asSimpleAbruptCompletion() instanceof RetrySuccessor and
      n.isBefore(try.getBody(0))
    )
  }

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(R::Ast::RescueModifierExpr rescueModifier |
      n1.isBefore(rescueModifier) and
      n2.isBefore(desugar(rescueModifier.getBody()))
      or
      n1.isAfter(desugar(rescueModifier.getBody())) and
      n2.isAfter(rescueModifier)
      or
      n1.isAfter(desugar(rescueModifier.getHandler())) and
      n2.isAfter(rescueModifier)
    )
  }
}
