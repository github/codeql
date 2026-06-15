import default
import semmle.code.java.controlflow.Dominance

from Stmt pre, Stmt post
where strictlyDominates(pre.getControlFlowNode(), post.getControlFlowNode())
select pre, post
