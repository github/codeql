import default
import semmle.code.java.controlflow.Dominance

from BasicBlock b, BasicBlock b2
where bbStrictlyDominates(b, b2)
select b, b2
