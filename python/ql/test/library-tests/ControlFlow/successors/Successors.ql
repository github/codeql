import python

string loc(ControlFlowNode f) {
    exists(Location l |
        l = f.getLocation() |
        result = l.getFile().getBaseName() + ":" + l.getStartLine() + ":" + l.getStartColumn()
    )
}

from ControlFlowNode p, ControlFlowNode s, string what
where
s = p.getAFalseSuccessor() and what = "false"
or
s = p.getATrueSuccessor() and what = "true"
or
s = p.getAnExceptionalSuccessor() and what = "exceptional"
or
s = p.getANormalSuccessor() and what = "normal"
or
// Add fake edges for node that raise out of scope
p.isExceptionalExit(_) and s = p.getScope().getEntryNode() and what = "exit"

select loc(p), p.getNode().toString(), loc(s), s.getNode().toString(), what
