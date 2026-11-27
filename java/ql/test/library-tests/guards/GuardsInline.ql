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
    result =
      "'" + bin.getLeftOperand() + " " + bin.getOp() + " " + bin.getRightOperand() + ":" + branch +
        "'"
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
  or
  mc.getMethod().hasName("chk") and
  exists(Guard g, BasicBlock bb, GuardValue val |
    g.valueControls(bb, val) and
    not exists(val.asBooleanValue()) and
    mc.getBasicBlock() = bb
  |
    guard = "'" + g.toString() + ":" + val + "'"
  )
}
