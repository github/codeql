import csharp
import Common

from SourceBasicBlock bb
where not bb.getFirstNode().getElement().fromLibrary()
select bb.getFirstNode(), bb.getLastNode(), bb.length()
