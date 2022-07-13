import ruby
import codeql.ruby.controlflow.CfgNodes

query predicate exprValue(Expr e, ConstantValue v, string t) {
  v = e.getConstantValue() and t = v.getValueType()
}

query predicate exprCfgNodeValue(ExprCfgNode n, ConstantValue v, string t) {
  v = n.getConstantValue() and t = v.getValueType()
}
