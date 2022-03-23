import ruby
import codeql.ruby.controlflow.CfgNodes

query predicate exprValue(Expr e, ConstantValue v) { v = e.getConstantValue() }

query predicate exprCfgNodeValue(ExprCfgNode n, ConstantValue v) { v = n.getConstantValue() }
