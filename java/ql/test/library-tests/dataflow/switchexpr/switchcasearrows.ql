import java

query predicate exprs(SwitchCase sc, Expr e) { e = sc.getRuleExpression() }

query predicate stmts(SwitchCase sc, Stmt s) { s = sc.getRuleStatement() }
