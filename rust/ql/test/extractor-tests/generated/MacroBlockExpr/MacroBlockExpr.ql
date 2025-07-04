// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

query predicate instances(MacroBlockExpr x) { toBeTested(x) and not x.isUnknown() }

query predicate getTailExpr(MacroBlockExpr x, Expr getTailExpr) {
  toBeTested(x) and not x.isUnknown() and getTailExpr = x.getTailExpr()
}

query predicate getStatement(MacroBlockExpr x, int index, Stmt getStatement) {
  toBeTested(x) and not x.isUnknown() and getStatement = x.getStatement(index)
}
