import csharp

query predicate switchExprs(SwitchExpr switch, Expr e) { e = switch.getExpr() }

query predicate switchExprCases(SwitchCaseExpr case, Expr pattern, Expr res) {
  pattern = case.getPattern() and res = case.getBody()
}

query predicate switchFilters(SwitchCaseExpr case, Expr when) { when = case.getCondition() }

query predicate propertyPatterns(PropertyPatternExpr pp) { any() }

query predicate propertyPatternChild(PropertyPatternExpr pp, int n, Expr child) {
  child = pp.getPattern(n)
}

query predicate positionalPatterns(PositionalPatternExpr pp, Expr parent, int n, Expr child) {
  parent = pp.getParent() and
  child = pp.getPattern(n)
}

query predicate caseStatements(CaseStmt case) { any() }

private class RecursivePatternCase extends CaseStmt {
  private RecursivePatternExpr p;

  RecursivePatternCase() { p = this.getPattern() }

  RecursivePatternExpr getRecursivePattern() { result = p }
}

query predicate recursivePatternCases(RecursivePatternCase case, RecursivePatternExpr p) {
  p = case.getRecursivePattern()
}

query predicate recursiveCasePatternDecl(
  RecursivePatternCase case, TypeAccess ta, LocalVariableDeclExpr decl
) {
  ta = case.getRecursivePattern().getTypeAccess() and
  decl = case.getRecursivePattern().getVariableDeclExpr()
}

query predicate recursivePatternDecl(RecursivePatternExpr pattern, LocalVariableDeclExpr decl) {
  decl = pattern.getVariableDeclExpr()
}

query predicate recursivePatterns(RecursivePatternExpr expr) { any() }

query predicate discards(DiscardExpr discard) { any() }

query predicate isExprs(IsExpr is) { any() }

private class IsRecursivePatternExpr extends IsExpr {
  private RecursivePatternExpr p;

  IsRecursivePatternExpr() { p = this.getPattern() }

  RecursivePatternExpr getRecursivePattern() { result = p }
}

query predicate isRecursivePatternExpr(IsRecursivePatternExpr expr) { any() }

query predicate isRecursivePatternExprWithDecl(
  IsRecursivePatternExpr expr, LocalVariableDeclExpr decl
) {
  decl = expr.getRecursivePattern().getVariableDeclExpr()
}

query predicate labeledPatternExpr(LabeledPatternExpr e, string s) { s = e.getLabel() }
