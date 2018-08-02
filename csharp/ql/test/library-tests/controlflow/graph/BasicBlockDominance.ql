import csharp
import semmle.code.csharp.controlflow.BasicBlocks

from BasicBlock dom, BasicBlock bb, string s
where
  dom.dominates(bb) and s = "pre"
  or
  dom.postDominates(bb) and s = "post"
select s, dom.getFirstNode(), bb.getFirstNode()
