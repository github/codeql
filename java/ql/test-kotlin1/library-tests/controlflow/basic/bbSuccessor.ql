import java
import utils.test.BasicBlock

from BasicBlock b, BasicBlock b2
where b.getASuccessor() = b2
select getFirstAstNodeOrSynth(b), getFirstAstNodeOrSynth(b2)
