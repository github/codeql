import csharp
import Common

from SourceBasicBlock dom, SourceBasicBlock bb, string s
where
  dom.dominates(bb) and s = "pre"
  or
  dom.postDominates(bb) and s = "post"
select s, dom.getFirstNode(), bb.getFirstNode()
