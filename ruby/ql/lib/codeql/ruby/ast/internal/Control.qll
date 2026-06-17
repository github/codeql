overlay[local]
module;

private import TreeSitter
private import codeql.ruby.AST
private import codeql.ruby.ast.internal.AST

abstract class CaseExprImpl extends ControlExpr, TCase {
  abstract Expr getValue();

  abstract AstNode getBranch(int n);
}

class CaseWhenClause extends CaseExprImpl, TCaseExpr {
  private Ruby::Case g;

  CaseWhenClause() { this = TCaseExpr(g) }

  final override Expr getValue() { toGenerated(result) = g.getValue() }

  final override AstNode getBranch(int n) {
    // When branches map directly to WhenClause nodes
    toGenerated(result) = g.getChild(n) and not g.getChild(n) instanceof Ruby::Else
    or
    // The else branch is wrapped in a synthesized CaseElseBranch node
    g.getChild(n) instanceof Ruby::Else and result = getSynthChild(this, n)
  }
}

class CaseMatch extends CaseExprImpl, TCaseMatchReal {
  private Ruby::CaseMatch g;

  CaseMatch() { this = TCaseMatchReal(g) }

  final override Expr getValue() { toGenerated(result) = g.getValue() }

  final override AstNode getBranch(int n) {
    toGenerated(result) = g.getClauses(n)
    or
    // The else branch is wrapped in a synthesized CaseElseBranch node
    n = count(g.getClauses(_)) and exists(g.getElse()) and result = getSynthChild(this, n)
  }
}

class CaseMatchSynth extends CaseExprImpl, TCaseMatchSynth {
  CaseMatchSynth() { this = TCaseMatchSynth(_, _) }

  final override Expr getValue() { synthChild(this, 0, result) }

  final override AstNode getBranch(int n) { n >= 0 and synthChild(this, n + 1, result) }
}

abstract class InClauseImpl extends AstNode, TInClause {
  abstract Stmt getBody();

  abstract CasePattern getPattern();

  Expr getCondition() { none() }

  predicate hasIfCondition() { none() }

  predicate hasUnlessCondition() { none() }
}

class InClauseReal extends InClauseImpl, TInClauseReal {
  private Ruby::InClause g;

  InClauseReal() { this = TInClauseReal(g) }

  final override Stmt getBody() { toGenerated(result) = g.getBody() }

  final override CasePattern getPattern() { toGenerated(result) = g.getPattern() }

  final override Expr getCondition() { toGenerated(result) = g.getGuard().getAFieldOrChild() }

  final override predicate hasIfCondition() { g.getGuard() instanceof Ruby::IfGuard }

  final override predicate hasUnlessCondition() { g.getGuard() instanceof Ruby::UnlessGuard }
}

class InClauseSynth extends InClauseImpl, TInClauseSynth {
  InClauseSynth() { this = TInClauseSynth(_, _) }

  final override Stmt getBody() { synthChild(this, 1, result) }

  final override CasePattern getPattern() { synthChild(this, 0, result) }

  final override Expr getCondition() { none() }

  final override predicate hasIfCondition() { none() }

  final override predicate hasUnlessCondition() { none() }
}

class CaseElseBranchImpl extends AstNode, TCaseElseBranch {
  CaseElseBranchImpl() { this = TCaseElseBranchSynth(_, _) }

  final StmtSequence getBody() { synthChild(this, 0, result) }
}
