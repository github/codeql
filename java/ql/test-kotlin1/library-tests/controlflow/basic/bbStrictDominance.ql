import java
import semmle.code.java.controlflow.Dominance
import utils.test.BasicBlock

from BasicBlock b, BasicBlock b2
where b.strictlyDominates(b2)
select getFirstAstNode(b), getFirstAstNode(b2)
