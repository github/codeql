import javascript

from ReachableBasicBlock dom, ReachableBasicBlock bb
where dom.strictlyPostDominates(bb)
select dom, bb
