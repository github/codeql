import java
import semmle.code.java.controlflow.Dominance

from BasicBlock b, BasicBlock b2
where b.strictlyDominates(b2)
select b, b2
