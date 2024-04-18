import python

string repr(AstNode a) {
  not a instanceof StrConst and result = a.toString()
  or
  result = "\"" + a.(StrConst).getText() + "\""
}

from ControlFlowNode p, ControlFlowNode s, BasicBlock b, int n
where p.getASuccessor() = s and p = b.getNode(n)
select n, p.getLocation().getStartLine(), repr(p.getNode())
