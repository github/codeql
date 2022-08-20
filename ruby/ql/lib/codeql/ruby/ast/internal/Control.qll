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
    toGenerated(result) = g.getChild(n) or
    toGenerated(result) = g.getChild(n)
  }
}

class CaseMatch extends CaseExprImpl, TCaseMatch {
  private Ruby::CaseMatch g;

  CaseMatch() { this = TCaseMatch(g) }

  final override Expr getValue() { toGenerated(result) = g.getValue() }

  final override AstNode getBranch(int n) {
    toGenerated(result) = g.getClauses(n)
    or
    n = count(g.getClauses(_)) and toGenerated(result) = g.getElse()
  }
}
