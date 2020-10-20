import csharp
import Common

from SourceBasicBlock bb
where bb.getLocation().getFile().fromSource()
select bb.getFirstNode(), bb.getLastNode(), bb.length()
