import default
import semmle.code.java.controlflow.Dominance

from Stmt pre, Stmt post
where strictlyPostDominates(post.getControlFlowNode(), pre.getControlFlowNode())
select post, pre
