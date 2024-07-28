import default
import semmle.code.java.controlflow.Dominance

from Stmt pre, Stmt post
where strictlyPostDominates(post, pre)
select post, pre
