/**
 * Provides consistency queries for `AstSig`.
 */
overlay[local?]
module;

private import codeql.util.Location
private import ControlFlowGraph

module MakeAstConsistency<LocationSig Location, AstSig<Location> Ast> {
  private import Ast

  private predicate astMemberChild(AstNode parent, AstNode child, string member) {
    callableGetBody(parent) = child and member = "Callable.getBody"
    or
    callableGetParameter(parent, _) = child and member = "Callable.getParameter"
    or
    parent.(Parameter).getDefaultValue() = child and member = "Parameter.getDefaultValue"
    or
    parent.(BlockStmt).getStmt(_) = child and member = "BlockStmt.getStmt"
    or
    parent.(BlockStmt).getLastStmt() = child and member = "BlockStmt.getLastStmt"
    or
    parent.(ExprStmt).getExpr() = child and member = "ExprStmt.getExpr"
    or
    parent.(IfStmt).getCondition() = child and member = "IfStmt.getCondition"
    or
    parent.(IfStmt).getThen() = child and member = "IfStmt.getThen"
    or
    parent.(IfStmt).getElse() = child and member = "IfStmt.getElse"
    or
    parent.(LoopStmt).getBody() = child and member = "LoopStmt.getBody"
    or
    parent.(WhileStmt).getCondition() = child and member = "WhileStmt.getCondition"
    or
    parent.(DoStmt).getCondition() = child and member = "DoStmt.getCondition"
    or
    parent.(ForStmt).getInit(_) = child and member = "ForStmt.getInit"
    or
    parent.(ForStmt).getCondition() = child and member = "ForStmt.getCondition"
    or
    parent.(ForStmt).getUpdate(_) = child and member = "ForStmt.getUpdate"
    or
    parent.(ForeachStmt).getVariable() = child and member = "ForeachStmt.getVariable"
    or
    parent.(ForeachStmt).getCollection() = child and member = "ForeachStmt.getCollection"
    or
    parent.(ReturnStmt).getExpr() = child and member = "ReturnStmt.getExpr"
    or
    parent.(Throw).getExpr() = child and member = "Throw.getExpr"
    or
    parent.(TryStmt).getBody() = child and member = "TryStmt.getBody"
    or
    parent.(TryStmt).getCatch(_) = child and member = "TryStmt.getCatch"
    or
    parent.(TryStmt).getFinally() = child and member = "TryStmt.getFinally"
    or
    getTryInit(parent, _) = child and member = "getTryInit"
    or
    getTryElse(parent) = child and member = "getTryElse"
    or
    parent.(CatchClause).getVariable() = child and member = "CatchClause.getVariable"
    or
    parent.(CatchClause).getCondition() = child and member = "CatchClause.getCondition"
    or
    parent.(CatchClause).getBody() = child and member = "CatchClause.getBody"
    or
    parent.(Switch).getExpr() = child and member = "Switch.getExpr"
    or
    parent.(Switch).getCase(_) = child and member = "Switch.getCase"
    or
    parent.(Switch).getStmt(_) = child and member = "Switch.getStmt"
    or
    parent.(Case).getPattern(_) = child and member = "Case.getPattern"
    or
    parent.(Case).getGuard() = child and member = "Case.getGuard"
    or
    parent.(Case).getBody() = child and member = "Case.getBody"
    or
    parent.(ConditionalExpr).getCondition() = child and member = "ConditionalExpr.getCondition"
    or
    parent.(ConditionalExpr).getThen() = child and member = "ConditionalExpr.getThen"
    or
    parent.(ConditionalExpr).getElse() = child and member = "ConditionalExpr.getElse"
    or
    parent.(BinaryExpr).getLeftOperand() = child and member = "BinaryExpr.getLeftOperand"
    or
    parent.(BinaryExpr).getRightOperand() = child and member = "BinaryExpr.getRightOperand"
    or
    parent.(UnaryExpr).getOperand() = child and member = "UnaryExpr.getOperand"
    or
    parent.(PatternMatchExpr).getExpr() = child and member = "PatternMatchExpr.getExpr"
    or
    parent.(PatternMatchExpr).getPattern() = child and member = "PatternMatchExpr.getPattern"
  }

  final private class FinalAstNode = AstNode;

  private class StructuredAstNode extends FinalAstNode {
    StructuredAstNode() {
      this instanceof Callable or
      this instanceof Parameter or
      this instanceof BlockStmt or
      this instanceof ExprStmt or
      this instanceof IfStmt or
      this instanceof LoopStmt or
      this instanceof WhileStmt or
      this instanceof DoStmt or
      this instanceof ForStmt or
      this instanceof ForeachStmt or
      this instanceof ReturnStmt or
      this instanceof Throw or
      this instanceof TryStmt or
      this instanceof CatchClause or
      this instanceof Switch or
      this instanceof Case or
      this instanceof ConditionalExpr or
      this instanceof BinaryExpr or
      this instanceof UnaryExpr or
      this instanceof PatternMatchExpr
    }
  }

  module Consistency {
    /** Holds if the consistency query `query` has `results` results. */
    query predicate consistencyOverview(string query, int results) {
      query = "multipleParents" and
      results = strictcount(AstNode child | multipleParents(child, _, _))
      or
      query = "childAtMultipleIndices" and
      results = strictcount(AstNode child | childAtMultipleIndices(_, child, _, _))
      or
      query = "siblingsWithIdenticalIndex" and
      results =
        strictcount(AstNode parent, int index | siblingsWithIdenticalIndex(parent, index, _, _))
      or
      query = "memberChildMissingFromGetChild" and
      results =
        strictcount(AstNode parent, AstNode child | memberChildMissingFromGetChild(parent, child, _))
      or
      query = "getChildMissingFromMember" and
      results = strictcount(AstNode parent, int index | getChildMissingFromMember(parent, index, _))
    }

    /** Holds if `child` has multiple AST parents. */
    query predicate multipleParents(AstNode child, AstNode parent1, AstNode parent2) {
      getChild(parent1, _) = child and
      getChild(parent2, _) = child and
      parent1 != parent2
    }

    /** Holds if `child` is assigned multiple child indices under `parent`. */
    query predicate childAtMultipleIndices(AstNode parent, AstNode child, int index1, int index2) {
      getChild(parent, index1) = child and
      getChild(parent, index2) = child and
      index1 < index2
    }

    /** Holds if multiple children of `parent` share the same child index. */
    query predicate siblingsWithIdenticalIndex(
      AstNode parent, int index, AstNode child1, AstNode child2
    ) {
      getChild(parent, index) = child1 and
      getChild(parent, index) = child2 and
      child1 != child2
    }

    /** Holds if a member child relation is not reflected by `getChild`. */
    query predicate memberChildMissingFromGetChild(AstNode parent, AstNode child, string member) {
      exists(getEnclosingCallable(parent)) and
      exists(Expr grandparent | getChild(grandparent, _) = parent) and
      astMemberChild(parent, child, member) and
      not getChild(parent, _) = child
    }

    /** Holds if a `getChild` relation for a structured AST node has no matching member predicate. */
    query predicate getChildMissingFromMember(StructuredAstNode parent, int index, AstNode child) {
      child = getChild(parent, index) and
      not astMemberChild(parent, child, _)
    }
  }
}
