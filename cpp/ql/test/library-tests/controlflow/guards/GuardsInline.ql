import cpp
import semmle.code.cpp.controlflow.Guards
import codeql.util.Boolean

bindingset[s]
string escape(string s) { if s.matches("% %") then result = "'" + s + "'" else result = s }

Expr getUnconverted(Element e) {
  not e instanceof Expr and
  result = e
  or
  result = e.(Expr).getUnconverted()
}

string ppGuard(IRGuardCondition g, GuardValue val) {
  exists(BinaryOperation bin |
    bin = getUnconverted(g.getAst()) and
    result =
      bin.getLeftOperand() + " " + bin.getOperator() + " " + bin.getRightOperand() + ":" + val
  )
  or
  exists(SwitchCase cc, Expr s, string value |
    cc = g.getAst() and
    cc.getExpr() = s and
    result = cc.getSwitchStmt().getExpr() + "=" + value + ":" + val
  |
    value = cc.getExpr().toString()
    or
    cc.isDefault() and value = "default"
  )
}

query predicate guarded(CallInstruction c, string guard) {
  c.getStaticCallTarget().hasName("chk") and
  exists(IRGuardCondition g, IRBlock bb, GuardValue val |
    g.valueControls(bb, val) and
    c.getBlock() = bb
  |
    guard = escape(ppGuard(g, val))
    or
    not exists(ppGuard(g, val)) and
    guard = escape(getUnconverted(g.getAst()).toString() + ":" + val)
  )
}
