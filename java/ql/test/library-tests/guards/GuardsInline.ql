import java
import semmle.code.java.controlflow.Guards
import codeql.util.Boolean

string ppGuard(Guard g, Boolean branch) {
  exists(MethodCall mc, Literal s |
    mc = g and
    mc.getAnArgument() = s and
    result = mc.getMethod().getName() + "(" + s.getValue() + ")" + ":" + branch
  )
  or
  exists(BinaryExpr bin |
    bin = g and
    result = "'" + bin.getLeftOperand() + bin.getOp() + bin.getRightOperand() + ":" + branch + "'"
  )
  or
  exists(SwitchCase cc, Expr s, string match, string value |
    cc = g and
    cc.getSelectorExpr() = s and
    (
      cc.(ConstCase).getValue().toString() = value
      or
      cc instanceof DefaultCase and value = "default"
    ) and
    if branch = true then match = ":match " else match = ":non-match "
  |
    result = "'" + s.toString() + match + value + "'"
  )
}

query predicate guarded(MethodCall mc, string guard) {
  mc.getMethod().hasName("chk") and
  exists(Guard g, BasicBlock bb, boolean branch |
    g.controls(bb, branch) and
    mc.getBasicBlock() = bb
  |
    guard = ppGuard(g, branch)
    or
    not exists(ppGuard(g, branch)) and
    guard = g.toString() + ":" + branch
  )
}
